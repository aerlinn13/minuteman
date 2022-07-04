//
//  ViewController.swift
//  minuteman
//
//  Created by Danil Chernyshev on 30/06/2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var container: NSPersistentContainer!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateBackButton: UIButton!
    
    @IBOutlet weak var dateForwardButton: UIButton!
    
    @IBOutlet weak var minutesCollectionView: UICollectionView!
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.minutesCollectionView.delegate = self
        self.minutesCollectionView.dataSource = self
        self.minutesCollectionView.register(UINib(nibName: "MinuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "minuteCollectionViewCell")
        
        self.activitiesCollectionView.delegate = self
        self.activitiesCollectionView.dataSource = self
        self.activitiesCollectionView.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "activityCollectionViewCell")

        self.activitiesCollectionView.register(UINib(nibName: "AddActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addActivityCollectionViewCell")
        
        container = NSPersistentContainer(name: "minuteman")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if (collectionView === self.minutesCollectionView) {
            return 1440
        }
        
        if (collectionView === self.activitiesCollectionView) {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView === self.minutesCollectionView) {
            let cell = self.minutesCollectionView.dequeueReusableCell(withReuseIdentifier: "minuteCollectionViewCell", for: indexPath) as! MinuteCollectionViewCell
            return cell
        }
        
        if (indexPath.item == 0) {
            let cell = self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "addActivityCollectionViewCell", for: indexPath) as! AddActivityCollectionViewCell
            cell.addActivityAction = {
                self.performSegue(withIdentifier: "addActivity", sender: self)
            }
            return cell
        }
        
            return self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        
    }

}

