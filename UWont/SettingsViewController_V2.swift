//
//  SettingsViewController_V2.swift
//  crazyCamel
//
//  Created by Arif Sorathia on 8/30/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit

class SettingsViewController_V2: UIViewController {

    let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Background
        self.view.backgroundColor = UIColor.grayColor()
        
        //Create Close Image
        let closeImage:UIImage = UIImage(named: "closeButton.png")!
        closeButton.frame = CGRectMake(0, 0, 100, 100)
        closeButton.setImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(closeButton)
    
        //Create Logout Button
        let logoutButton:UIButton = UIButton(frame: CGRectMake(userScreenWidth*0.8-50, userScreenHeight*0.2-100, 100, 35))
        logoutButton.setTitle("Logout >", forState: .Normal)
        logoutButton.layer.borderWidth = 2
        logoutButton.layer.borderColor = UIColor.whiteColor().CGColor
        logoutButton.layer.cornerRadius = 5
        logoutButton.addTarget(self, action: "logout", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutButton)
    
        // Add Bottom Logo
        addBottomLogo(self)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeButtonPressed(sender:UIButton){
        
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
        
    }
    
    func logout(){
        
        PFUser.logOut()
        self.presentViewController(LoginViewController(), animated: true, completion: nil)
        
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
