//
//  TaskQuery.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct TaskQuery: EntityQuery, EntityStringQuery {
  
  // Lookup by ID — needed when entity is passed between Shortcut steps
  func entities(for identifiers: [UUID]) async throws -> [TaskEntity] {
    let tasks = await TaskStore.shared.allTasks()
    return tasks
      .filter{ identifiers.contains($0.id)}
      .map(TaskEntity.init)
  }
  
  // Fuzzy search — powers natural language ("the groceries task")
  func entities(matching string: String) async throws -> [TaskEntity] {
    let tasks = await TaskStore.shared.allTasks()
    return tasks.map(TaskEntity.init)
  }
  
  // Suggestions for the Shortcuts picker
  func suggestedEntities() async throws -> [TaskEntity] {
    let tasks = await TaskStore.shared.allTasks()
    // Show incomplete tasks first, sorted by priority
    let sorted = tasks
      .sorted { lhs, rhs in
        if lhs.isCompleted != rhs.isCompleted {
          return !lhs.isCompleted
        }
        return lhs.priority.sortOrder < rhs.priority.sortOrder
      }
      .prefix(20)
    return sorted.map(TaskEntity.init)
  }
}

// Property-based filtering (powers "Find tasks where priority is high")
extension TaskQuery: EntityPropertyQuery {
  
  static var properties = QueryProperties {
    Property(\TaskEntity.$title) {
      ContainsComparator { NSPredicate(format: "title CONTAINS[c] %@", $0)}
    }
    Property(\TaskEntity.$isCompleted) {
                EqualToComparator { NSPredicate(format: "isCompleted == %@", NSNumber(value: $0)) }
            }
    Property(\TaskEntity.$priority) {
        EqualToComparator { NSPredicate(format: "priority == %@", $0.rawValue) }
    }
    Property(\TaskEntity.$category) {
        EqualToComparator { NSPredicate(format: "category == %@", $0.rawValue) }
    }
  }
  
  static var sortingOptions = SortingOptions {
    SortableBy(\TaskEntity.$createdAt)
    SortableBy(\TaskEntity.$dueDate)
    SortableBy(\TaskEntity.$priority)
  }
  
  func entities(
          matching comparators: [NSPredicate],
          mode: ComparatorMode,
          sortedBy: [Sort<TaskEntity>],
          limit: Int?
      ) async throws -> [TaskEntity] {
          let allTasks = await TaskStore.shared.allTasks().map(TaskEntity.init)
          
          // Apply predicates manually (since we're not Core Data)
          let predicate = mode == .and
              ? NSCompoundPredicate(andPredicateWithSubpredicates: comparators)
              : NSCompoundPredicate(orPredicateWithSubpredicates: comparators)
          
          var filtered = allTasks.filter { entity in
              let dict: [String: Any] = [
                  "title": entity.title,
                  "isCompleted": entity.isCompleted,
                  "priority": entity.priority.rawValue,
                  "category": entity.category.rawValue
              ]
              return predicate.evaluate(with: dict)
          }
          
          // Apply sort
          for sort in sortedBy.reversed() {
              filtered.sort { lhs, rhs in
                  let ascending = sort.order == .ascending
                  switch sort.by {
                  case \TaskEntity.$createdAt:
                      return ascending ? lhs.createdAt < rhs.createdAt : lhs.createdAt > rhs.createdAt
                  case \TaskEntity.$dueDate:
                      let l = lhs.dueDate ?? .distantFuture
                      let r = rhs.dueDate ?? .distantFuture
                      return ascending ? l < r : l > r
                  case \TaskEntity.$priority:
                      return ascending
                          ? lhs.priority.sortOrder < rhs.priority.sortOrder
                          : lhs.priority.sortOrder > rhs.priority.sortOrder
                  default:
                      return false
                  }
              }
          }
          
          if let limit = limit {
              filtered = Array(filtered.prefix(limit))
          }
          return filtered
      }
}
