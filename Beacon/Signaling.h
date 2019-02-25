//
//  Signaling.h
//  Beacon
//
//  Created by Pavel Skaldin on 2/24/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Signaling;
@class Beacon;

NS_ASSUME_NONNULL_BEGIN

#define BeaconEmit(value, beacons, userInfo) _BeaconEmit(value, beacons, userInfo, @(__FILE__), __LINE__, @(__FUNCTION__))
#define BeaconEmitError(error, beacons, userInfo) _BeaconEmit(error, beacons, userInfo, @(__FILE__), __LINE__, @(__FUNCTION__))
#define BeaconEmitStackTrace(beacons, userInfo) _BeaconStackTrace(NSThread.callStackSymbols, beacons, userInfo, @(__FILE__), __LINE__, @(__FUNCTION__))
#define BeaconEmitContext(beacons, userInfo) _BeaconEmit(nil, beacons, userInfo, @(__FILE__), __LINE__, @(__FUNCTION__))

void _BeaconEmit(id<Signaling> __nullable, NSArray<Beacon*>* __nullable, NSDictionary* __nullable, NSString*, NSInteger, NSString*);

void _BeaconEmitError(NSError*, NSArray<Beacon*>* __nullable, NSDictionary* __nullable, NSString*, NSInteger, NSString*);

void _BeaconEmitStackTrace(NSArray<NSString *>*, NSArray<Beacon*>* __nullable, NSDictionary* __nullable, NSString*, NSInteger, NSString*);

NS_ASSUME_NONNULL_END
