//
//  Signaling.m
//  Beacon
//
//  Created by Pavel Skaldin on 2/24/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#import "Signaling.h"
#import <Beacon/Beacon-Swift.h>

void _BeaconEmit(id<Signaling> object, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    Signal *signal = (object == nil) ? [[ContextSignal alloc] init] : [object beaconSignal];
    [signal emitOn:(beacons != nil) ? beacons : @[[Beacon shared]]
          userInfo:userInfo
          fileName:file
              line:line
      functionName:function];
}

void _BeaconEmitError(NSError* error, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    ErrorSignal *signal = [[ErrorSignal alloc] initWithError:error];
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
