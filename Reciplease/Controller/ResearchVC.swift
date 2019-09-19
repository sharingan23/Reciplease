//
//  ResearchVC.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 11/06/2019.
//

import UIKit
import Kingfisher

class ResearchVC: UIViewController {
    
    var search = SearchManager(recipeSession: URLSession(configuration: .default))
    
    var searchIngredients : String?
    
    var listRecipe : [String] = []
    
    var dataRecipe : Recipes?
    
    var url : URL?

    var listIngredients : [String] = []
    
    var ingredientsString = ""
    
    var isFavorite = true
    
    @IBOutlet weak var tblResults: UITableView!
    @IBOutlet weak var lblNoFavorite: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Reciplease"
        lblNoFavorite.isHidden = true
        if isFavorite{
            if listRecipe.isEmpty{
                lblNoFavorite.isHidden = false
            }
        }else{
            self.tabBarController?.tabBar.isHidden              = true
            getRecipe(ingredients: searchIngredients!)
        }
        tblResults.tableFooterView = UIView()
        
        tblResults.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func getRecipe(ingredients: String){
        search.getRecip(ingredients: ingredients) { (recipe, error) in
            //print("Test ....\(recipe?.hits?[0].label)")
            print("Test ....\(recipe?.hits[0].recipe.label)")
            
            if let recipe = recipe {
                self.dataRecipe = recipe
                for  item in recipe.hits {
                    self.listRecipe.append(item.recipe.label)
                    print("in function \(item.recipe.label)")
                }
            }
            self.tblResults.reloadData()
        }
    }
    
    func listIngredientsToString(listIngredients: [String]) -> String {
        
        for ingredients in listIngredients{
            ingredientsString += "\(ingredients) ,"
        }
        return ingredientsString
    }
}

extension ResearchVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRecipe.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        
        cell.recipeNameLbl.text = dataRecipe?.hits[indexPath.row].recipe.label
        
        url = URL(string: (dataRecipe?.hits[indexPath.row].recipe.image)!)
        
        cell.recipeImg.kf.setImage(with: url)
        
        cell.recipeImg.contentMode = .scaleAspectFill
        
        /*let data = try? Data(contentsOf: url!)
        
        cell.recipeImg.image = UIImage(data: data!)
        
        */
        
        //cell.ingredientsLbl.text = listIngredientsToString(listIngredients: (dataRecipe?.hits[indexPath.row].recipe.healthLabels)!)
        
        print("in cells \(listRecipe)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IngredientsVC") as? IngredientsVC {
            
            if let navigator = navigationController {
                
                let backItem = UIBarButtonItem()
                backItem.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                viewController.indexRecipe = indexPath.row
                viewController.dataRecipe = self.dataRecipe
                
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

