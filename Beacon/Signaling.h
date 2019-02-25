//
//  Signaling.h
//  Beacon
//
//  Created by Pavel Skaldin on 2/24/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Beacon/Beacon-Swift.h>

NS_ASSUME_NONNULL_BEGIN

#define emit(value, beacons, userInfo) BeaconEmit(obj, beacons, userInfo, __FILE__, __LINE__, __FUNCTION__)
#define emitError(error, beacons, userInfo) BeaconEmit(error, beacons, userInfo, __FILE__, __LINE__, __FUNCTION__)
#define emitStackTrace(beacons, userInfo) BeaconStackTrace(NSThread.callStackSymbols, beacons, userInfo, __FILE__, __LINE__, __FUNCTION__)

void BeaconEmit(id<Signaling> __nullable, NSArray<Beacon*>* __nullable, NSDictionary* __nullable, NSString*, NSInteger, NSString*);

void BeaconEmitError(NSError*, NSArray<Beacon*>* __nullable, NSDictionary* __nullable, NSString*, NSInteger, NSString*);

void BeaconEmitStackTrace(NSArray<NSString *>*, NSArray<Beacon*>* __nullable, NSDictionary* __nullable, NSString*, NSInteger, NSString*);

NS_ASSUME_NONNULL_END
