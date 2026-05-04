//
//  IntentNotifier.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation

actor IntentNotifier {
    static let shared = IntentNotifier()
    
    private weak var module: TaskIntentsModule?
    
    func register(module: TaskIntentsModule) {
        self.module = module
    }
    
    func notify(type: String, payload: [String: Any]) {
        // Hop to main thread for the bridge
        DispatchQueue.main.async { [weak self] in
            Task { [weak self] in
                guard let module = await self?.module else { return }
                module.emit(type: type, payload: payload)
            }
        }
    }
}

// Helper to convert TaskEntity → [String: Any]
extension TaskEntity {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id.uuidString,
            "title": title,
            "notes": notes,
            "isCompleted": isCompleted,
            "priority": priority.rawValue,
            "category": category.rawValue,
            "createdAt": createdAt.timeIntervalSince1970
        ]
        if let due = dueDate {
            dict["dueDate"] = due.timeIntervalSince1970
        }
        return dict
    }
}

extension TaskItem {
    func toDictionary() -> [String: Any] {
        TaskEntity(from: self).toDictionary()
    }
}
