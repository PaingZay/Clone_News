//
//  CategoryCell.swift
//  BBCClone
//
//  Created by Paing Zay on 23/9/23.
//

import UIKit

class CategoryCell: UITableViewCell {

    
    @IBOutlet weak var category: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
