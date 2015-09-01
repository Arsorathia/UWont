//
//  AddChallengeViewController.swift
//  crazyCamel
//
//  Created by Arif Sorathia on 8/30/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Parse

class AddChallengeViewController: UIViewController, UITextFieldDelegate {

    let userNameFont = UIFont(name: "SFUIText-Regular", size: 16)
    let challengeCode = UITextField()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Create background View
        let backgroundView = UIImageView(frame: CGRectMake(0, 0, userScreenWidth, userScreenHeight))
        let backgroundImage = UIImage(named: "blueBackground-1.png")
        backgroundView.image = backgroundImage
        self.view.addSubview(backgroundView)
        
        // Create header
        getFacebookDataAndCreateHeader(self)
        
        // Add Remove Keyboard Recognizer
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Add Challenge Code Field
        let challengeCodeWidth = userScreenWidth*0.6
        let challengeCodeHeight = challengeCodeWidth*0.25
        challengeCode.frame = CGRectMake(userScreenWidth*0.5 - challengeCodeWidth/2 , userScreenHeight*0.3, challengeCodeWidth, challengeCodeHeight)
        challengeCode.backgroundColor = UIColor.whiteColor()
        challengeCode.delegate = self
        challengeCode.layer.cornerRadius = challengeCodeHeight * 0.5
        let myString:NSString = "Enter Challenge Code"
        let myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Regular", size: 16)!, range: NSRange(location: 0, length: myString.length))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value:darkGrayColor, range: NSRange(location: 0, length: myString.length))
        challengeCode.attributedPlaceholder = myMutableString
        challengeCode.font = UIFont(name: "SFUIText-Regular", size: 16)
        challengeCode.textColor = darkGrayColor
        challengeCode.textAlignment = .Center
        self.view.addSubview(challengeCode)
        
        // Add Challenge Submit Button
        let challengeSubmit = UIButton(frame: CGRectMake(userScreenWidth*0.5, userScreenHeight*0.3 + challengeCodeHeight + 5, challengeCodeWidth/2, challengeCodeHeight))
        challengeSubmit.setTitle("Get At It", forState: .Normal)
        challengeSubmit.backgroundColor = neonGreenColor
        challengeSubmit.setTitleColor(darkGrayColor, forState: .Normal)
        challengeSubmit.titleLabel!.font = UIFont(name: "SFUIText-Regular", size: 16)
        challengeSubmit.layer.cornerRadius = challengeCodeHeight * 0.5
        challengeSubmit.addTarget(self, action: "submitChallenge", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(challengeSubmit)
        
        // Add Create you Own Challenge Button 
        let challengeCreate = UIButton(frame: CGRectMake(userScreenWidth*0.5 - challengeCodeWidth/2 , userScreenHeight*0.55, challengeCodeWidth, challengeCodeHeight))
        challengeCreate.setTitle("Create a New Challenge", forState: .Normal)
        challengeCreate.backgroundColor = darkGrayColor
        challengeCreate.setTitleColor(neonGreenColor, forState: .Normal)
        challengeCreate.titleLabel!.font = UIFont(name: "SFUIText-Regular", size: 16)
        challengeCreate.layer.cornerRadius = challengeCodeHeight * 0.5
        challengeCreate.addTarget(self, action: "createChallenge", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(challengeCreate)
        
        
        // Add Bottom Logo
        addBottomLogo(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func goToSettings(){
        
        presentViewController(SettingsViewController_V2(), animated: true, completion: nil)
        
    }
    
    func submitChallenge(){
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let codeString = challengeCode.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        print(codeString)
        
        let query = PFQuery(className:"Challenges_Test")
        query.whereKey("objectId", equalTo:codeString!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if objects!.count == 0 {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.displayErrorAlert("Error", message: "Challenge Code Is Invalid")
                    
                }else {
                    
                    let currentUser = PFUser.currentUser()!
                    var query = PFUser.query()!
                    query.whereKey("challenges", equalTo:codeString!)
                    query.whereKey("username", equalTo:currentUser["username"]!)
                    query.findObjectsInBackgroundWithBlock {
                        (userObjects: [AnyObject]?, userError: NSError?) -> Void in
                        
                        if userObjects!.count > 0 {
                         
                            self.activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                         self.displayErrorAlert("Error", message: "You Are Already In This Challenge")
                            
                        }else {
                            
                            currentUser.addObject(codeString! as! String, forKey: "challenges")
                            currentUser.saveInBackgroundWithBlock { (success, error) -> Void in
                                if error == nil {
                                    self.activityIndicator.stopAnimating()
                                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                    self.displaySuccessAlert("Success", message: "You have joined this Challenge")
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }else{
                
                print("error")
            }
        
        }
    }
    
    func createChallenge(){
        
        presentViewController(CreateChallengeViewController(), animated: true, completion: nil)
        
    }
    
    func displaySuccessAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
            
            self.presentViewController(ChallengeDashboardViewController(), animated: true, completion: nil)
            
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func displayErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
