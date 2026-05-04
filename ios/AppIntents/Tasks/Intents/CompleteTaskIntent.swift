//
//  CompleteTaskIntent.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct CompleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task Completion"
    static var description = IntentDescription(
        "Marks a task as complete or incomplete.",
        categoryName: "Tasks"
    )
    
    static var openAppWhenRun: Bool = false
    
    @Parameter(title: "Task")
    var task: TaskEntity
    
    init() {}
    
    init(task: TaskEntity) {
        self.task = task
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Toggle completion for \(\.$task)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let updated = await TaskStore.shared.toggleCompletion(id: task.id) else {
            throw IntentError.taskNotFound
        }
        
        #if MAIN_APP
        await IntentNotifier.shared.notify(
            type: "taskToggled",
            payload: TaskEntity(from: updated).toDictionary()
        )
        #endif
        
        let status = updated.isCompleted ? "completed" : "reopened"
        return .result(dialog: "Marked '\(updated.title)' as \(status).")
    }
}

enum IntentError: Error, CustomLocalizedStringResourceConvertible {
    case taskNotFound
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .taskNotFound: return "Task not found."
        }
    }
}
