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
    
    var activities = [Activity]()
    
    var selectedDayTimestamps: [Int] = [Int](repeating: 0, count: 1440)
    
    var timer = Timer()
    
    var dayStart: Date {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }
    
    func updateCurrentMinute() {
        let today = Date()
        let seconds = (Calendar.current.component(.second, from: today))

        if (seconds == 0) {
            self.minutesCollectionView.reloadData()
        }
    }
    
    @objc func onActivitiesUpdate(_ notification:Notification) {
        self.loadSavedData()
        self.activitiesCollectionView.reloadData()
    }
}

// Timing preparation
extension MainViewController {
    func mapTimestampsToCurrentDay() {
        let minutes = 0...1439
        var timestamps: [Int] = []

        for number in minutes {
            timestamps.append(Int(self.dayStart.timeIntervalSince1970) + number * 60)
        }
        
        self.selectedDayTimestamps = timestamps
    }
}

// CoreData
extension MainViewController {
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = Activity.createFetchRequest()

        do {
            activities = try container.viewContext.fetch(request)
            print("Got \(activities.count) activities")
            self.activitiesCollectionView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
}

// collectionView
extension MainViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if (collectionView === self.minutesCollectionView) {
            return 1440
        }
        
        if (collectionView === self.activitiesCollectionView) {
            return activities.count + 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView === self.minutesCollectionView) {
            let cell = self.minutesCollectionView.dequeueReusableCell(withReuseIdentifier: "minuteCollectionViewCell", for: indexPath) as! MinuteCollectionViewCell
            let timestamp = Date().timeIntervalSince1970

            if (Int(timestamp) > self.selectedDayTimestamps[indexPath.row] && Int(timestamp) < self.selectedDayTimestamps[indexPath.row + 1]) {
                cell.dotView.backgroundColor = .red
                cell.setNeedsLayout()
            } else {
                cell.dotView.backgroundColor = .gray
            }

            return cell
        }

        if (indexPath.item == activities.count) {
            let cell = self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "addActivityCollectionViewCell", for: indexPath) as! AddActivityCollectionViewCell
            cell.addActivityAction = {
                self.performSegue(withIdentifier: "addActivity", sender: self)
            }
                        
            return cell
        }
        
        let activityCell = self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        activityCell.activityEmojiImage.image = activities[indexPath.row].emoji.image()

            return activityCell
    }
}

// viewDidLoad
extension MainViewController {
    func loadCollectionViews() {
        self.minutesCollectionView.delegate = self
        self.minutesCollectionView.dataSource = self
        self.minutesCollectionView.register(UINib(nibName: "MinuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "minuteCollectionViewCell")
        
        self.activitiesCollectionView.delegate = self
        self.activitiesCollectionView.dataSource = self
        self.activitiesCollectionView.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "activityCollectionViewCell")

        self.activitiesCollectionView.register(UINib(nibName: "AddActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addActivityCollectionViewCell")
        
    }
    
    func loadCoreData() {
        container = NSPersistentContainer(name: "minuteman")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapTimestampsToCurrentDay()
        self.loadCollectionViews()
        self.loadCoreData()
        self.loadSavedData()

        NotificationCenter.default.addObserver(self, selector: #selector(self.onActivitiesUpdate), name: Notification.Name("activitiesUpdate"), object: nil)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCurrentMinute()
            })
    }
}
