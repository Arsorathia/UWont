//
//  ChallengeDashboardViewController.swift
//  crazyCamel
//
//  Created by Arif Sorathia on 8/31/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit

var selectedChallenge:[Any] = []

class ChallengeDashboardViewController: UIViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var numberOfChallenges:Int = 1
    var challengesArray = [[String:Any]]()
    var createTiles = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChallenges()
        
        //Create background View
        let backgroundView = UIImageView(frame: CGRectMake(0, 0, userScreenWidth, userScreenHeight))
        let backgroundImage = UIImage(named: "blueBackground-1.png")
        backgroundView.image = backgroundImage
        self.view.addSubview(backgroundView)
        
        // Create header
        getFacebookDataAndCreateHeader(self)
        
        // Add Create you Own Challenge Button
        let challengeCodeWidth = userScreenWidth*0.6
        let challengeCodeHeight = challengeCodeWidth*0.25
        let challengeCreate = UIButton(frame: CGRectMake(userScreenWidth*0.5 - challengeCodeWidth/2 , userScreenHeight*0.15, challengeCodeWidth, challengeCodeHeight))
        challengeCreate.setTitle("Add a New Challenge", forState: .Normal)
        challengeCreate.backgroundColor = darkGrayColor
        challengeCreate.setTitleColor(neonGreenColor, forState: .Normal)
        challengeCreate.titleLabel!.font = UIFont(name: "SFUIText-Regular", size: 16)
        challengeCreate.layer.cornerRadius = challengeCodeHeight * 0.5
        challengeCreate.addTarget(self, action: "createChallenge", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(challengeCreate)
        
        //Create Layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 175, height: 120)
        
        // Create Collection View
        collectionView = UICollectionView(frame: CGRectMake(0, userScreenWidth*0.45, userScreenWidth, userScreenHeight - userScreenWidth*0.35 ), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(ChallengeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView)
        
        

    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func goToSettings(){
        
        presentViewController(SettingsViewController_V2(), animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numChallenges = challengesArray.count
        return numChallenges
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ChallengeCell
        cell.backgroundColor = UIColor.orangeColor()
        if let challengeName = challengesArray[indexPath.row]["name"] {
            cell.textLabel.text = "\(challengeName)"
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedChallenge.removeAll()
        let clickedChallenge:Any = challengesArray[indexPath.row]
        selectedChallenge.append(clickedChallenge)
        self.presentViewController(SelectedChallengeViewController(), animated: true, completion: nil)
        print(indexPath.row)
        return false
        
    }
    
    func createChallenge() {
        
        self.presentViewController(AddChallengeViewController(), animated: true, completion: nil)

    }
    
    func loadChallenges() {
        
        challengesArray.removeAll()
        
        let currentUser = PFUser.currentUser()!
        if currentUser["challenges"] != nil {
            
            let currentChallenges = currentUser["challenges"]! as! NSMutableArray
            
            for challenge in currentChallenges{
                
                let query = PFQuery(className:"Challenges_Test")
                query.whereKey("objectId", equalTo:challenge)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if let objects = objects as? [PFObject] {
                            for object in objects {
                                var challengeSummary = [String: Any]()
                                challengeSummary["name"] = object["name"]
                                challengeSummary["createdOn"] = object["createdOn"]
                                challengeSummary["objectId"] = object.objectId
                                self.challengesArray.append(challengeSummary)
                            }
                        }
                    
                        if self.challengesArray.count == currentChallenges.count{
                            
                            self.collectionView!.reloadData()
                        
                        }

                    } else {
                        // Log details of the failure
                        print("Error")
                    }
                }
                
                
            }
            
        }
        
        
        
    }

}
