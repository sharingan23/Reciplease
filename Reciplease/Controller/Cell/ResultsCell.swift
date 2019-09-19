//
//  ResultsCell.swift
//  Reciplease
//
//  Created by Vigneswaranathan Sugeethkumar on 11/06/2019.
//

import UIKit

class ResultsCell: UITableViewCell {

    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
