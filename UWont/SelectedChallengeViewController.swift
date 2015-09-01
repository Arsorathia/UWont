//
//  SelectedChallengeViewController.swift
//  crazyCamel
//
//  Created by Arif Sorathia on 8/31/15.
//  Copyright © 2015 Arif Sorathia. All rights reserved.
//

import UIKit

class SelectedChallengeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Create background View
        let backgroundView = UIImageView(frame: CGRectMake(0, 0, userScreenWidth, userScreenHeight))
        let backgroundImage = UIImage(named: "blueBackground-1.png")
        backgroundView.image = backgroundImage
        self.view.addSubview(backgroundView)
        
        // Create header
        addUsernameHeader(self)

        print(selectedChallenge[0])
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToSettings(){
        
        presentViewController(SettingsViewController_V2(), animated: true, completion: nil)
        
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
