//
//  HelpPageViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 3/31/15.
//  Copyright (c) 2015 Natália Cabral. All rights reserved.
//

import UIKit

class HelpPageViewController : UIViewController {
    
    @IBOutlet weak var contentImageView: UIImageView?
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
    }
}
