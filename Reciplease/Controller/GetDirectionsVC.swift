//
//  GetDirectionsVC.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 29/01/2020.
//

import UIKit
import WebKit

class GetDirectionsVC: UIViewController {

    class func initiateController() -> GetDirectionsVC {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let controller  = storyboard.instantiateViewController(withIdentifier: "GetDirectionsVC") as! GetDirectionsVC
        return controller
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    var url :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlUnwrap = url {
            sendRequest(urlString: urlUnwrap)
        }else{
            print("Eroor url")
        }
    }
    
    // Convert String into URL and load the URL
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
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
