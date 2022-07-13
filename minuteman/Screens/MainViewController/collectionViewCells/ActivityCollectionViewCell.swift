//
//  ActivityCollectionViewCell.swift
//  minuteman
//
//  Created by Danil Chernyshev on 30/06/2022.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityEmojiImage: UIImageView!

    @IBOutlet weak var activityTimerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
