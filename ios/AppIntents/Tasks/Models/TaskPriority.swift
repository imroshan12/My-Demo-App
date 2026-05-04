//
//  TaskPriority.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

enum TaskPriority: String, AppEnum, Codable, CaseIterable {
  case low
  case medium
  case high
  case urgent
  
  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    TypeDisplayRepresentation(name: "Priority")
  }
  
  static var caseDisplayRepresentations: [TaskPriority : DisplayRepresentation] {
    [
        .low:    DisplayRepresentation(title: "Low",    image: .init(systemName: "arrow.down.circle")),
        .medium: DisplayRepresentation(title: "Medium", image: .init(systemName: "minus.circle")),
        .high:   DisplayRepresentation(title: "High",   image: .init(systemName: "arrow.up.circle")),
        .urgent: DisplayRepresentation(title: "Urgent", image: .init(systemName: "exclamationmark.2.circle"))
    ]
  }
  
  var sortOrder: Int {
    switch self {
    case .urgent: return 0
    case .high: return 1
    case .medium: return 2
    case .low: return 3
    }
  }
}
