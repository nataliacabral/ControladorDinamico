//
//  ViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 23/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var recipes:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipes = ["teste", "testando ainda", "ultimo teste"]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableCell:UITableViewCell = UITableViewCell()
        tableCell.textLabel?.text = recipes[indexPath.row]
        return tableCell
    }
    
    @IBAction func addRecipe(sender : AnyObject) {
        recipes.append("new recipe")
    }
}

