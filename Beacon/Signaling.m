//
//  Signaling.m
//  Beacon
//
//  Created by Pavel Skaldin on 2/24/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#import "Signaling.h"

void BeaconEmit(id<Signaling> object, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    Signal *signal = (object == nil) ? [[ContextSignal alloc] init] : [object beaconSignal];
    [signal emitOn:beacons
          userInfo:userInfo
          fileName:file
              line:line
      functionName:function];
}

void BeaconEmitError(NSError* error, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    [[[ErrorSignal alloc] initWithError:error] emitOn:beacons
                                             userInfo:userInfo
                                             fileName:file
                                                 line:line
                                         functionName:function];
}

void BeaconEmitStackTrace(NSArray<NSString *>* stackTrace, NSArray<Beacon*>* beacons, NSDictionary* userInfo, NSString* file, NSInteger line, NSString* function) {
    [[[StackTraceSignal alloc] initWithStackTrace:stackTrace] emitOn:beacons
                                                            userInfo:userInfo
                                                            fileName:file
                                                                line:line
                                                        functionName:function];
}
