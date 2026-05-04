//
//  BatteryModule.swift
//  mydemoapp
//
//  Created by Sarvesh Roshan on 04/05/26.
//

import Foundation
import UIKit
import React

@objc(BatteryModule)
class BatteryModule: RCTEventEmitter {
  private var hasListeners = false
  
  override func supportedEvents() -> [String]! {
    return ["onBatteryChange", "onLowPowerModeChange"]
  }
  
  override class func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override func constantsToExport() -> [AnyHashable : Any] {
    [
      "STATE_UNKNOWN": UIDevice.BatteryState.unknown.rawValue,
      "STATE_UNPLUGGED": UIDevice.BatteryState.unplugged.rawValue,
      "STATE_CHARGING": UIDevice.BatteryState.charging.rawValue,
      "STATE_FULL": UIDevice.BatteryState.full.rawValue
    ]
  }
  
  override func startObserving() {
    hasListeners = true
    UIDevice.current.isBatteryMonitoringEnabled = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(powerModeDidChange), name: .NSProcessInfoPowerStateDidChange, object: nil)
  }
  
  override func stopObserving() {
    hasListeners = false
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func batteryLevelDidChange() {
    guard hasListeners else { return }
    sendEvent(withName: "onBatteryChange", body: [
      "level": UIDevice.current.batteryLevel,
      "percentage": Int(UIDevice.current.batteryLevel * 100),
      "state": UIDevice.current.batteryState.rawValue,
      "type": "levelChange",
      "timeStamp": Date().timeIntervalSince1970
    ])
  }
  
  @objc private func batteryStateDidChange() {
    guard hasListeners else { return }
    sendEvent(withName: "onBatteryChange", body: [
      "level": UIDevice.current.batteryLevel,
      "percentage": Int(UIDevice.current.batteryLevel * 100),
      "state": UIDevice.current.batteryState.rawValue,
      "type": "stateChange",
      "timeStamp": Date().timeIntervalSince1970
    ])
  }
  
  @objc private func powerModeDidChange() {
    guard hasListeners else { return }
    sendEvent(withName: "onLowPowerModeChange", body: [
      "isLowPowerMode": ProcessInfo.processInfo.isLowPowerModeEnabled
    ])
  }
  
  @objc func getBatteryInfo(
    _ resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let level = UIDevice.current.batteryLevel
    
    if level < 0 {
      reject("UNAVAILABLE", "Battery info unavailable (Simulator?)", nil)
      return
    }
    
    resolve([
      "level": level,
      "percentage": Int(level * 100),
      "state": UIDevice.current.batteryState.rawValue,
      "isLowPowerMode": ProcessInfo.processInfo.isLowPowerModeEnabled,
      "timeStamp": Date().timeIntervalSince1970
    ])
  }
}
