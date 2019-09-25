//
//  SearchManager.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 11/06/2019.
//

import Foundation
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
class SearchManager {
    let app_key = "ee348a318fd1b8d69c386392af8d06cc"
    let app_id = "5dc02db6"
    
    private var recipeSession = URLSession(configuration: .default)
    // Initialization URLSession
    init(recipeSession: URLSession) {
        self.recipeSession = recipeSession
    }
    
    //function that retrieive JSON from server and convert the data into our struct
    func getRecip(ingredients: String, completionHandler: @escaping (Recipes?, Error?) -> Void) {
        let request = createRecipeRequest(ingredients: ingredients) 
            
        let task = recipeSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler( nil, error)
                    return
                }
                    
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler( nil, error)
                    return
                }
                do {
                    // try to decode the JSON
                    let responseJSON = try JSONDecoder().decode(Recipes.self, from: data)
                    completionHandler(responseJSON, nil)
                } catch {
                    completionHandler( nil, error)
                }
            }
        }
        task.resume()
    }
    
    //function that retrieive JSON from server and convert the data into our struct
    
    func getRecipAlamo(ingredients: String, completionHandler: @escaping (Recipes?, Error?) -> Void) {
        Alamofire.request("https://api.edamam.com/search?", method: .get, parameters: ["q": ingredients,"app_id" : app_id,"app_key" :app_key])
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
        
    // Request
    func createRecipeRequest(ingredients: String) -> URLRequest {
        
        let request = URLRequest(url: URL(string: "https://api.edamam.com/search?q=\(ingredients)&app_id=\(app_id)&app_key=\(app_key)")!)
            
        return request
    }
}
