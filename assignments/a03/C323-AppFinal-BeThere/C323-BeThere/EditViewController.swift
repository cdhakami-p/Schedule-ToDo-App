//
//  EditViewController.swift
//  C323-BeThere
//
//  Created by Hope Barker on 4/22/25.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var appDelegate: AppDelegate?
    var myBeThereModel: BeThereModel?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var createNewSwitch: UISwitch!
    @IBOutlet weak var newToDoSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        if createNewSwitch.isOn == false {
            
            if let name: String = self.nameTextField.text {
                self.myBeThereModel?.setCurrentName(name: name)
            }
            
            if let date: String = self.dateTextField.text {
                self.myBeThereModel?.setCurrentDate(date: date)
            }
            
            if let startTime: String = self.startTimeTextField.text {
                if let endTime: String = self.endTimeTextField.text {
                    self.myBeThereModel?.setCurrentTime(Tstart: startTime, Tend: endTime)
                }
            }
            
            if let location: String = self.locationTextField.text {
                self.myBeThereModel?.setCurrentLocation(location: location)
            }
            
        }
        else {
            
            if let name: String = self.nameTextField.text {
                self.myBeThereModel?.addName(name: name)
            }
            
            if let date: String = self.dateTextField.text {
                self.myBeThereModel?.addDate(date: date)
            }
            
            if let startTime: String = self.startTimeTextField.text {
                if let endTime: String = self.endTimeTextField.text {
                    self.myBeThereModel?.addTime(Tstart: startTime, Tend: endTime)
                }
            }
            
            if let location: String = self.locationTextField.text {
                self.myBeThereModel?.addLocation(location: location)
            }
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        createNewSwitch.isOn = false
        
        if let isToDo: Bool = self.myBeThereModel?.getToDo() {
            newToDoSwitch.isOn = isToDo
        } else {
            newToDoSwitch.isOn = false
        }
        
        if newToDoSwitch.isOn {
            self.endTimeTextField.isHidden = true
        }
        for textField in [nameTextField, dateTextField, startTimeTextField, endTimeTextField, locationTextField] {
            textField?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        createNewSwitch.isOn = false
        
        if let isToDo: Bool = self.myBeThereModel?.getToDo() {
            newToDoSwitch.isOn = isToDo
        } else {
            newToDoSwitch.isOn = false
        }
        
        if newToDoSwitch.isOn {
            self.endTimeTextField.isHidden = true
        }
        
        for textField in [nameTextField, dateTextField, startTimeTextField, endTimeTextField, locationTextField] {
            textField?.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
