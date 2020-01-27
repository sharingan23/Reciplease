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
    
    let favoriteUncheck = UIImage(named: "favoriteUnCheck")
    let favoriteCheck = UIImage(named: "favoriteCheck")
    
    var fromFavorite = true
    var isFavorite = true
    
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var ingredientLbl: UILabel!
    
    
    @IBOutlet weak var ingredientTbl: UITableView!
    var dataRecipe : Recipes.Recipe?
    
    var indexRecipe : Int? = nil
    
    var listRecipeFavorite: [Recipe]?
    
    var url : URL?
    
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
        ingredientTbl.tableFooterView = UIView()
        
        if isFavorite{
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
            
            for ingredientsL in recipeFavorite.ingredientLines{
                
            ingredientsOneline += ("\(ingredientsL) ")
                
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
        }else{
            ingredientLbl.isHidden = true
            cell.lblingredients.text = dataRecipe!.ingredientLines[indexPath.row]
            
        }
        
        return cell
    }
}
