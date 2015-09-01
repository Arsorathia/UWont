//
//  CreateChallengeViewController.swift
//  crazyCamel
//
//  Created by Arif Sorathia on 8/31/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit
import Parse

class CreateChallengeViewController: UIViewController, UITextFieldDelegate {
    
    let challengeName = UITextField()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.backgroundColor = UIColor.grayColor()
        
        // Add Header 
        addUsernameHeader(self)
        
        // Add Remove Keyboard Recognizer
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Add Challenge Name Field
        let challengeNameWidth = userScreenWidth*0.6
        let challengeNameHeight = challengeNameWidth*0.25
        challengeName.frame = CGRectMake(userScreenWidth*0.5 - challengeNameWidth/2 , userScreenHeight*0.3, challengeNameWidth, challengeNameHeight)
        challengeName.backgroundColor = UIColor.whiteColor()
        challengeName.delegate = self
        challengeName.layer.cornerRadius = challengeNameHeight * 0.5
        let myString:NSString = "Enter Challenge Name"
        let myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Regular", size: 16)!, range: NSRange(location: 0, length: myString.length))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value:darkGrayColor, range: NSRange(location: 0, length: myString.length))
        challengeName.attributedPlaceholder = myMutableString
        challengeName.font = UIFont(name: "SFUIText-Regular", size: 16)
        challengeName.textColor = darkGrayColor
        challengeName.textAlignment = .Center
        self.view.addSubview(challengeName)
        
        // Add Challenge Submit Button
        let challengeSubmit = UIButton(frame: CGRectMake(userScreenWidth*0.5, userScreenHeight*0.3 + challengeNameHeight + 5, challengeNameWidth/2, challengeNameHeight))
        challengeSubmit.setTitle("Get At It", forState: .Normal)
        challengeSubmit.backgroundColor = neonGreenColor
        challengeSubmit.setTitleColor(darkGrayColor, forState: .Normal)
        challengeSubmit.titleLabel!.font = UIFont(name: "SFUIText-Regular", size: 16)
        challengeSubmit.layer.cornerRadius = challengeNameHeight * 0.5
        challengeSubmit.addTarget(self, action: "submitChallenge", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(challengeSubmit)
        
        // Add Bottom Logo
        addBottomLogo(self)
        
    }

    func submitChallenge(){
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let challengeEntry = PFObject(className:"Challenges_Test")
        challengeEntry["createdBy"] = PFUser.currentUser()
        challengeEntry["createdByUsername"] = PFUser.currentUser()!["username"]
        challengeEntry["createdOn"] = NSDate()
        challengeEntry["name"] = challengeName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        challengeEntry.saveInBackgroundWithBlock { (success, error) -> Void in
            if error != nil {
                
                self.displayErrorAlert("Error", message: "Please try again later")
                
            } else {
                
                print("Challenge has saved")
                let createdChallenge = challengeEntry.objectId
                
                let currentUser = PFUser.currentUser()!
                if currentUser["challenges"] == nil {
                    
                    currentUser["challenges"] = [createdChallenge! as! String]
                    
                }else {
                    
                    currentUser.addObject(createdChallenge! as! String, forKey: "challenges")
                    
                }
                
                currentUser.saveInBackgroundWithBlock { (success, error) -> Void in
                    if error == nil {
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        self.displaySuccessAlert("Success", message: "Challenge has been Saved! Other users can join your challenge with the follow join code: \(createdChallenge!)")

                    }
                }
                
                
            }
        }
        
        
        
    }
    
    
    
    func goToSettings(){
        
        presentViewController(SettingsViewController_V2(), animated: true, completion: nil)
        
    }
    
    func displayErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
         
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func displaySuccessAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
         
            self.presentViewController(ChallengeDashboardViewController(), animated: true, completion: nil)
    
            
        })))
        
        alert.addAction((UIAlertAction(title: "Share", style: .Default, handler: { (action) -> Void in
            
            self.presentViewController(ChallengeShareViewController(), animated: true, completion: nil)

            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }



}
