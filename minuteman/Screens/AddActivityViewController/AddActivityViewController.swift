//
//  AddActivityViewController.swift
//  minuteman
//
//  Created by Danil Chernyshev on 04/07/2022.
//

import UIKit
import CoreData

class AddActivityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var container: NSPersistentContainer!

    @IBAction func dismissScreen(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func completeButton(_ sender: Any) {
        let activity = Activity(context: container.viewContext)
        activity.emoji = self.selectedEmojiString
        activity.id = UUID()
        activity.colour = UIColor.random().encode() ?? Data()
        self.saveContext()
        NotificationCenter.default.post(name: Notification.Name("activitiesUpdate"), object: nil)
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedEmoji: UIImageView!
    var selectedEmojiString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emojiCollectionView.delegate = self
        self.emojiCollectionView.dataSource = self
        self.emojiCollectionView.register(UINib(nibName: "EmojiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "emojiCollectionViewCell")
        
        container = NSPersistentContainer(name: "minuteman")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        self.parseEmojis()
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedEmojiString = emojiList[indexPath.section][indexPath.item]
        self.selectedEmoji.image = emojiList[indexPath.section][indexPath.item].image()
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
