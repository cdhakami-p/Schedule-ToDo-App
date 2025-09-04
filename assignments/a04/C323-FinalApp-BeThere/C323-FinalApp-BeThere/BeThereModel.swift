//
//  BeThereModel.swift
//  C323-FinalApp-BeThere
//
//  Created by Hope Barker on 4/22/25.
//

import Foundation
import CoreLocation

//Event & ToDo structs
struct Event: Codable {
    var name: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var latitude: Double?
    var longitude: Double?
    
    var coords: CLLocation? {
        if let lat = latitude, let long = longitude {
            return CLLocation(latitude: lat, longitude: long)
        }
        return nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, date, startTime, endTime, location, latitude, longitude
    }
}

struct ToDo: Codable {
    var name: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var latitude: Double?
    var longitude: Double?
    
    var coords: CLLocation? {
        if let lat = latitude, let long = longitude {
            return CLLocation(latitude: lat, longitude: long)
        }
        return nil
    }
    
    var isComplete: Bool
    
    private enum CodingKeys: String, CodingKey {
        case name, date, startTime, endTime, location, latitude, longitude, isComplete
    }
}

class BeThereModel: NSObject, Codable {
    //Event/ToDo list and index
    private var events: [Event] = []
    private var index: Int = 0
    
    private var toDos: [ToDo] = []
    private var toDoIndex: Int = 0
    
    
    enum CodingKeys: String, CodingKey {
        case events, toDos, index, toDoIndex
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        events = try container.decode([Event].self, forKey: .events)
        toDos = try container.decode([ToDo].self, forKey: .toDos)
        index = try container.decode(Int.self, forKey: .index)
        toDoIndex = try container.decode(Int.self, forKey: .toDoIndex)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(events, forKey: .events)
        try container.encode(toDos, forKey: .toDos)
        try container.encode(index, forKey: .index)
        try container.encode(toDoIndex, forKey: .toDoIndex)
    }
    
    override init() {
        super.init()
    }
    
    func save() {
        let fm = FileManager.default
        
        do {
                let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let fileURL = docsurl.appendingPathComponent("PersistentBeThere.plist")
                let data = try PropertyListEncoder().encode(self)
                try data.write(to: fileURL, options: .atomic)
            } catch {
                print("Save Error")
            }
    }
    
    static func load() -> BeThereModel? {
        let fm = FileManager.default
        
        do {
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = docsurl.appendingPathComponent("PersistentBeThere.plist")
            let data = try Data(contentsOf: fileURL)
            return try PropertyListDecoder().decode(BeThereModel.self, from: data)
        } catch {
            print("Load Error")
            return nil
        }
    }
    
    //Getters, setters
    func getEvent(at index: Int) -> Event? {
        if index >= 0 && index < events.count {
            return events[index]
        }
        return nil
    }
    
    func getToDo(at index: Int) -> ToDo? {
        if toDoIndex >= 0 && toDoIndex < toDos.count {
            return toDos[toDoIndex]
        }
        return nil
    }
    
    func getCurrentEvent() -> Event? {
        if events.count == 0 {
            return nil
        } else {
            return events[index]
        }
    }
    
    func getCurrentToDo() -> ToDo? {
        if toDos.count == 0 {
            return nil
        } else {
            let sorted: [ToDo] = getSortedToDos()
            return sorted[toDoIndex]
        }
    }
    
    func getNextEvent() -> Event? {
        if events.count == 0 {
            return nil
        } else {
            index = (index + 1) % events.count
            return events[index]
        }
    }
    
    func getNextToDo() -> ToDo? {
        if toDos.count == 0 {
            return nil
        } else {
            let sorted: [ToDo] = getSortedToDos()
            toDoIndex = (toDoIndex + 1) % toDos.count
            return sorted[toDoIndex]
        }
    }
    
    func getLastToDo() -> ToDo? {
        if toDos.count == 0 {
            return nil
        } else {
            let sorted: [ToDo] = getSortedToDos()
            toDoIndex = (toDoIndex - 1)
            if toDoIndex == -1 {
                toDoIndex = (toDos.count - 1)
            }
            return sorted[toDoIndex]
        }
    }
    
    func getAllEvents() -> [Event] {
        return events
    }
    
