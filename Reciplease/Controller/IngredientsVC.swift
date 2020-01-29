//
//  IngredientsVC.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 10/09/2019.
//

import UIKit
import Kingfisher
import CoreData

class IngredientsVC: UIViewController {
    
    //Images
    let favoriteUncheck = UIImage(named: "favoriteUnCheck")
    let favoriteCheck = UIImage(named: "favoriteCheck")
    
    //Check if the view is from favorite view or search View
    var fromFavorite = true
    var isFavorite = true
    
    // MARK: -OUTLET
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var ingredientLbl: UILabel!
    
    
    @IBOutlet weak var ingredientTbl: UITableView!
    
    
    // MARK:- VARIABLES
    var dataRecipe : Recipes.Recipe?
    
    var indexRecipe : Int? = nil
    
    var listRecipeFavorite: [Recipe]?
    
    var url : URL?
    
    
    //INITIATE CONTROLLER
    class func initiateController() -> IngredientsVC {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let controller  = storyboard.instantiateViewController(withIdentifier: "IngredientsVC") as! IngredientsVC
        return controller
    }

    
    let sectionName = ["Ingredients"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRightBarButton()
        
        navigationItem.title = "Reciplease"
        
        ingredientLbl.isHidden = true
        ingredientTbl.isHidden = false
        ingredientTbl.tableFooterView = UIView()
        
        if isFavorite{
            ingredientTbl.isHidden = true
            recipeName.text = Recipe.allRecipe[indexRecipe!].name
            url = URL(string: (Recipe.allRecipe[indexRecipe!].urlImage)!)
            ingredientLbl.isHidden = false
            //cell.lblingredients.text = Recipe.allRecipe[indexRecipe!].ingredients
            ingredientLbl.text = Recipe.allRecipe[indexRecipe!].ingredients
            imgRecipe.kf.setImage(with: url)
        }else{
            recipeName.text = dataRecipe!.label
            url = URL(string: (dataRecipe?.image)!)
            imgRecipe.kf.setImage(with: url)
        }
        
       /* let data = try? Data(contentsOf: url!)
        
       imgRecipe.image = UIImage(data: data!)*/

       //imgRecipe.contentMode = .scaleAspectFil
        // Do any additional setup after loading the view.
    }
    
    //MARK:- FUNCTIONS
    func addRightBarButton(){
        if isFavorite{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteCheck, style: .done, target: self, action: #selector(checkFavorite))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteUncheck, style: .done, target: self, action: #selector(checkFavorite))
        }
    }
    
    func saveRecipe() {
        var ingredientsOneline = ""
        let ctx = AppDelegate.viewContext
        let recipe = Recipe(context: ctx)
        
        if let recipeFavorite = dataRecipe{
                recipe.name = (recipeFavorite.label)
                recipe.urlImage = (recipeFavorite.image)
                recipe.url = (recipeFavorite.url)
            
            for ingredientsL in recipeFavorite.ingredientLines{
                
            ingredientsOneline += ("\(ingredientsL) ")
                //recipe.ingredients?.append(ingredientsL)
            }
            
                recipe.ingredients = ingredientsOneline
            
            try? AppDelegate.viewContext.save()
            
           
        }else{
            print("no recipe")
        }
    }
    
    func deleteRecipe(index: Int) {
        Recipe.deleteRecipe(index: index)
        
        try? AppDelegate.viewContext.save()
    }
    
    func deleteAllRecipe() {
        Recipe.deleteALLRecipe()
        
        try? AppDelegate.viewContext.save()
    }
    
    //MARK:- ACTIONS
    
    @IBAction func getDirectionsTapped(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetDirectionsVC") as? GetDirectionsVC {
            
            if let navigator = navigationController {
                
                let backItem = UIBarButtonItem()
                backItem.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                if fromFavorite{
                    viewController.url = Recipe.allRecipe[indexRecipe!].url
                }else{
                    viewController.url = dataRecipe!.url
                }
                

                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc func checkFavorite(sender: UIButton) {
        if isFavorite{
            if fromFavorite{
                self.navigationItem.rightBarButtonItem?.image =  favoriteUncheck
                deleteRecipe(index: indexRecipe!)
                isFavorite = false
                
                navigationController!.popViewController(animated: true)
            }else{
                self.navigationItem.rightBarButtonItem?.image =  favoriteUncheck
                deleteRecipe(index: indexRecipe!)
                isFavorite = false
            }
        }else{
            self.navigationItem.rightBarButtonItem?.image =  favoriteCheck
            isFavorite = true
            saveRecipe()
        }
    }
}



//MARK:- Extension
extension IngredientsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavorite{
            return 0
        }else{
            return (dataRecipe?.ingredientLines.count)!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsSectionHeaderCell") as! IngredientsSectionHeaderCell
        
        cell.lblForHeadingSection.text = sectionName[section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailCell") as!  IngredientsDetailCell
        
        if fromFavorite {
            //cell.lblingredients.text = Recipe.allRecipe[indexRecipe!].ingredients![indexPath.row]
        }else{
            ingredientLbl.isHidden = true
            cell.lblingredients.text = dataRecipe!.ingredientLines[indexPath.row]
            
        }
        
        return cell
    }
}
