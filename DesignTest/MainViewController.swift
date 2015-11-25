//
//  MainViewController.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 21/08/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let titles = ["Maratona ENEM","Resumão FUVEST","Mack Provas", "#EUQUEROUSP"]
    var arrayImg: [UIImage] = []
//    let img = UIImage(named: "student1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSideBar()
        self.configArrayImg()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.userInteractionEnabled = true
//        self.collectionView.reloadData()
    }

//    MARK: Config
    func configureSideBar(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
//            menuButton.target = self
//            menuButton.action = "disableViewWhileMenuActive"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func configArrayImg(){
        for index in 0...4{
            let newImg = UIImage(named: "prova\(index)")
            arrayImg.append(newImg!)
        }
    }
    
//    MARK: DisableView
    func disableViewWhileMenuActive(){
        self.view.userInteractionEnabled = false
        self.revealViewController().revealToggle(self)
    }
    
//    MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("mainCell", forIndexPath: indexPath) as! CollectionViewCell
        
        let curr = indexPath.row % 4 + 1
        cell.labelText.text = titles[curr - 1]
        cell.imgView.image = arrayImg[curr-1]
//        cell.layer.borderWidth = 0.3
        
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
//    
//    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
//        return CGSizeMake(220, 170)
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//    }
    
}
