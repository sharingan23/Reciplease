//
//  SearchManager.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 11/06/2019.
//

import Foundation
import UIKit
import Alamofire

struct Recipes: Codable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit

extension Recipes{
struct Hit: Codable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let source: String
    let url: String
    let shareAs: String
    let yield: Int
    let dietLabels, healthLabels, cautions, ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime : Float
    
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let weight: Double
}

}

protocol NetworkRequest {
    func request(_ url: URL,ingredients: String, completionHandler: @escaping(Recipes?, Error?) -> Void)
}

struct AlamofireNetworkRequest: NetworkRequest {
    func request(_ url: URL,ingredients: String, completionHandler: @escaping(Recipes?, Error?) -> Void) {
        Alamofire.request("https://api.edamam.com/search?", method: .get, parameters: ["q": ingredients,"app_id" : macros.app_id,"app_key" :macros.app_key])
            .validate()
            .responseJSON {response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let responseJSON = try decoder.decode(Recipes.self, from: data)
                    completionHandler(responseJSON, nil)
                } catch let error {
                    print(error)
                    completionHandler(nil, error)
                }
        }
    }
}

struct FakeNetworkRequest: NetworkRequest {
    var error: Error?
    var response: Data?
    func request(_ url: URL,ingredients: String, completionHandler: (Recipes?, Error?) -> Void) {
        if error != nil {
            completionHandler(nil, error)
        } else {
            guard let response = response else {
                return completionHandler(nil, error)
            }
            
            do {
                let decoder = JSONDecoder()
                let responseJSON = try decoder.decode(Recipes.self, from: response)
                completionHandler(responseJSON, nil)
            } catch let error {
                print(error)
                completionHandler(nil, error)
            }
        }
    }
}

class SearchManager {
    
    var networkRequest: NetworkRequest = AlamofireNetworkRequest()
}
