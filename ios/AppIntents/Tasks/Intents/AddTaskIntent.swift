//
//  AddTaskIntent.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct AddTaskIntent: AppIntent {
  static var title: LocalizedStringResource = "Add TaskItem"
  static var description: IntentDescription = IntentDescription(
    "Create a new task in mydemoapp",
    categoryName: "Tasks",
    searchKeywords: ["add", "create", "new", "todo", "task", "reminder"]
  )
  
  static var parameterSummary: some ParameterSummary {
    Summary("Add \(\.$title) to \(\.$category) with \(\.$priority) priority") {
      \.$notes
      \.$dueDate
    }
  }
  
  static var openAppWhenRun: Bool = false
  
  @Parameter(
    title: "Title",
    description: "The name of the task",
    requestValueDialog: "What should the task be called?"
  )
  var title: String
  
  @Parameter(
    title: "Category",
    default: .personal
  )
  var category: TaskCategory
  
  @Parameter(
    title: "Priority",
    default: .medium
  )
  var priority: TaskPriority
  
  @Parameter(
    title: "Notes",
    description: "Additional details",
    default: ""
  )
  var notes: String
  
  @Parameter(
    title: "Due Date",
    description: "When this task is due"
  )
  var dueDate: Date?
  
  func perform() async throws -> some IntentResult & ReturnsValue<TaskEntity> & ProvidesDialog {
    let task = TaskItem(
      title: title,
      notes: notes,
      priority: priority,
      category: category,
      dueDate: dueDate
    )
    
    let savedTask = await TaskStore.shared.add(task)
    let entity = TaskEntity(from: savedTask)
    
    // Inform JS
    
    return .result(value: entity, dialog: "Added '\(title)' to \(category.rawValue) with \(priority.rawValue) priority.")
  }
}
