//
//  DemoDataGenerator.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation

enum DemoDataGenerator {
    
    /// Generates a realistic set of demo tasks across all categories and priorities.
    static func generateDemoTasks() -> [TaskItem] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            // WORK
            TaskItem(
                title: "Prepare Q4 quarterly review",
                notes: "Pull metrics from analytics dashboard and create slide deck",
                priority: .urgent,
                category: .work,
                dueDate: calendar.date(byAdding: .day, value: 1, to: now)
            ),
            TaskItem(
                title: "Code review for auth module PR",
                notes: "Review the OAuth refactor, focus on token refresh logic",
                priority: .high,
                category: .work,
                dueDate: calendar.date(byAdding: .hour, value: 4, to: now)
            ),
            TaskItem(
                title: "Update team documentation",
                notes: "Onboarding guide is outdated since the migration",
                priority: .medium,
                category: .work,
                dueDate: calendar.date(byAdding: .day, value: 7, to: now)
            ),
            TaskItem(
                title: "Schedule 1:1 with manager",
                isCompleted: true,
                priority: .low,
                category: .work
            ),
            
            // PERSONAL
            TaskItem(
                title: "Call mom for her birthday",
                notes: "Don't forget to send flowers too",
                priority: .urgent,
                category: .personal,
                dueDate: calendar.date(byAdding: .day, value: 2, to: now)
            ),
            TaskItem(
                title: "Renew driver's license",
                notes: "Need to book appointment at RTO",
                priority: .high,
                category: .personal,
                dueDate: calendar.date(byAdding: .day, value: 14, to: now)
            ),
            TaskItem(
                title: "Plan weekend trip",
                priority: .low,
                category: .personal
            ),
            
            // SHOPPING
            TaskItem(
                title: "Buy groceries",
                notes: "Milk, eggs, bread, vegetables, fruits",
                priority: .high,
                category: .shopping,
                dueDate: calendar.date(byAdding: .day, value: 1, to: now)
            ),
            TaskItem(
                title: "Order new running shoes",
                notes: "Current pair is worn out, size 10",
                priority: .medium,
                category: .shopping
            ),
            TaskItem(
                title: "Pick up dry cleaning",
                isCompleted: true,
                priority: .medium,
                category: .shopping
            ),
            
            // HEALTH
            TaskItem(
                title: "Morning workout",
                notes: "30 min cardio + strength training",
                priority: .high,
                category: .health,
                dueDate: calendar.date(byAdding: .hour, value: 1, to: now)
            ),
            TaskItem(
                title: "Schedule annual checkup",
                priority: .medium,
                category: .health,
                dueDate: calendar.date(byAdding: .day, value: 30, to: now)
            ),
            TaskItem(
                title: "Refill prescription",
                priority: .urgent,
                category: .health,
                dueDate: calendar.date(byAdding: .day, value: 3, to: now)
            ),
            
            // LEARNING
            TaskItem(
                title: "Finish iOS App Intents tutorial",
                notes: "Cover AppEntity, AppEnum, and EntityQuery deeply",
                priority: .high,
                category: .learning,
                dueDate: calendar.date(byAdding: .day, value: 2, to: now)
            ),
            TaskItem(
                title: "Read chapter 5 of Swift Concurrency book",
                priority: .medium,
                category: .learning
            ),
            TaskItem(
                title: "Practice React Native New Architecture",
                notes: "Build a TurboModule from scratch",
                priority: .medium,
                category: .learning,
                dueDate: calendar.date(byAdding: .day, value: 5, to: now)
            ),
            TaskItem(
                title: "Watch WWDC session on Apple Intelligence",
                isCompleted: true,
                priority: .low,
                category: .learning
            )
        ]
    }
    
    /// Seeds demo data into the store. Idempotent — won't seed twice.
    @discardableResult
    static func seedIfNeeded(force: Bool = false) async -> Int {
      let hasSeededData = await TaskStore.shared.hasSeededDemoData()
      if !force && hasSeededData {
          return 0
      }
      
      if force {
          await TaskStore.shared.deleteAll()
      }
      
      let demoTasks = generateDemoTasks()
      for task in demoTasks {
          await TaskStore.shared.add(task)
      }
      
      await TaskStore.shared.markDemoDataSeeded()
      return demoTasks.count
    }
}
