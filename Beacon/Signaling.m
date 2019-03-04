//
//  Signaling.m
//  Beacon
//
//  Created by Pavel Skaldin on 2/24/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#import "Signaling.h"
#import <Beacon/Beacon-Swift.h>

void _BeaconEmit(id object, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    Signal *signal = nil;
    if (object == nil) {
        signal = [[ContextSignal alloc] initWithStack:[NSThread callStackSymbols]];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    else if ([object respondsToSelector:@selector(beaconSignal)]) {
        signal = [object performSelector:@selector(beaconSignal)];
    }
#pragma clang diagnostic pop
    else {
        signal = [[WrapperSignal alloc] init:object];
    }
    [signal emitOn:(beacons != nil) ? beacons : @[[Beacon shared]]
          userInfo:userInfo
          fileName:file
              line:line
      functionName:function];
}

void _BeaconEmitError(NSError* error, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    ErrorSignal *signal = [[ErrorSignal alloc] initWithError:error stack: [NSThread callStackSymbols]];
    [signal emitOn:(beacons != nil) ? beacons : @[[Beacon shared]]
          userInfo:userInfo
          fileName:file
              line:line
      functionName:function];
}

void _BeaconEmitStackTrace(NSArray<NSString *>* stackTrace, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    StackTraceSignal *signal = [[StackTraceSignal alloc] initWithStackTrace:stackTrace];
    [signal emitOn:(beacons != nil) ? beacons : @[[Beacon shared]]
          userInfo:userInfo
          fileName:file
              line:line
      functionName:function];
}
