//
//  HapticModule.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 08/05/26.
//

import Foundation
import UIKit
import CoreHaptics

@objc(HapticModuleImpl)
class HapticModule: NSObject {
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc
  func isSupported() -> Bool {
    return CHHapticEngine.capabilitiesForHardware().supportsHaptics
  }
  
  @objc
  func impact(_ style: String) {
    let feedBackStyle: UIImpactFeedbackGenerator.FeedbackStyle
    switch style {
    case "light": feedBackStyle = .light
    case "medium": feedBackStyle = .medium
    case "heavy": feedBackStyle = .heavy
    case "rigid": feedBackStyle = .rigid
    default: feedBackStyle = .medium
    }
    let generator = UIImpactFeedbackGenerator(style: feedBackStyle)
    generator.prepare()
    generator.impactOccurred()
  }
  
  @objc
  func notification(_ type: String) {
    let feedbackType: UINotificationFeedbackGenerator.FeedbackType
    switch type {
    case "success": feedbackType = .success
    case "error": feedbackType = .error
    case "warning": feedbackType = .warning
    default: feedbackType = .warning
    }
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(feedbackType)
  }
  
  @objc
  func selection() {
    let generator = UISelectionFeedbackGenerator()
    generator.selectionChanged()
  }
}
