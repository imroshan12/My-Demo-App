 //
 //  RCTNativeHapticModule.m
 //  mydemoapp
 //
 //  Created by Sarvesh Roshan on 08/05/26.
 //

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTViewManager.h>
#import <React-RCTAppDelegate/RCTDefaultReactNativeFactoryDelegate.h>
#import <ReactCodegen/NativeHapticModuleSpec/NativeHapticModuleSpec.h>
#import <ReactCodegen/NativeHapticModuleSpecJSI.h>
//#import <NativeHapticModuleSpec/NativeHapticModuleSpec.h>
//#import <NativeHapticModuleSpecJSI.h>
#import "mydemoapp-Swift.h"
//#import "HapticModule.h"

@interface HapticModuleBridge
    : NSObject <RCTBridgeModule, NativeHapticModuleSpec>
@end

@implementation HapticModuleBridge

RCT_EXPORT_MODULE(HapticModule)

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (NSNumber *)isSupported {
    return @([[HapticModuleImpl new] isSupported]);
}

- (void)impact:(NSString *)style {
    [[HapticModuleImpl new] impact:style];
}

- (void)notification:(NSString *)type {
    [[HapticModuleImpl new] notification:type];
}

- (void)selection {
    [[HapticModuleImpl new] selection];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared
        <facebook::react::NativeHapticModuleSpecJSI>(params);
}

@end
