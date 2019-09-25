//
//  Recipe+CoreDataClass.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 21/09/2019.
//
//

import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {
    static var allRecipe: [Recipe]{
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {return []}
        
        return recipes
    }
    
    
    static func deleteRecipe(index: Int){
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        if let recipeTest = try? AppDelegate.viewContext.fetch(request){
            //AppDelegate.viewContext.delete(recipe)
                AppDelegate.viewContext.delete(recipeTest[index])
        }
    }
    
    static func deleteALLRecipe(){
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        if let recipeTest = try? AppDelegate.viewContext.fetch(request){
            //AppDelegate.viewContext.delete(recipe)
            
            for recipe in recipeTest{
                AppDelegate.viewContext.delete(recipe)
            }
        }
    }
}
