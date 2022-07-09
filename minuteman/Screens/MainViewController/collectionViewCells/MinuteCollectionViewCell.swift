//
//  MinuteCollectionViewCell.swift
//  minuteman
//
//  Created by Danil Chernyshev on 30/06/2022.
//

import UIKit

class MinuteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dotView: UIView!
    var isCurrentMinute: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dotView.layer.cornerRadius = self.dotView.bounds.height / 2
    }

}
