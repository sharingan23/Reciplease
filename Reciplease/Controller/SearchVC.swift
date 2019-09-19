//
//  SearchVC.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 05/06/2019.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tblIngredients: UITableView!
    
    @IBOutlet weak var searchTF: UITextField!
    
    var listIngredients : [String] = []
    var stringIngredients : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblIngredients.tableFooterView = UIView()
        navigationItem.title = "Reciplease"
        
        //title color
        /*let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 20)!]*/
        
        //nav white color
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2117647059, green: 0.2, blue: 0.1960784314, alpha: 1)
        //hide line from navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden              = false
    }
    
    func listIngredientsToString(listIngredients: [String]) -> String {
        
        for ingredients in listIngredients{
            stringIngredients! += "+\(ingredients)"
        }
        return stringIngredients!
    }
    
    @IBAction func addIngredients(_ sender: Any) {
        if let searchTF = searchTF{
        let ingredient = "- \(searchTF.text!)"
        listIngredients.append(ingredient)
        stringIngredients = searchTF.text!
        tblIngredients.reloadData()
        }
    }
    
    
    @IBAction func clearIngredients(_ sender: Any) {
        listIngredients.removeAll()
        tblIngredients.reloadData()
    }
    
    @IBAction func searchForRecipes(_ sender: Any) {
        
        if listIngredients.isEmpty {
        // create the alert
        let alert = UIAlertController(title: "No ingredient", message: "Please add ingredients.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
            
        }else {
            let backItem = UIBarButtonItem()
            backItem.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            print(listIngredients)
            print(stringIngredients)
            
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let researchVC = storyboard.instantiateViewController(withIdentifier: "ResearchVC")as! ResearchVC
            
            // Communicate with new VC - These values are stored in the destination
            // you can set any value stored in the destination VC here
            researchVC.searchIngredients = stringIngredients
            researchVC.isFavorite = false
            self.navigationController?.pushViewController(researchVC, animated: true)
        }
    }
    
    @IBAction func dissmissTapKeyboard(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension SearchVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIngredients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
        
        cell.ingredients.text = listIngredients[indexPath.row]
        
        return cell
    }
}
