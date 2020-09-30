//
//  BeaconObjcRuntime.h
//  
//
//  Created by Pavel Skaldin on 9/29/20.
//

#define SHARED_BEACONS @[[Beacon shared]]

#define BeaconEmitContext(beacons, anUserInfo) [[[ContextSignal alloc] initWithStack: [NSThread callStackSymbols]] emitOn:beacons userInfo:anUserInfo fileName:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] line:__LINE__ functionName:[NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]]

#define BeaconEmit(value, beacons, anUserInfo) [[[WrapperSignal alloc] init:value userInfo:nil] emitOn:beacons userInfo:anUserInfo fileName:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] line:__LINE__ functionName:[NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]]

#define BeaconEmitError(anError, beacons, anUserInfo) [[[ErrorSignal alloc] initWithError: anError stack: [NSThread callStackSymbols]] emitOn:beacons userInfo:anUserInfo fileName:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] line:__LINE__ functionName:[NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]]

#define BeaconEmitSignal(aSignal, beacons, anUserInfo) [aSignal emitOn:beacons userInfo:anUserInfo fileName:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] line:__LINE__ functionName:[NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]]
