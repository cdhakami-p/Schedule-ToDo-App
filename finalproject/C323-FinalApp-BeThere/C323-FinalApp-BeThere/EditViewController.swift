//
//  EditViewController.swift
//  C323-FinalApp-BeThere
//
//  Created by Hope Barker on 4/22/25.
//
// Casey Hakami - cdhakami@iu.edu, Jarret Rockwell - jarrrock@iu.edu
// BeThere
// 05/07/2025

import UIKit
import CoreLocation
import UserNotifications
import MapKit

class EditViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    //App Delegate and IBOutlets
    var appDelegate: AppDelegate?
    var myBeThereModel: BeThereModel?
    
    @IBOutlet weak var createNewSwitch: UISwitch!
    @IBOutlet weak var newToDoSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    //Delete and Save button
    @IBAction func cancelButton(_ sender: Any) {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        myBeThereModel = appDelegate?.myBeThereModel
        
        if createNewSwitch.isOn {
            nameTextField.text = ""
            dateTextField.text = ""
            startTimeTextField.text = ""
            endTimeTextField.text = ""
            locationTextField.text = ""
            
            return
        }
        
        if newToDoSwitch.isOn {
            myBeThereModel?.removeToDo()
        } else {
            if let event = myBeThereModel?.getCurrentEvent() {
                removeNoti(for: event)
                myBeThereModel?.removeEvent()
            }
        }
        
        createNewSwitch.isOn = true
        newToDoSwitch.isOn = false
        
        nameTextField.text = ""
        dateTextField.text = ""
        startTimeTextField.text = ""
        endTimeTextField.text = ""
        locationTextField.text = ""
    }
    

    
    @IBAction func saveButton(_ sender: Any) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        guard let name = nameTextField.text,
              let date = dateTextField.text,
              let startTime = startTimeTextField.text,
              let endTime = endTimeTextField.text,
              let location = locationTextField.text
        else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        guard let date = dateFormatter.date(from: date),
              let startTime = timeFormatter.date(from: startTime),
              let endTime = timeFormatter.date(from: endTime)
        else { return }
        
        let calendar = Calendar.current
        
        let startDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: startTime),
                                          minute: calendar.component(.minute, from: startTime),
                                          second: 0,
                                          of: date)!
        
        let endDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: endTime),
                                          minute: calendar.component(.minute, from: endTime),
                                          second: 0,
                                          of: date)!
        
        let searchReq = MKLocalSearch.Request()
        searchReq.naturalLanguageQuery = location
        
        let locationManager = CLLocationManager()
        if let userLocation = locationManager.location {
            searchReq.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        }
        
        let search = MKLocalSearch(request: searchReq)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("Failed Search")
                return
            }
            let coords = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            print("Found location: \(name) \(coords.coordinate.latitude), \(coords.coordinate.longitude)")
            
            let isCreatingNew = self.createNewSwitch.isOn
            let isToDo = self.newToDoSwitch.isOn
            
            if isToDo {
                if isCreatingNew {
                    self.myBeThereModel?.addToDo(name: name, date: date, startTime: startDateTime, endTime: endDateTime, location: location, coords: coords)
                } else {
                    self.myBeThereModel?.updateToDo(name: name, date: date, startTime: startDateTime, endTime: endDateTime, location: location, coords: coords)
                }
            } else {
                if isCreatingNew {
                    self.myBeThereModel?.addEvent(name: name, date: date, startTime: startDateTime, endTime: endDateTime, location: location, coords: coords)
                } else {
                    self.myBeThereModel?.updateEvent(name: name, date: date, startTime: startDateTime, endTime: endDateTime, location: location, coords: coords)
                }
                
                let newEvent = Event(name: name, date: date, startTime: startDateTime, endTime: endDateTime, location: location, latitude: coords.coordinate.latitude, longitude: coords.coordinate.longitude)
                
                self.notification(for: newEvent)
                self.locationTracking(for: newEvent)
            }
            
            self.nameTextField.text = ""
            self.dateTextField.text = ""
            self.startTimeTextField.text = ""
            self.endTimeTextField.text = ""
            self.locationTextField.text = ""
            
            //print("Saved event \(name)")
        }
    }
    
    //New switch toggle & loading current element
    @IBAction func createNewToggle (_ sender: Any) {
        if createNewSwitch.isOn == false {
            loadItem()
        } else {
            nameTextField.text = ""
            dateTextField.text = ""
            startTimeTextField.text = ""
            endTimeTextField.text = ""
            locationTextField.text = ""
        }
    }
    
    @IBAction func todoToggle (_ sender: Any) {
        if createNewSwitch.isOn == false {
            loadItem()
        }
    }
    
    //Scroll through prev and next elements
    @IBAction func prevItem (_ sender: Any) {
        if createNewSwitch.isOn {
            return
        }
        
        if newToDoSwitch.isOn {
            myBeThereModel?.setToDoIndex((myBeThereModel?.getToDoIndex() ?? 0) - 1)
        } else {
            myBeThereModel?.setIndex((myBeThereModel?.getIndex() ?? 0) - 1)
        }
        
        loadItem()
    }
    
    @IBAction func nextItem (_ sender: Any) {
        if createNewSwitch.isOn {
            return
        }
        
        if newToDoSwitch.isOn {
            myBeThereModel?.setToDoIndex((myBeThereModel?.getToDoIndex() ?? 0) + 1)
        } else {
            myBeThereModel?.setIndex((myBeThereModel?.getIndex() ?? 0) + 1)
        }
        
        loadItem()
    }
    
    //Load item helper function
    func loadItem () {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        if newToDoSwitch.isOn {
            if let todo = myBeThereModel?.getCurrentToDo() {
                nameTextField.text = todo.name
                dateTextField.text = dateFormatter.string(from: todo.date)
                startTimeTextField.text = timeFormatter.string(from: todo.startTime)
                endTimeTextField.text = timeFormatter.string(from: todo.endTime)
                locationTextField.text = todo.location
            }
        } else {
            if let event = myBeThereModel?.getCurrentEvent() {
                nameTextField.text = event.name
                dateTextField.text = dateFormatter.string(from: event.date)
                startTimeTextField.text = timeFormatter.string(from: event.startTime)
                endTimeTextField.text = timeFormatter.string(from: event.endTime)
                locationTextField.text = event.location
            }
        }
    }
    
    //Date & Time picker wheels & helpers
    func datePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dateDonePressed))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
    }
    
    func timePicker() {
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        startTimePicker.addTarget(self, action: #selector(startTimeChanged(_:)), for: .valueChanged)
        startTimeTextField.inputView = startTimePicker
        
        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        endTimePicker.addTarget(self, action: #selector(endTimeChanged(_:)), for: .valueChanged)
        endTimeTextField.inputView = endTimePicker
        
        
        let sToolbar = UIToolbar()
        sToolbar.sizeToFit()
        
        let sDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDonePressed))
        sToolbar.setItems([sDoneButton], animated: true)
        startTimeTextField.inputAccessoryView = sToolbar
        
        let eToolbar = UIToolbar()
        eToolbar.sizeToFit()
        
        let eDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDonePressed))
        eToolbar.setItems([eDoneButton], animated: true)
        endTimeTextField.inputAccessoryView = eToolbar
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func startTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        startTimeTextField.text = formatter.string(from: sender.date)
        
    }
    
    @objc func endTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        endTimeTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func dateDonePressed(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        if let picker = dateTextField.inputView as? UIDatePicker {
            dateTextField.text = formatter.string(from: picker.date)
            dateTextField.resignFirstResponder()
        }
        
        dateTextField.resignFirstResponder()
    }
    
    @objc func startDonePressed(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if let picker = startTimeTextField.inputView as? UIDatePicker {
            startTimeTextField.text = formatter.string(from: picker.date)
            startTimeTextField.resignFirstResponder()
        }
        
        startTimeTextField.resignFirstResponder()
    }
    
    @objc func endDonePressed(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if let picker = endTimeTextField.inputView as? UIDatePicker {
            endTimeTextField.text = formatter.string(from: picker.date)
            endTimeTextField.resignFirstResponder()
        }
        
        endTimeTextField.resignFirstResponder()
    }
    
    func notification(for event: Event) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
            
            if settings.alertSetting == .enabled {
                if let hourAdvance = Calendar.current.date(byAdding: .hour, value: -1, to: event.startTime) {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Event in 1 Hour"
                    content.body = "\(event.name) at \(event.location)"
                    content.sound = .default
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: hourAdvance), repeats: false)
                    let request = UNNotificationRequest(identifier: "\(event.name)-hour", content: content, trigger: trigger)
                    
                    center.add(request)
                    print("noti ready")
                    print("Current time: \(Date())")
                    print("Noti time: \(hourAdvance)")
                    print("Event time: \(event.startTime)")
                }
                
                if let dayAdvance = Calendar.current.date(byAdding: .day, value: -1, to: event.startTime) {
                    
                    let contentDay = UNMutableNotificationContent()
                    contentDay.title = "Event in 24 Hours"
                    contentDay.body = "\(event.name) at \(event.location)"
                    contentDay.sound = .default
                    
                    let triggerDay = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dayAdvance), repeats: false)
                    let requestDay = UNNotificationRequest(identifier: "\(event.name)-day", content: contentDay, trigger: triggerDay)
                    
                    center.add(requestDay)
                    print("noti ready")
                    print("Current time: \(Date())")
                    print("Noti time: \(dayAdvance)")
                    print("Event time: \(event.startTime)")
                }
            }
        }
    }
    
    func removeNoti(for event: Event) {
        let center = UNUserNotificationCenter.current()
        let ids = ["\(event.name)-hour", "\(event.name)-day"]
        
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    func locationTracking(for event: Event) {
        guard let latitude = event.latitude, let longitude = event.longitude else { return }
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: 300, identifier: event.name)
        print("Center: \(region.center.latitude), \(region.center.longitude)")
        print("Radius: \(region.radius)")
        
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.locationManager?.startMonitoring(for: region)
        }
    }
    
    //View functions
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        createNewSwitch.isOn = true
        newToDoSwitch.isOn = false
        
        
        for textField in [nameTextField,  locationTextField] {
            textField?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [nameTextField, locationTextField] {
            textField?.delegate = self
        }
        
        datePicker()
        timePicker()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //self.buttonSendInput(sender: self)
        return true
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
