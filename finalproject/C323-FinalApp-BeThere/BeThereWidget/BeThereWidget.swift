//
//  BeThereWidget.swift
//  BeThereWidget
//
//  Created by Hakami, Casey D on 4/28/25.
// Casey Hakami - cdhakami@iu.edu, Jarret Rockwell - jarrrock@iu.edu
// BeThere
// 05/07/2025

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry, Codable {
    let date: Date
    let title: String
    let time: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Loading...", time: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            title: "Task Name",
            time: "Task Time"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var taskName = "No upcoming tasks."
        var taskTime = ""
        
        if let model = BeThereModel.load(),
            let task = model.getCurrentToDo() {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
            taskName = task.name
                taskTime = formatter.string(from: task.startTime)
            }
            
            let entry = SimpleEntry(date: Date(), title: taskName, time: taskTime)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct BeThereWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Next Task: \(entry.title)").font(.headline).padding(.bottom)
            Text("Date: \(entry.date)").font(.caption)
        }.containerBackground(for: .widget){
            Color.white
        }
    }
}

struct BeThereWidget: Widget {
    let kind: String = "BeThereWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
                BeThereWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Task Widget")
        .description("Displays upcoming tasks.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    BeThereWidget()
} timeline: {
    SimpleEntry(date: Date(), title: "Next Task", time: "Time")
}

