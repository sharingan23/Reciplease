//
//  Ingredient+CoreDataClass.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 21/09/2019.
//
//

import Foundation
import CoreData

@objc(Ingredient)
public class Ingredient: NSManagedObject {
    
    static var allIngredient: [Ingredient]{
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        guard let ingredients = try? AppDelegate.viewContext.fetch(request) else {return []}
        
        return ingredients
    }
    
    
    static func deleteIngredient(index: Int){
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        if let ingredientTest = try? AppDelegate.viewContext.fetch(request){
            //AppDelegate.viewContext.delete(recipe)
            AppDelegate.viewContext.delete(ingredientTest[index])
        }
    }
    
    static func deleteALLRecipe(){
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        if let ingredientTest = try? AppDelegate.viewContext.fetch(request){
            //AppDelegate.viewContext.delete(recipe)
            
            for ingredient in ingredientTest{
                AppDelegate.viewContext.delete(ingredient)
            }
        }
    }

}
