//
//  BatteryModule.m
//  mydemoapp
//
//  Created by Sarvesh Roshan on 04/05/26.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(BatteryModule, RCTEventEmitter)

RCT_EXTERN_METHOD(getBatteryInfo:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
