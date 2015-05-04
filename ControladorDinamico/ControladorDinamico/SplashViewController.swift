//
//  SplashViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 4/15/15.
//  Copyright (c) 2015 Natália Cabral. All rights reserved.
//

import UIKit

class SplashViewController : UIViewController {
    @IBOutlet weak var content: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("updateSplash"), userInfo: nil, repeats: false)
    }
    
    
    func updateSplash() {
        self.content?.image = UIImage(named: "credits.png")
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("closeSplash"), userInfo: nil, repeats: false)
    }
    
    func closeSplash() {
        self.performSegueWithIdentifier("homeSegue", sender: self)
    }
}