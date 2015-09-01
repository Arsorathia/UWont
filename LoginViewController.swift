//
//  LoginViewController.swift
//  UWont
//
//  Created by Arif Sorathia on 9/1/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Parse

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create background View
        let backgroundView = UIImageView(frame: CGRectMake(0, 0, userScreenWidth, userScreenHeight))
        let backgroundImage = UIImage(named: "redBackground.png")
        backgroundView.image = backgroundImage
        self.view.addSubview(backgroundView)
        
        //Create Logo View
        let logohw:CGFloat = userScreenWidth*0.7
        let logoView = UIImageView(frame: CGRectMake(userScreenWidth*0.5 - (logohw/2) , userScreenHeight*0.4 - (logohw/2), logohw, logohw ))
        let logoImage = UIImage(named: "logoShit.png")
        logoView.image = logoImage
        self.view.addSubview(logoView)
        
        //Create Facebook Login Button
        let facebookButtonImage = UIImage(named:"facebookLogin.png")
        let facebookButtonImageSize = facebookButtonImage!.size
        let facebookButtonImageWidth:CGFloat = userScreenWidth*0.7
        let facebookButtonImageHeight:CGFloat = facebookButtonImageWidth * (facebookButtonImageSize.height / facebookButtonImageSize.width )
        let facebookLoginButton = UIButton(frame: CGRectMake(userScreenWidth*0.5 - (facebookButtonImageWidth / 2), userScreenHeight*0.9 - (facebookButtonImageWidth / 2), facebookButtonImageWidth, facebookButtonImageHeight))
        facebookLoginButton.setBackgroundImage(facebookButtonImage, forState: .Normal)
        facebookLoginButton.addTarget(self, action: "getLoggedIn", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(facebookLoginButton)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            let currentUser = PFUser.currentUser()!
            
            if currentUser["challenges"] == nil {
                
                getFacebookData()
                self.presentViewController(AddChallengeViewController(), animated: true, completion: nil)
                
            }else{
                
                self.presentViewController(ChallengeDashboardViewController(), animated: true, completion: nil)
                
                
            }
            
            
        }
        
        
    }
    
    func getLoggedIn() {
        
        let permissions = ["public_profile", "email", "user_friends"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                if let user = user {
                    
                    getFacebookData()
                    self.presentViewController(AddChallengeViewController(), animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
        
        
        
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
