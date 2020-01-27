//
//  FakeServiceAPI.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 17/10/2019.
//

import Foundation
import UIKit


protocol NetworkRequest {
    func request(_ url: URL, completionHandler: (Recipes?, Error?) -> Void)
}

struct AlamofireNetworkRequest: NetworkRequest {
    func request(_ url: URL, completionHandler: (Recipes?, Error?) -> Void) {
        
    }
}

struct FakeNetworkRequest: NetworkRequest {
    var error: Error?
    var response: Data?
    func request(_ url: URL, completionHandler: (Recipes?, Error?) -> Void) {
        
        if error != nil {
            completionHandler(nil, error)
        } else {
            do{
                let responseJSON = try JSONDecoder().decode(Recipes.self, from: response!)
                completionHandler(responseJSON, error)
                
            }catch{
                completionHandler(nil, error)
            }
        }
    }
}

class FakeServiceAPI {
    
    var networkRequest: NetworkRequest!
    
    typealias GetRecipeHandler = (Recipes?, Error?) -> Void
    func getRecipe(completionHandler: GetRecipeHandler) {
        networkRequest.request(URL(string: "")!) { (recipe: Recipes?, error: Error?) in
            completionHandler(recipe, error)
        }
    }
}
