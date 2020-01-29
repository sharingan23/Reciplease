//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Vigneswaranathan Sugeethkumar on 05/06/2019.
//

import XCTest
@testable import Reciplease

class RecipleaseTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetRecipeShouldPostFailedCallbackIfNil() {
        // Given
        let recipeService = SearchManager()
        
        recipeService.networkRequest =  FakeNetworkRequest(error: nil, response: nil)
        
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        //recipeService.getRecipe { (recipe, error) in
        
        recipeService.networkRequest.request(URL(string: "https://api.edamam.com/search?")!, ingredients: "test") { (recipe, error) in
            
            XCTAssertNil(recipe)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfError() {
        // Given
        let recipeService = SearchManager()
        let errorFake: Error?
        
        errorFake = ErrorFake()
        
        recipeService.networkRequest =  FakeNetworkRequest(error: errorFake, response: nil)
        
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        //recipeService.getRecipe { (recipe, error) in
        
        recipeService.networkRequest.request(URL(string: "https://api.edamam.com/search?")!, ingredients: "test") { (recipe, error) in
            
            XCTAssertNil(recipe)
            XCTAssert(error is ErrorFake)
            XCTAssertNotNil((error))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let recipeService = SearchManager()
        
        recipeService.networkRequest =  FakeNetworkRequest(error: nil, response: FakeResponseData.recipeCorrectData)
        
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipeService.networkRequest.request(URL(string: "https://api.edamam.com/search?")!, ingredients: "test") { (recipe, error) in
            
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetRecipeShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let recipeService = SearchManager()
        
            recipeService.networkRequest =  FakeNetworkRequest(error: nil, response: FakeResponseData.recipeIncorrectData)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.networkRequest.request(URL(string: "https://api.edamam.com/search?")!, ingredients: "test") { (recipe, error) in
            // Then
            let recipeName = "Chicken Vesuvio"
            
            XCTAssertNotNil(error)
            XCTAssertNotEqual(recipeName, recipe?.hits[0].recipe.label)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
   func testGetRecipeShouldPostSucessCallbackIfCorrectData() {
        // Given
        let recipeService = SearchManager()
        
        recipeService.networkRequest =  FakeNetworkRequest(error: nil, response: FakeResponseData.recipeCorrectData)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.networkRequest.request(URL(string: "https://api.edamam.com/search?")!, ingredients: "test") { (recipe, error) in
            // Then
            let recipeName = "Chicken Vesuvio"
            
            XCTAssertNil(error)
            
            XCTAssertEqual(recipeName, recipe?.hits[0].recipe.label)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testSaveRecipeInCoreDataShouldSucess() {
        Recipe.deleteALLRecipe()
        
        XCTAssertTrue((Recipe.allRecipe.count == 0))
        let ctx = AppDelegate.viewContext
        let recipe = Recipe(context: ctx)
    
        recipe.name = "Chicken"
        
        try? ctx.save()
        
        XCTAssertTrue(Recipe.allRecipe.contains(where: { $0.name == "Chicken"}))

        XCTAssertTrue((Recipe.allRecipe.count == 1))
    }
    
    func testDeleteARecipeShouldPostSucess(){
        Recipe.deleteALLRecipe()
        
        XCTAssertTrue((Recipe.allRecipe.count == 0))
        
        let ctx = AppDelegate.viewContext
        let recipe = Recipe(context: ctx)
        
        recipe.name = "Chicken"
        
        
        try? ctx.save()
        
        XCTAssertTrue((Recipe.allRecipe.count == 1))
        
        XCTAssertTrue(Recipe.allRecipe.contains(where: { $0.name == "Chicken"}))
        
        Recipe.deleteRecipe(index: 0)
    
        XCTAssertTrue((Recipe.allRecipe.count == 0))
    }
    
    func testDeleteALLRecipeShouldPostSucess(){
        Recipe.deleteALLRecipe()
        
        XCTAssertTrue((Recipe.allRecipe.count == 0))
        
        let ctx = AppDelegate.viewContext
        
        let recipe = Recipe(context: ctx)
        recipe.name = "Chicken"
        
        let recipe1 = Recipe(context: ctx)
        recipe1.name = "Mojito"
        
        let recipe2 = Recipe(context: ctx)
        recipe2.name = "Biriyani"
        
        try? ctx.save()
        
        
        XCTAssertTrue((Recipe.allRecipe.count == 3))
        
        XCTAssertTrue(Recipe.allRecipe.contains(where: { $0.name == "Chicken"}))
        XCTAssertTrue(Recipe.allRecipe.contains(where: { $0.name == "Biriyani"}))
        XCTAssertTrue(Recipe.allRecipe.contains(where: { $0.name == "Mojito"}))
        
        Recipe.deleteALLRecipe()
        
        XCTAssertTrue((Recipe.allRecipe.count == 0))
    }
}
