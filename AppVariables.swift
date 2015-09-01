//
//  AppVariables.swift
//  UWont
//
//  Created by Arif Sorathia on 9/1/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Parse

let userScreenSize: CGRect = UIScreen.mainScreen().bounds
let userScreenWidth:CGFloat = userScreenSize.width
let userScreenHeight:CGFloat = userScreenSize.height
var userProfilePicture: UIImage?
var userProfileName = String()

let darkRedColor:UIColor = UIColor(red:1.0, green:0.22, blue:0.14, alpha:1.0) // FF3824
let darkGrayColor:UIColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0) // 8E8E93
let neonGreenColor:UIColor = UIColor(red:0.27, green:0.86, blue:0.37, alpha:1.0) // 44DB5E

func addBottomLogo(viewC:UIViewController){
    
    let logohw:CGFloat = userScreenWidth*0.2
    let logoView = UIImageView(frame: CGRectMake(5, userScreenHeight - (logohw + 5), logohw, logohw ))
    let logoImage = UIImage(named: "logoShit.png")
    logoView.image = logoImage
    viewC.view.addSubview(logoView)
    
}

func getFacebookData()
    
{
    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        
        if ((error) != nil)
        {
            // Process error
            print("Error: \(error)")
        }
        else
        {
            print("fetched user: \(result)")
            let facebookUsername = result["name"] as! String
            userProfileName = "\(facebookUsername)"
            let userId = result["id"] as! String
            let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
            
            if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                
                if let data = NSData(contentsOfURL: fbpicUrl) {
                    
                    userProfilePicture = UIImage(data:data)
                    
                    
                }
                
            }
            
        }
    })
}

func addUsernameHeader(viewC:UIViewController){
    
    
    let picButton = UIButton()
    let userNameLabel = UILabel()
    let userNameFont = UIFont(name: "SFUIText-Regular", size: 16)
    
    
    // Create Profile Picture Button
    let picButtonlw = userScreenWidth*0.15
    picButton.frame =  CGRectMake(userScreenWidth*0.77, userScreenHeight*0.05, picButtonlw, picButtonlw)
    picButton.layer.masksToBounds = true
    picButton.layer.cornerRadius = picButtonlw/2
    picButton.addTarget(viewC, action: "goToSettings", forControlEvents: UIControlEvents.TouchUpInside)
    picButton.setBackgroundImage(userProfilePicture, forState: .Normal)
    viewC.view.addSubview(picButton)
    
    // Create Username Label
    userNameLabel.frame = CGRectMake(0, userScreenHeight*0.05, userScreenWidth*0.77-5, picButtonlw)
    userNameLabel.font = userNameFont
    userNameLabel.textColor = darkRedColor
    userNameLabel.textAlignment = NSTextAlignment.Right
    userNameLabel.font = userNameLabel.font.fontWithSize(picButtonlw*0.75)
    userNameLabel.adjustsFontSizeToFitWidth = true
    userNameLabel.text = "\(userProfileName)"
    viewC.view.addSubview(userNameLabel)
    
}

func getFacebookDataAndCreateHeader(viewC:UIViewController)
    
{
    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        
        if ((error) != nil)
        {
            // Process error
            print("Error: \(error)")
        }
        else
        {
            print("fetched user: \(result)")
            let facebookUsername = result["name"] as! String
            userProfileName = "\(facebookUsername)"
            let userId = result["id"] as! String
            let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
            
            if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                
                if let data = NSData(contentsOfURL: fbpicUrl) {
                    
                    userProfilePicture = UIImage(data:data)
                    addUsernameHeader(viewC)
                    
                    
                }
                
            }
            
        }
    })
}

