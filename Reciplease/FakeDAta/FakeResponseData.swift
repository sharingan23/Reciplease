//
//  FakeResponseData.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 17/10/2019.
//
import Foundation

class FakeResponseData {
    // MARK: - Data
    static var recipeCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Recipe", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let recipeIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: - Error
    class RecipeError: Error {}
    static let error = RecipeError()
}
