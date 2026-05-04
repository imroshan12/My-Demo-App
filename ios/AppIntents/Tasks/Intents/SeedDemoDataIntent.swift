//
//  SeedDemoDataIntent.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 02/05/26.
//

import Foundation
import AppIntents

struct SeedDemoDataIntent: AppIntent {
    static var title: LocalizedStringResource = "Load Demo Tasks"
    static var description = IntentDescription(
        "Populates TaskMaster with a set of sample tasks.",
        categoryName: "Setup"
    )
    
    static var openAppWhenRun: Bool = false
    
    @Parameter(
        title: "Replace Existing",
        description: "If true, removes all current tasks first.",
        default: false
    )
    var replaceExisting: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary("Load demo tasks") {
            \.$replaceExisting
        }
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let count = await DemoDataGenerator.seedIfNeeded(force: replaceExisting)
        
        #if MAIN_APP
        await IntentNotifier.shared.notify(
            type: "demoDataSeeded",
            payload: ["count": count]
        )
        #endif
        
        let dialog: IntentDialog = count == 0
            ? "Demo tasks were already loaded."
            : "Loaded \(count) demo tasks."
        
        return .result(dialog: dialog)
    }
}
