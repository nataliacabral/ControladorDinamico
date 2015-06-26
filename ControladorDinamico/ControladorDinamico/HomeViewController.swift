//
//  HomeViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 1/10/15.
//  Copyright (c) 2015 Natália Cabral. All rights reserved.
//

import UIKit
import SpriteKit

class HomeViewController : UIViewController {

    @IBOutlet var cubesView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imgListArray :NSMutableArray = []
        for countValue in 1...3
        {
            
            var strImageName : String = "cubes\(countValue).png"
            var image  = UIImage(named:strImageName)
            imgListArray .addObject(image!)
        }
        
        self.cubesView.animationImages = imgListArray;
        self.cubesView.animationDuration = 2
        self.cubesView.startAnimating()
    }
    
}