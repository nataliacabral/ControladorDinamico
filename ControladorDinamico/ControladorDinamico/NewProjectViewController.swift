//
//  NewProjectViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 3/20/15.
//  Copyright (c) 2015 Natália Cabral. All rights reserved.
//

import Foundation

class NewProjectViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet var notePicker:UIPickerView!
    @IBOutlet var modePicker:UIPickerView!
    @IBOutlet var projectNameTextField:UITextField!
    
    var delegate:NewProjectDelegate?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        notePicker!.selectRow(0, inComponent:0, animated:false)
        modePicker!.selectRow(0, inComponent:0, animated:false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == notePicker) {
            return Project.Note.count
        } else if (pickerView == modePicker) {
            return Project.Mode.allValues.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result:String = ""
        
        if (pickerView == notePicker) {
            result = Project.Note(rawValue:row)!.simpleDescription()
        } else if (pickerView == modePicker) {
            result =  String(Project.Mode.allValues[row].rawValue)
        }
        
        return result
    }

    @IBAction func addProject(sender: UIButton) {
        self.addProject()
    }
    
    func addProject() {
        let mode:Project.Mode = Project.Mode.allValues[self.modePicker!.selectedRowInComponent(0)]
        let note:Project.Note = Project.Note(rawValue: self.notePicker!.selectedRowInComponent(0))!
        self.delegate?.addNewProject(self.projectNameTextField.text, note: note, mode: mode)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.addProject()
        return true
    }
}