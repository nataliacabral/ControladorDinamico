//
//  AboutViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 6/29/15.
//  Copyright (c) 2015 Filipe Calegario. All rights reserved.
//

import Foundation

class AboutViewController : UIViewController {
   
    @IBAction func close(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}