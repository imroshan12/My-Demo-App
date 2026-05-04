//
//  TaskMasterShortcuts.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct TaskMasterShortcuts: AppShortcutsProvider {
    
    static var shortcutTileColor: ShortcutTileColor = .blue
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTaskIntent(),
            phrases: [
                "Add a task to \(.applicationName)",
                "Create a task in \(.applicationName)",
                "New \(.applicationName) task",
                "Remind me in \(.applicationName)"
            ],
            shortTitle: "Add TaskItem",
            systemImageName: "plus.circle"
        )
        
        AppShortcut(
            intent: ListTasksIntent(),
            phrases: [
                "Show my \(.applicationName) tasks",
                "What's on my \(.applicationName) list",
                "Open \(.applicationName) tasks"
            ],
            shortTitle: "Show Tasks",
            systemImageName: "list.bullet"
        )
        
//        AppShortcut(
//            intent: FindTaskIntent(),
//            phrases: [
//                "Search \(.applicationName)",
//                "Find a task in \(.applicationName)"
//            ],
//            shortTitle: "Find TaskItem",
//            systemImageName: "magnifyingglass"
//        )
        
        AppShortcut(
            intent: SeedDemoDataIntent(),
            phrases: [
                "Load demo data in \(.applicationName)",
                "Set up sample \(.applicationName) tasks"
            ],
            shortTitle: "Load Demo",
            systemImageName: "sparkles"
        )
    }
}
