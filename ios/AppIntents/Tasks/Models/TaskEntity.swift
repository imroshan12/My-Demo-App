//
//  TaskEntity.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct TaskEntity: AppEntity, Identifiable {
  
  // 1. Type-level display (what KIND of thing is this?)
  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    TypeDisplayRepresentation(name: "Tasks", numericFormat: "\(placeholder: .int) tasks")
  }
  
  // 2. Default query — used when system needs to find entities
  static var defaultQuery = TaskQuery()
  
  // 3. Identity
  let id: UUID
  
  // 4. Properties exposed to Shortcuts (filterable, displayable)
  @Property(title: "Title")
  var title: String
  
  @Property(title: "Notes")
  var notes: String
  
  @Property(title: "Completed")
  var isCompleted: Bool
  
  @Property(title: "Priority")
  var priority: TaskPriority
  
  @Property(title: "Category")
  var category: TaskCategory
  
  @Property(title: "Due Date")
  var dueDate: Date?
  
  @Property(title: "Created")
  var createdAt: Date
  
  // 5. How a single instance appears
  var displayRepresentation: DisplayRepresentation {
    var subtitle = "\(category.rawValue.capitalized) - \(priority.rawValue.capitalized)"
    if let dueDate {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      subtitle += " - \(formatter.string(from: dueDate))"
    }
    
    return DisplayRepresentation(title: "\(title)", subtitle: "\(subtitle)", image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle"))
  }
  
  init(from task: TaskItem) {
    self.id = task.id
    self.title = task.title
    self.notes = task.notes
    self.isCompleted = task.isCompleted
    self.priority = task.priority
    self.category = task.category
    self.dueDate = task.dueDate
    self.createdAt = task.createdAt
  }
}
