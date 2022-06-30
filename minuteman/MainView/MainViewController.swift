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
            return 1440
        }
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minutesCollectionView.delegate = self
        minutesCollectionView.dataSource = self
        
        activitiesCollectionView.delegate = self
        activitiesCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }


}

