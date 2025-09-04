//
//  BeThereModel.swift
//  C323-BeThere
//
//  Created by Hope Barker on 4/22/25.
//

import Foundation

class BeThereModel {
    private var names: [String] = []
    private var dates: [String] = []
    private var startTimes: [String] = []
    private var endTimes: [String] = []
    private var locations: [String] = []
    private var td: [Bool] = []
    
    private var index: Int = 0
    private var max: Int = 0
    private var currTime: [String] = []
    
    init(){
    }
    
    func getNextName() -> String {
        self.max = self.names.count
        self.index = self.index + 1
        if (self.index >= self.max || self.index < 0) {
            self.index = 0
        }
        //print("INDEX: \(index)")
        return self.names[self.index]
    }
    func getCurrentName() -> String {
        self.max = self.names.count
        if (self.index >= self.max || self.index < 0) {
            self.index = 0
        }
        return self.names[self.index]
    }
    func setCurrentName(name: String) {
        self.max = self.names.count
        self.names[self.index] = name
    }
    func addName(name: String) {
        self.max += 1;
        self.names.append(name)
    }
    func removeName() {
        self.names.remove(at: self.index)
        self.max -= 1
    }
    
    
    func getDate() -> String {
        self.max = self.names.count
        //print("dINDEX: \(self.index)")
        if (self.index >= self.max || self.index < 0) {
            return self.dates[0]
        }
        return self.dates[self.index]
    }
    func setCurrentDate(date: String) {
        self.max = self.names.count
        self.dates[self.index] = date
    }
    func addDate(date: String) {
        self.dates.append(date)
    }
    func removeDate() {
        self.dates.remove(at: self.index)
    }
    
    
    func getTime() -> [String] {
        self.max = self.names.count
        //print("dINDEX: \(self.index)")
        if (self.index >= self.max || self.index < 0) {
            self.currTime.append(self.startTimes[0])
            self.currTime.append(self.endTimes[0])
        }
        self.currTime.append(self.startTimes[index])
        self.currTime.append(self.endTimes[index])
        return self.currTime
    }
    func setCurrentTime(Tstart: String, Tend: String) {
        self.max = self.names.count
        self.startTimes[self.index] = Tstart
        self.endTimes[self.index] = Tend
    }
    func addTime(Tstart: String, Tend: String) {
        self.startTimes.append(Tstart)
        self.endTimes.append(Tend)
    }
    func removeTime() {
        self.startTimes.remove(at: self.index)
        self.endTimes.remove(at: self.index)
    }
    
    
    func getLocation() -> String {
        self.max = self.names.count
        //print("lINDEX: \(self.index)")
        if (self.index >= self.max || self.index < 0) {
            return self.locations[0]
        }
        return self.locations[self.index]
    }
    func setCurrentLocation(location: String) {
        self.max = self.names.count
        self.locations[self.index] = location
    }
    func addLocation(location: String) {
        self.locations.append(location)
    }
    func removeLocation() {
        self.locations.remove(at: self.index)
    }
    
    
    func getToDo() -> Bool {
        self.max = self.names.count
        //print("lINDEX: \(self.index)")
        if (self.index >= self.max || self.index < 0) {
            return self.td[0]
        }
        return self.td[self.index]
    }
    func setCurrentToDo(ToDo: Bool) {
        self.max = self.names.count
        self.td[self.index] = ToDo
    }
    func addToDo(ToDo: Bool) {
        self.td.append(ToDo)
    }
    func removeToDo() {
        self.td.remove(at: self.index)
    }
    
    
    func getMax() -> Int {
        self.max = self.names.count
        return self.max
    }
    
    func setIndexZero() {
        self.index = 0
    }
    func setIndex(index: Int) {
        //print("set Index: \(self.index)")
        self.index = index
    }
    func getIndex() -> Int {
        return self.index
    }
    
}
