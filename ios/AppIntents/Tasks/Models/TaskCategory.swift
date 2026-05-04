//
//  TaskCategory.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

enum TaskCategory: String, Codable, CaseIterable, AppEnum {
  case work
  case personal
  case shopping
  case health
  case learning
  
  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    TypeDisplayRepresentation(name: "Category")
  }
  
  static var caseDisplayRepresentations: [TaskCategory : DisplayRepresentation] {
    [
        .work:     DisplayRepresentation(title: "Work",     image: .init(systemName: "briefcase")),
        .personal: DisplayRepresentation(title: "Personal", image: .init(systemName: "person")),
        .shopping: DisplayRepresentation(title: "Shopping", image: .init(systemName: "cart")),
        .health:   DisplayRepresentation(title: "Health",   image: .init(systemName: "heart")),
        .learning: DisplayRepresentation(title: "Learning", image: .init(systemName: "book"))
    ]
  }
}
