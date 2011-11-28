//
//  ZEDOAdPlugin.h
//  ZEDOAdTagPhonegapPlugin
//
//  Created by Nadav Greenberg on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

#import "ZEDOAdTag.h"

@interface ZEDOAdPlugin : PGPlugin {
    ZEDOAdTag*	adTagView;
    BOOL adVisible;
    BOOL isAtBottom;
    NSString* callbackID; 
}

@property (nonatomic, copy) NSString* callbackID;

- (void) initAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setAdTag:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setAdTagURL:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setAutoRefresh:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) setCollapsable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
