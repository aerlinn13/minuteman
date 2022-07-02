//
//  ViewController.swift
//  minuteman
//
//  Created by Danil Chernyshev on 30/06/2022.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateBackButton: UIButton!
    @IBOutlet weak var dateForwardButton: UIButton!
    
    @IBOutlet weak var minutesCollectionView: UICollectionView!
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if (collectionView === self.minutesCollectionView) {
            print("minutes")
            return 1440
        }
        
        if (collectionView === self.activitiesCollectionView) {
            print("activities")
            return 5
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView === self.minutesCollectionView) {
            let cell = self.minutesCollectionView.dequeueReusableCell(withReuseIdentifier: "minuteCollectionViewCell", for: indexPath) as! MinuteCollectionViewCell
            return cell
        }
        
            return self.activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.minutesCollectionView.delegate = self
        self.minutesCollectionView.dataSource = self
        self.minutesCollectionView.register(UINib(nibName: "MinuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "minuteCollectionViewCell")
        
        self.activitiesCollectionView.delegate = self
        self.activitiesCollectionView.dataSource = self
        self.activitiesCollectionView.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "activityCollectionViewCell")
    }


}

