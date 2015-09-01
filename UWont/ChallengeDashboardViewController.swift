//
//  ChallengeDashboardViewController.swift
//  crazyCamel
//
//  Created by Arif Sorathia on 8/31/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit

var selectedChallenge:[Any] = []

class ChallengeDashboardViewController: UIViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {
    
    var collectionView: UICollectionView!
    var numberOfChallenges:Int = 1
    var challengesArray = [[String:Any]]()
    var filteredChallengesArray = [[String:Any]]()
    var createTiles = true
    
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChallenges()
        
        let searchBar = UISearchBar(frame: CGRectMake(100, 150, 200, 50))
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.delegate = self
        searchBar.placeholder = "Search Your Challenges"
        
        
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
        
        self.view.addSubview(searchBar)
        

    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func goToSettings(){
        
        presentViewController(SettingsViewController_V2(), animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredChallengesArray.count
        }
        return challengesArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ChallengeCell
        cell.backgroundColor = UIColor.orangeColor()
        if var challengeName = challengesArray[indexPath.row]["name"] {
            if (searchActive){
                challengeName = filteredChallengesArray[indexPath.row]["name"]!
                cell.textLabel.text = "\(challengeName)"
            }else{
                cell.textLabel.text = "\(challengeName)"
    
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedChallenge.removeAll()
        if(searchActive) {
            let clickedChallenge = filteredChallengesArray[indexPath.row]
            selectedChallenge.append(clickedChallenge)
        }else {
            let clickedChallenge = challengesArray[indexPath.row]
            selectedChallenge.append(clickedChallenge)
        }
        
        self.presentViewController(SelectedChallengeViewController(), animated: true, completion: nil)
        return false
        
        
    }
    
    func createChallenge() {
        
        self.presentViewController(AddChallengeViewController(), animated: true, completion: nil)

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("Edit Start")
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("Edit End")
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("Edit Cancel")
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Edit Clicked")
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        

        filteredChallengesArray = challengesArray.filter {
            if let name = ($0)["name"] as? String
            {
                return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }else{
                return false
            }
        }
        
        if(filteredChallengesArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }

        print(filteredChallengesArray)
        
        self.collectionView!.reloadData()

        
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
