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
    
    var currentActivity: Activity?
    
    var activityEvents = [ActivityEvent]()
    
    var currentActivityEvent: ActivityEvent?
    
    var selectedDayTimestamps: [Int] = [Int](repeating: 0, count: 1440)
    
    var timer = Timer()
    
    var currentTimestamp = Date().timeIntervalSince1970
    
    var dayStart: Date {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }
    
    func updateCurrentMinute() {
        let today = Date()
        let seconds = (Calendar.current.component(.second, from: today))
        
        if (seconds == 0) {
            self.currentTimestamp = Date().timeIntervalSince1970
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
        let activityRequest = Activity.createFetchRequest()
        
        do {
            activities = try container.viewContext.fetch(activityRequest)
            print("Got \(activities.count) activities")
        } catch {
            print("Fetch failed")
        }
        
        let activityEventRequest = ActivityEvent.createFetchRequest()
        
        do {
            activityEvents = try container.viewContext.fetch(activityEventRequest)
            if let lastEvent = activityEvents.last {
                if lastEvent.end == nil {
                    if let activity = activities.first(where: { $0.id == lastEvent.activityId }) {
                        currentActivityEvent = lastEvent
                        currentActivity = activity
                        minutesCollectionView.reloadData()
                        activitiesCollectionView.reloadData()
                    }
                }
            }
            print("Got \(activityEvents.count) activity events")
        } catch {
            print("Fetch failed")
        }
    }
    
    func createActivityEvent(activityId: UUID) {
        let activityEvent = ActivityEvent(context: container.viewContext)
        activityEvent.id = UUID()
        activityEvent.activityId = activityId
        activityEvent.start = Date()
        currentActivityEvent = activityEvent
        saveContext()
    }
    
    func completeActivityEvent(activityEventId: UUID) {
        let fetchRequest = ActivityEvent.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id = %@", activityEventId as CVarArg
        )
        
        do {
            let request = ActivityEvent.createFetchRequest()
            let activityEvent = try container.viewContext.fetch(request).first
            if let event = activityEvent {
                event.end = Date()
            }
            saveContext()
            loadSavedData()
            currentActivityEvent = nil
            currentActivity = nil
        } catch {
            print("An error occurred while saving: \(error)")
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
        if collectionView === self.minutesCollectionView {
            let cell = self.minutesCollectionView.dequeueReusableCell(withReuseIdentifier: "minuteCollectionViewCell", for: indexPath) as! MinuteCollectionViewCell
            
            if (indexPath.row == 1439 && Int(self.currentTimestamp) >= self.selectedDayTimestamps[indexPath.row]) {
                cell.dotView.backgroundColor = .red
            } else {
                cell.dotView.backgroundColor = .systemGray6
            }
            
            if Int(self.currentTimestamp) >= self.selectedDayTimestamps[indexPath.row] && Int(self.currentTimestamp) < self.selectedDayTimestamps[indexPath.row + 1] {
                if  let colour = self.currentActivity?.colour {
                    cell.dotView.backgroundColor = UIColor.color(data: colour)
                } else {
                    cell.dotView.backgroundColor = .red
                }
            } else {
                cell.dotView.backgroundColor = .systemGray6
            }
            
            cell.setNeedsLayout()
            return cell
        }
        
        if indexPath.item == activities.count {
            let cell = self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "addActivityCollectionViewCell", for: indexPath) as! AddActivityCollectionViewCell
            cell.addActivityAction = {
                self.performSegue(withIdentifier: "addActivity", sender: self)
            }
            
            return cell
        }
        
        let activityCell = self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        let activity = activities[indexPath.row]
        activityCell.activityEmojiImage.image = activity.emoji.image()
        activityCell.backgroundColor = UIColor.color(data: activity.colour)

        if let _currentActivity = self.currentActivity {
            if activity.id == _currentActivity.id {
                activityCell.backgroundColor = .red
            }
        }
        return activityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == self.activitiesCollectionView) {
            let activity = activities[indexPath.row]
            if let _currentActivity = currentActivity {
                if let eventId = currentActivityEvent?.id {
                    completeActivityEvent(activityEventId: eventId)

                    if _currentActivity.id == activity.id {
                        currentActivity = nil
                        currentActivityEvent = nil
                    } else {
                        currentActivity = activity
                        createActivityEvent(activityId: activity.id)
                    }
                }
                
                
            } else {
                currentActivity = activity
                createActivityEvent(activityId: activity.id)
            }
            
            minutesCollectionView.reloadData()
            activitiesCollectionView.reloadData()
        }
    }
}

// viewDidLoad
extension MainViewController {
    func loadCollectionViews() {
        minutesCollectionView.delegate = self
        minutesCollectionView.dataSource = self
        minutesCollectionView.register(UINib(nibName: "MinuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "minuteCollectionViewCell")
        
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
