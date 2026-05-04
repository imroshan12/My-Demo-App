//
//  ListTasksIntent.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct ListTasksIntent: AppIntent {
  static var title: LocalizedStringResource = "Get Tasks"
  static var description: IntentDescription = IntentDescription(
    "Returns a list of tasks, optionally filtered.",
    categoryName: "Tasks"
  )
  
  static var openAppWhenRun: Bool = false
  
  @Parameter(title: "Only Incomplete", default: true)
  var onlyIncomplete: Bool
  
  @Parameter(title: "Category")
  var category: TaskCategory?
  
  @Parameter(title: "Priority")
  var priority: TaskPriority?
  
  static var parameterSummary: some ParameterSummary {
      When(\.$category, .hasAnyValue) {
          Summary("Get \(\.$category) tasks") {
              \.$onlyIncomplete
              \.$priority
          }
      } otherwise: {
          Summary("Get all tasks") {
              \.$onlyIncomplete
              \.$priority
              \.$category
          }
      }
  }
  
  func perform() async throws -> some IntentResult & ReturnsValue<[TaskEntity]> & ProvidesDialog {
    let filter = TaskFilter(
        isCompleted: onlyIncomplete ? false : nil,
        priority: priority,
        category: category
    )
    
    let tasks = await TaskStore.shared.tasks(filter: filter)
    let entities = tasks.map(TaskEntity.init)
    
    let dialog: IntentDialog = entities.isEmpty
        ? "No tasks found."
        : "Found \(entities.count) task\(entities.count == 1 ? "" : "s")."
    
    return .result(value: entities, dialog: dialog)
  }
}
