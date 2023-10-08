//
//  RelatedNewsCell.swift
//  BBCClone
//
//  Created by Paing Zay on 1/10/23.
//

import UIKit

class RelatedNewsCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
