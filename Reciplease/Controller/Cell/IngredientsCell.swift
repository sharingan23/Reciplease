//
//  IngredientsCell.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 05/06/2019.
//

import UIKit

class IngredientsCell: UITableViewCell {

    @IBOutlet weak var ingredients: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
