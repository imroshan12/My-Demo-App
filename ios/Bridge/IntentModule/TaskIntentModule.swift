//
//  TaskIntentModule.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import React
import AppIntents

@objc(TaskIntentsModule)
class TaskIntentsModule: RCTEventEmitter {
    
    private var hasListeners = false
    
    override init() {
        super.init()
        Task {
            await IntentNotifier.shared.register(module: self)
        }
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool { false }
    
    override func supportedEvents() -> [String]! {
        ["onIntentTriggered"]
    }
    
    override func startObserving() { hasListeners = true }
    override func stopObserving() { hasListeners = false }
    
    func emit(type: String, payload: [String: Any]) {
        guard hasListeners else { return }
        sendEvent(withName: "onIntentTriggered", body: [
            "type": type,
            "payload": payload
        ])
    }
    
    // MARK: - JS-Callable Methods
    
    @objc func addTask(_ title: String,
                       priority: String,
                       category: String,
                       notes: String,
                       resolve: @escaping RCTPromiseResolveBlock,
                       reject: @escaping RCTPromiseRejectBlock) {
        Task {
            let task = TaskItem(
                title: title,
                notes: notes,
                priority: TaskPriority(rawValue: priority) ?? .medium,
                category: TaskCategory(rawValue: category) ?? .personal
            )
            
            let saved = await TaskStore.shared.add(task)
            
            // Donate so the system learns user behavior
            let intent = AddTaskIntent()
            intent.title = title
            intent.priority = task.priority
            intent.category = task.category
            intent.notes = notes
            try? await intent.donate()
            
            resolve(saved.toDictionary())
        }
    }
    
    @objc func getTasks(_ onlyIncomplete: Bool,
                        resolve: @escaping RCTPromiseResolveBlock,
                        reject: @escaping RCTPromiseRejectBlock) {
        Task {
            let filter = TaskFilter(isCompleted: onlyIncomplete ? false : nil)
            let tasks = await TaskStore.shared.tasks(filter: filter)
            resolve(tasks.map { $0.toDictionary() })
        }
    }
    
    @objc func toggleTask(_ id: String,
                          resolve: @escaping RCTPromiseResolveBlock,
                          reject: @escaping RCTPromiseRejectBlock) {
        Task {
            guard let uuid = UUID(uuidString: id) else {
                reject("E_BAD_ID", "Invalid UUID", nil)
                return
            }
            guard let updated = await TaskStore.shared.toggleCompletion(id: uuid) else {
                reject("E_NOT_FOUND", "Task not found", nil)
                return
            }
            resolve(updated.toDictionary())
        }
    }
    
    @objc func deleteTask(_ id: String,
                          resolve: @escaping RCTPromiseResolveBlock,
                          reject: @escaping RCTPromiseRejectBlock) {
        Task {
            guard let uuid = UUID(uuidString: id) else {
                reject("E_BAD_ID", "Invalid UUID", nil)
                return
            }
            let success = await TaskStore.shared.delete(id: uuid)
            resolve(success)
        }
    }
    
    @objc func seedDemoData(_ force: Bool,
                            resolve: @escaping RCTPromiseResolveBlock,
                            reject: @escaping RCTPromiseRejectBlock) {
        Task {
            let count = await DemoDataGenerator.seedIfNeeded(force: force)
            resolve(["count": count])
        }
    }
    
    @objc func resetAllTasks(_ resolve: @escaping RCTPromiseResolveBlock,
                             reject: @escaping RCTPromiseRejectBlock) {
        Task {
            await TaskStore.shared.deleteAll()
            await TaskStore.shared.resetSeededFlag()
            resolve(true)
        }
    }
}
