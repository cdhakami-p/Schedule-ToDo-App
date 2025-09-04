//
//  ViewController.swift
//  C323-FinalApp-BeThere
//
//  Created by Hope Barker on 4/22/25.
//
// Casey Hakami - cdhakami@iu.edu, Jarret Rockwell - jarrrock@iu.edu
// BeThere
// 05/07/2025

import UIKit

class toDoViewController: UIViewController {
    
    var currentDate = Date()
    
    var appDelegate: AppDelegate?
    var myBeThereModel: BeThereModel?
    
    //Sorted event list for current day, sorted by time start
    
    @IBOutlet weak var currDateLabel: UILabel!
    @IBOutlet weak var currTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func prevEvent (_ sender: Any) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        
        if let todo: ToDo = myBeThereModel?.getLastToDo() {
            update(todo: todo)
        }
    }
    
    @IBAction func nextEvent (_ sender: Any) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        if let todo: ToDo = myBeThereModel?.getNextToDo() {
            update(todo: todo)
        }
    }
    
    @IBAction func completeButton(_ sender: Any) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        myBeThereModel?.removeToDo()
        
        if let todo: ToDo = myBeThereModel?.getNextToDo() {
            update(todo: todo)
        }
    }
    
    //Views
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let timeString = "12:00 am - 12:00 pm"
        currTimeLabel.text = timeString
        
        let today = dateFormatter.string(from: Date())
        currDateLabel.text = today
        
        if let todo: ToDo = myBeThereModel?.getCurrentToDo() {
            update(todo: todo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        if let todo: ToDo = myBeThereModel?.getCurrentToDo() {
            update(todo: todo)
        }
    }
    
    
    func update(todo: ToDo) {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let currTodo: ToDo = todo
        
        let timeString = "\(timeFormatter.string(from: currTodo.startTime)) - \(timeFormatter.string(from: currTodo.endTime))"
        currTimeLabel.text = timeString
        
        let today = dateFormatter.string(from: currTodo.date)
        currDateLabel.text = today
        
        titleLabel.text = currTodo.name
        
    }
    
    
}
    
    
    /*//Update date label helper & date buttons
    func updateDate() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        if let todos: [ToDo] = myBeThereModel?.getAllToDos() {
            if let index: Int = myBeThereModel?.getToDoIndex() {
                let currTodo = todos[index]
                
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, MMMM d, yyyy"
                let today = formatter.string(from: currTodo.date)
                currDateLabel.text = today
            }
        }
    }
    
    func updateTitle() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        if let todos: [ToDo] = myBeThereModel?.getAllToDos() {
            if let index: Int = myBeThereModel?.getToDoIndex() {
                let currTodo = todos[index]
                titleLabel.text = currTodo.name
            }
        }
        
    }
    
    func updateTime() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        if let todos: [ToDo] = myBeThereModel?.getAllToDos() {
            if let index: Int = myBeThereModel?.getToDoIndex() {
                let currTodo = todos[index]
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                
                let timeString = "\(timeFormatter.string(from: currTodo.startTime)) - \(timeFormatter.string(from: currTodo.endTime))"
                
                currTimeLabel.text = timeString
            }
        }
    }
}*/

