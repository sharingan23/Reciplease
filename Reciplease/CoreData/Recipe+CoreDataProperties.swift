//
//  Recipe+CoreDataProperties.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 27/09/2019.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var source: String?
    @NSManaged public var timeRecipe: String?
    @NSManaged public var urlImage: String?
    @NSManaged public var ingredients: String?

}
