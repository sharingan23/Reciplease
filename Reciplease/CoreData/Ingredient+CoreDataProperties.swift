//
//  Ingredient+CoreDataProperties.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 21/09/2019.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var newRelationship: Recipe?

}
