//
//  SwiftBeacon.h
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 2/12/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#include <TargetConditionals.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#elif TARGET_OS_IPHONE
@import Foundation;
#endif

//! Project version number for SwiftBeacon.
FOUNDATION_EXPORT double SwiftBeaconVersionNumber;

//! Project version string for SwiftBeacon.
FOUNDATION_EXPORT const unsigned char SwiftBeaconVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SwiftBeacon/PublicHeader.h>


