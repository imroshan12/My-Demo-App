//
//  TaskStore.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import WidgetKit

actor TaskStore {
  static let shared = TaskStore()
  
  private let appGroupID = "group.com.sarvesh.mydemoapp"
  private let storageKey = "tasks.v1"
  private let seededFlagKey = "demoDataSeeded.v1"
  
  private var defaults: UserDefaults {
    UserDefaults(suiteName: appGroupID) ?? .standard
  }
  
  // MARK: - Read
  
  func allTasks() -> [TaskItem] {
    guard let data = defaults.data(forKey: storageKey),
          let tasks = try? JSONDecoder().decode([TaskItem].self, from: data) else {
      return []
    }
    return tasks
  }
  
  func task(for id: UUID) -> TaskItem? {
    allTasks().first { $0.id == id}
  }
  
  func tasks(matching query: String) -> [TaskItem] {
    allTasks().filter {
      $0.title.localizedCaseInsensitiveContains(query) ||
      $0.notes.localizedCaseInsensitiveContains(query)
    }
  }
  
  func tasks(filter: TaskFilter) -> [TaskItem] {
    var tasks = allTasks()
    if let completed = filter.isCompleted {
      tasks = tasks.filter { $0.isCompleted == completed }
    }
    
    if let priority = filter.priority {
      tasks = tasks.filter { $0.priority == priority }
    }
    
    if let category = filter.category {
      tasks = tasks.filter { $0.category == category }
    }
    
    return tasks.sorted {
      ($0.priority.sortOrder, $0.createdAt) < ($1.priority.sortOrder, $1.createdAt)
    }
  }
  
  // MARK: - WRITE
  @discardableResult
  func add(_ task: TaskItem) -> TaskItem {
    var current = allTasks()
    if let existingIndex = current.firstIndex(where: { $0.id == task.id} ) {
      current[existingIndex] = task
    } else {
      current.append(task)
    }
    
    save(current)
    return task
  }
  
  @discardableResult
  func update(_ task: TaskItem) -> TaskItem? {
    var current = allTasks()
    guard let existingIndex = current.firstIndex(where: { $0.id == task.id} ) else {
      return nil
    }
    current[existingIndex] = task
    save(current)
    return task
  }
  
  @discardableResult
  func toggleCompletion(id: UUID) -> TaskItem? {
    var current = allTasks()
    guard let existingIndex = current.firstIndex(where: { $0.id == id }) else {
      return nil
    }
    current[existingIndex].isCompleted.toggle()
    save(current)
    return current[existingIndex]
  }
  
  @discardableResult
  func delete(id: UUID) -> Bool {
    var current = allTasks()
    let initialCount = current.count
    current.removeAll(where: { $0.id == id})
    guard current.count != initialCount else {
      return false
    }
    save(current)
    return true
  }
  
  func deleteAll() {
    save([])
  }
  
  // MARK: - DEMO DATA
  
  func hasSeededDemoData() -> Bool {
      defaults.bool(forKey: seededFlagKey)
  }
  
  func markDemoDataSeeded() {
      defaults.set(true, forKey: seededFlagKey)
  }
  
  func resetSeededFlag() {
      defaults.set(false, forKey: seededFlagKey)
  }
  
  // MARK: INTERNAL
  
  private func save(_ tasks: [TaskItem]) {
    guard let data = try? JSONEncoder().encode(tasks) else { return }
    defaults.set(data, forKey: storageKey)
    
    // Refresh widget timelines whenever data changes
    WidgetCenter.shared.reloadAllTimelines()
  }
  
}

struct TaskFilter {
    var isCompleted: Bool?
    var priority: TaskPriority?
    var category: TaskCategory?
}
