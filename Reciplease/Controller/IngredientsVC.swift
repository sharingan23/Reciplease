//
//  IngredientsVC.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 10/09/2019.
//

import UIKit
import Kingfisher

class IngredientsVC: UIViewController {
    
    let favoriteUncheck = UIImage(named: "favoriteUnCheck")
    let favoriteCheck = UIImage(named: "favoriteCheck")
    
    var isFavorite = false
    
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    var dataRecipe : Recipes?
    
    var indexRecipe : Int? = nil
    
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
        
        recipeName.text = dataRecipe?.hits[indexRecipe!].recipe.label
        
        let url = URL(string: (dataRecipe?.hits[indexRecipe!].recipe.image)!)
        
        imgRecipe.kf.setImage(with: url)
        
       /* let data = try? Data(contentsOf: url!)
        
       imgRecipe.image = UIImage(data: data!)*/

       //imgRecipe.contentMode = .scaleAspectFil
        // Do any additional setup after loading the view.
    }
    
    func addRightBarButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteUncheck, style: .done, target: self, action: #selector(checkFavorite))
    }
    
    func saveRecipe() {
    }
    
    @objc func checkFavorite(sender: UIButton) {
        if isFavorite{
            self.navigationItem.rightBarButtonItem?.image =  favoriteUncheck
            isFavorite = false
        }else{
            self.navigationItem.rightBarButtonItem?.image =  favoriteCheck
            isFavorite = true
            
        }
        
    }
}

extension IngredientsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataRecipe?.hits[indexRecipe!].recipe.ingredientLines.count)!
        
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
        
        cell.lblingredients.text = dataRecipe?.hits[indexRecipe!].recipe.ingredientLines[indexPath.row]
        
        return cell
    }
    
}
