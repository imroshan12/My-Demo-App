//
//  TaskItem.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation

struct TaskItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var priority: TaskPriority
    var category: TaskCategory
    var dueDate: Date?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        isCompleted: Bool = false,
        priority: TaskPriority = .medium,
        category: TaskCategory = .personal,
        dueDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.priority = priority
        self.category = category
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}
