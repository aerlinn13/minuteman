//
//  AddActivityCollectionViewCell.swift
//  minuteman
//
//  Created by Danil Chernyshev on 04/07/2022.
//

import UIKit

class AddActivityCollectionViewCell: UICollectionViewCell {
    
    @IBAction func addActivityButton(_ sender: UIButton) {
        addActivityAction?()
    }
    
    var addActivityAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