    func getSortedToDos() -> [ToDo] {
        let calendar = Calendar.current
        var currDay = calendar.startOfDay(for: Date())
        var totalToDos: [ToDo] = []
        var currToDos: [ToDo] = []
        var sortedToDos: [ToDo] = []
        var days: [[ToDo]] = [[]]
        
        let allToDos = self.toDos
            
            while totalToDos.count != allToDos.count {
                for todo in allToDos {
                    if calendar.isDate(todo.date, inSameDayAs: currDay) {
                        totalToDos.append(todo)
                        currToDos.append(todo)
                    }
                }
                
                days.append(currToDos)
                currToDos.removeAll()
                currDay = Calendar.current.date(byAdding: .day, value: 1, to: currDay)!
            }
            
        for day in days {
            for e in day {
                sortedToDos.append(e)
            }
        }
        return sortedToDos
    }
    
    /*func sortByDay(list: [ToDo]) -> [ToDo] {
        
        let calendar = Calendar.current
        var currDay = calendar.startOfDay(for: Date())
        var totalToDos: [ToDo] = []
        var currToDos: [ToDo] = []
        var sortedToDos: [ToDo] = []
        var days: [[ToDo]] = [[]]
        
        let allToDos = self.toDos
            
            while totalToDos.count != allToDos.count {
                for todo in allToDos {
                    if calendar.isDate(todo.date, inSameDayAs: currDay) {
                        totalToDos.append(todo)
                        currToDos.append(todo)
                    }
                }
                
                days.append(currToDos)
                currToDos.removeAll()
                currDay = Calendar.current.date(byAdding: .day, value: 1, to: currDay)!
            }
            
        for day in days {
            for e in day {
                sortedToDos.append(e)
            }
        }
        return sortedToDos
        
        
    }*/
    
    func addEvent(name: String, date: Date, startTime: Date, endTime: Date, location: String, coords: CLLocation?) {
        let newEvent = Event(name: name, date: date, startTime: startTime, endTime: endTime, location: location, latitude: coords?.coordinate.latitude, longitude: coords?.coordinate.longitude)
        
        events.append(newEvent)
        save()
    }
    
    func addToDo(name: String, date: Date, startTime: Date, endTime: Date, location: String, coords: CLLocation?) {
        let newToDo = ToDo(name: name, date: date, startTime: startTime, endTime: endTime, location: location, latitude: coords?.coordinate.latitude, longitude: coords?.coordinate.longitude, isComplete: false)
        
        toDos.append(newToDo)
        save()
    }
    
    func updateEvent(name: String, date: Date, startTime: Date, endTime: Date, location: String, coords: CLLocation?) {
        if events.count > 0 {
            events[index] = Event(name: name, date: date, startTime: startTime, endTime: endTime, location: location, latitude: coords?.coordinate.latitude, longitude: coords?.coordinate.longitude)
        }
        save()
    }
    
    func updateToDo(name: String, date: Date, startTime: Date, endTime: Date, location: String, coords: CLLocation?) {
        if toDos.count > 0 {
            toDos[toDoIndex] = ToDo(name: name, date: date, startTime: startTime, endTime: endTime, location: location, latitude: coords?.coordinate.latitude, longitude: coords?.coordinate.longitude, isComplete: false)
        }
        save()
    }
    
    func removeEvent() {
        if events.count > 0 {
            events.remove(at: index)
            
            if index >= events.count {
                index = max(0, events.count - 1)
            }
        }
        save()
    }
    
    func removeToDo() {
        if toDos.count > 0 {
            toDos.remove(at: toDoIndex)
            
            if toDoIndex >= toDos.count {
                toDoIndex = max(0, toDos.count - 1)
            }
        }
        save()
    }
    
    func markComplete() {
        if toDos.indices.contains(toDoIndex) {
            toDos[toDoIndex].isComplete = true
        }
        save()
    }
    
    func setIndex(_ newIndex: Int) {
        if newIndex >= 0 && newIndex < events.count {
            index = newIndex
        }
    }
    
    func setToDoIndex(_ newIndex: Int) {
        if newIndex >= 0 && newIndex < toDos.count {
            toDoIndex = newIndex
        }
    }
    
    func resetIndex() {
        index = 0
    }
    
    func resetToDoIndex() {
        toDoIndex = 0
    }
    
    func getIndex() -> Int {
        return index
    }
    
    func getToDoIndex() -> Int {
        return toDoIndex
    }
    
    func getCount() -> Int {
        return events.count
    }
    
    func getToDoCount() -> Int {
        return toDos.count
    }
}
