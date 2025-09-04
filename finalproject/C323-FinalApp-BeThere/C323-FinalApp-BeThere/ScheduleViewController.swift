//
//  ScheduleViewController.swift
//  C323-FinalApp-BeThere
//
//  Created by Hakami, Casey D on 4/23/25.
//
// Casey Hakami - cdhakami@iu.edu, Jarret Rockwell - jarrrock@iu.edu
// BeThere
// 05/07/2025

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //IBOutlets, date, appDelegate
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var currentDate = Date()
    
    var appDelegate: AppDelegate?
    var myBeThereModel: BeThereModel?
    
    //Sorted event list for current day, sorted by time start
    var sortedEvents: [Event] {
        var todayEvents: [Event] = []
        
        if let allEvents = myBeThereModel?.getAllEvents() {
            let calendar = Calendar.current
            
            for event in allEvents {
                if calendar.isDate(event.date, inSameDayAs: currentDate) {
                    todayEvents.append(event)
                }
            }
            
            todayEvents.sort { (firstDate, secondDate) in return
                firstDate.startTime < secondDate.startTime
            }
        }
        
        return todayEvents
    }
    
    //Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myBeThereModel = self.appDelegate?.myBeThereModel
        
        tableView.dataSource = self
        tableView.delegate = self
        
        updateDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        updateDate()
    }
    
    //Update date label helper & date buttons
    func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let today = formatter.string(from: currentDate)
        dateLabel.text = today
    }
    
    @IBAction func prevDay (_ sender: Any) {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        updateDate( )
        tableView.reloadData()
    }
    
    @IBAction func nextDay (_ sender: Any) {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        updateDate( )
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortedEvents.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)

        let event = sortedEvents[indexPath.row]
        cell.textLabel?.text = event.name
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let timeString = "\(timeFormatter.string(from: event.startTime)) - \(timeFormatter.string(from: event.endTime))"
        let locationString = event.location
        
        cell.detailTextLabel?.text = "\(timeString) • \(locationString)"
        
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
