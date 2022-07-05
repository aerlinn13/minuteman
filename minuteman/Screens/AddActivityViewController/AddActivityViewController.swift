//
//  AddActivityViewController.swift
//  minuteman
//
//  Created by Danil Chernyshev on 04/07/2022.
//

import UIKit

class AddActivityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func completeButton(_ sender: Any) {
    }
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedEmoji: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emojiCollectionView.delegate = self
        self.emojiCollectionView.dataSource = self
        self.emojiCollectionView.register(UINib(nibName: "EmojiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "emojiCollectionViewCell")
        
        self.parseEmojis()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
        cell.imageView.image = emojiList[indexPath.section][indexPath.item].image()
        return cell
    }
    
    var emojiList: [[String]] = []
    let sectionTitle: [String] = ["Emoticons", "Dingbats", "Transport and map symbols", "Enclosed Characters"]

    func parseEmojis() {

        let emojiRanges = [
            0x1F601...0x1F64F,
            0x2702...0x27B0,
            0x1F680...0x1F6C0,
            0x1F170...0x1F251
        ]

        for range in emojiRanges {
            var array: [String] = []
            for i in range {
                if let unicodeScalar = UnicodeScalar(i){
                    array.append(String(describing: unicodeScalar))
                }
            }

            emojiList.append(array)
        }
    }
}
