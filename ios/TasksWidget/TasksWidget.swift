//
//  TasksWidget.swift
//  TasksWidget
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import WidgetKit
import SwiftUI

// ios/TasksWidget/TasksWidget.swift
import WidgetKit
import SwiftUI
import AppIntents

struct TasksEntry: TimelineEntry {
    let date: Date
    let tasks: [TaskItem]
}

struct TasksProvider: TimelineProvider {
    func placeholder(in context: Context) -> TasksEntry {
        TasksEntry(date: Date(), tasks: DemoDataGenerator.generateDemoTasks().prefix(3).map { $0 })
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TasksEntry) -> Void) {
        Task {
            let tasks = await TaskStore.shared.tasks(filter: TaskFilter(isCompleted: false))
            completion(TasksEntry(date: Date(), tasks: tasks))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TasksEntry>) -> Void) {
        Task {
            let tasks = await TaskStore.shared.tasks(filter: TaskFilter(isCompleted: false))
            let entry = TasksEntry(date: Date(), tasks: tasks)
            // Reload only when data changes (we manually trigger via WidgetCenter)
            completion(Timeline(entries: [entry], policy: .never))
        }
    }
}

struct TasksWidgetView: View {
    let entry: TasksEntry
    @Environment(\.widgetFamily) var family
    
    var displayedTasks: [TaskItem] {
        let limit = family == .systemSmall ? 3 : 5
        return Array(entry.tasks.prefix(limit))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tasks")
                    .font(.headline)
                Spacer()
                Text("\(entry.tasks.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if displayedTasks.isEmpty {
                Text("All caught up! 🎉")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(displayedTasks, id: \.id) { task in
                    HStack(spacing: 8) {
                        // 🔑 Interactive button — calls AppIntent on tap
                        Button(intent: CompleteTaskIntent(task: TaskEntity(from: task))) {
                            Image(systemName: task.isCompleted
                                  ? "checkmark.circle.fill"
                                  : "circle")
                        }
                        .buttonStyle(.plain)
                        
                        Text(task.title)
                            .font(.caption)
                            .strikethrough(task.isCompleted)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct TasksWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "TasksWidget",
            provider: TasksProvider()
        ) { entry in
            TasksWidgetView(entry: entry)
        }
        .configurationDisplayName("My Tasks")
        .description("Quickly view and complete tasks.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct TasksWidgetBundle: WidgetBundle {
    var body: some Widget {
        TasksWidget()
    }
}
