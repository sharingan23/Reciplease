//
//  ResearchVC.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 11/06/2019.
//

import UIKit
import Kingfisher

class ResearchVC: UIViewController {
    
    //MARK:- Images
    let deleteAllImage = UIImage(named: "deleteAll")
    
    // MARK:- VARIABLES
    var search = SearchManager()
    
    var searchIngredients : String?

    var listRecipe : [String] = []
    
    var dataRecipe : Recipes?
    
    var url : URL?

    var listIngredients : [String] = []
    
    var ingredientsString = ""
    
    //Check if the favorite view or not
    var isFavorite = true
    
    // MARK:- OUTLET
    @IBOutlet weak var tblResults: UITableView!
    @IBOutlet weak var lblNoFavorite: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayRecipeList()
        
        addRightBarButton()
        
        navigationItem.title = "Reciplease"
        lblNoFavorite.isHidden = true
        
        // if Favorite get recipe from Core Data
        if isFavorite{
            if Recipe.allRecipe.isEmpty{
                print("No favorite yet")
                lblNoFavorite.isHidden = false
            }else{
                lblNoFavorite.isHidden = true
                tblResults.tableFooterView = UIView()
                tblResults.reloadData()
            }
        }else{
            self.tabBarController?.tabBar.isHidden              = true
    
            getRecipeAlamo(ingredients: searchIngredients!)
            
            tblResults.tableFooterView = UIView()
            tblResults.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFavorite{
            if Recipe.allRecipe.isEmpty{
                print("No favorite yet")
                lblNoFavorite.isHidden = false
            }else{
                lblNoFavorite.isHidden = true
                tblResults.tableFooterView = UIView()
                tblResults.reloadData()
            }
        }else{
            self.tabBarController?.tabBar.isHidden              = true
        
            getRecipeAlamo(ingredients: searchIngredients!)
        }
        tblResults.tableFooterView = UIView()
        
        tblResults.reloadData()
    }
    
    /*func favoriteList(){
        for recipe in Recipe.allRecipe{
            if recipe.name == nil{
                
            }else{
                listRecipe.append(recipe.name!)
            }
        }
    }*/
    
    // MARK:- FUNCTION
    
    func addRightBarButton(){
        if isFavorite{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: deleteAllImage, style: .done, target: self, action: #selector(deleteAll))
        }
    }
    
    @objc func deleteAll(sender: UIButton) {
        deleteAllRecipe()
        tblResults.reloadData()
    }
    
    func deleteAllRecipe() {
        Recipe.deleteALLRecipe()
        try? AppDelegate.viewContext.save()
    }
    
    func getRecipeAlamo(ingredients: String){
        search.networkRequest.request(URL(string: "https://api.edamam.com/search?")!, ingredients: ingredients) { (recipe, error) in
                if let recipe = recipe {
                    self.dataRecipe = recipe
                    for  item in recipe.hits {
                        self.listRecipe.append(item.recipe.label)
                    }
                }
                self.tblResults.reloadData()
            }
        }
    
    func displayRecipeList()  {
        var recipeNameText = ""
        
        for recipe in Recipe.allRecipe {
            if let name = recipe.name{
                recipeNameText += name + "\n"
            }
        }
    }
    
    func listIngredientsToString(listIngredients: [String]) -> String {
        
        for ingredients in listIngredients{
            ingredientsString += "\(ingredients) ,"
        }
        return ingredientsString
    }
}


// MARK:- Extension
extension ResearchVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavorite{
            print("favorite item : \(Recipe.allRecipe.count)")

            return Recipe.allRecipe.count
        }else{
            print("no favorite item : \(listRecipe.count)")
            return dataRecipe?.hits.count ?? 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        
        if isFavorite{
            //cell.recipeNameLbl.text = Recipe.allRecipe[indexPath.row].name
            cell.ingredientsLbl.text = Recipe.allRecipe[indexPath.row].ingredients
            
            if let urlUnwrap = Recipe.allRecipe[indexPath.row].urlImage {
                url = URL(string: urlUnwrap)
                cell.recipeImg.kf.setImage(with: url)
                
                cell.recipeImg.contentMode = .scaleAspectFill
            }else{
                cell.recipeImg.image = UIImage(contentsOfFile: "noImage")
            }
            //url = URL(string: (Recipe.allRecipe[indexPath.row].urlImage!))
            
            cell.recipeImg.kf.setImage(with: url)
            
            cell.recipeImg.contentMode = .scaleAspectFill
            
        }else{
        
            cell.recipeNameLbl.text = dataRecipe?.hits[indexPath.row].recipe.label
            cell.lblTime.text = "\((dataRecipe?.hits[indexPath.row].recipe.totalTime)!)"
            cell.ingredientsLbl.text = dataRecipe?.hits[indexPath.row].recipe.source
            
            if let urlUnwrap = (dataRecipe?.hits[indexPath.row].recipe.image) {
        
                url = URL(string: urlUnwrap)
                cell.recipeImg.kf.setImage(with: url)
        
                cell.recipeImg.contentMode = .scaleAspectFill
            }else{
                cell.recipeImg.image = UIImage(contentsOfFile: "noImage")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFavorite == false{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IngredientsVC") as? IngredientsVC {
            
                if let navigator = navigationController {
                
                    let backItem = UIBarButtonItem()
                    backItem.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                
                    viewController.indexRecipe = indexPath.row
                    viewController.dataRecipe = self.dataRecipe?.hits[indexPath.row].recipe
                    viewController.isFavorite = false
                    viewController.fromFavorite = false
                
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }else{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IngredientsVC") as? IngredientsVC {
                
                if let navigator = navigationController {
                    
                    let backItem = UIBarButtonItem()
                    backItem.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                    viewController.fromFavorite = true
                    viewController.indexRecipe = indexPath.row
                    
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Recipe.deleteRecipe(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

