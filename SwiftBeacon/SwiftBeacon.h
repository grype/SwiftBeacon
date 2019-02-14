//
//  SwiftBeacon.h
//  SwiftBeacon
//
//  Created by Pavel Skaldin on 2/14/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#elif TARGET_OS_TV
#import <WatchKit/WatchKit.h>
#else
#import <UIKit/UIKit.h>
#endif

//! Project version number for SwiftBeacon.
FOUNDATION_EXPORT double SwiftBeacon_VersionNumber;

//! Project version string for SwiftBeacon.
FOUNDATION_EXPORT const unsigned char SwiftBeacon_VersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SwiftBeacon/PublicHeader.h>


