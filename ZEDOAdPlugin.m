//
//  ZEDOAdPlugin.m
//  ZEDOAdTagPhonegapPlugin
//
//  Created by Nadav Greenberg on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ZEDOAdPlugin.h"


@interface ZEDOAdPlugin(PrivateMethods)

- (void) resizeViews;
- (void) showAd:(BOOL)show;
- (void) adFailedEvent;
- (void) adLoadedEvent;
- (void) adOpenEvent;
- (void) adCloseEvent;
- (void) adRequestedEvent;

@end

@implementation ZEDOAdPlugin

@synthesize callbackID;

-(void)initAds:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"at initAds native");
    self.callbackID = [arguments pop];
    
    // some JavaScript ad tag
    NSString* tag = @"<!-- Javascript tag  --> \
    <!-- begin ZEDO for channel: trains , publisher: trains , Ad Dimension: 320X50 - 320 x 50 --> \
    <script language='JavaScript'> \
        var zflag_nid='1577'; \
        var zflag_cid='18'; \
        var zflag_sid='16'; \
        var zflag_width='320'; \
        var zflag_height='50'; \
        var zflag_sz='16'; \
    </script> \
    <script language='JavaScript' src='http://c2.zedo.com/jsc/c2/fo.js'></script> \
    <body topmargin='0' leftmargin='0'></body> \
    <!-- end ZEDO for channel: trains , publisher: trains , Ad Dimension: 320X50 - 320 x 50-->"; 
    
    isAtBottom = [[arguments objectAtIndex:0] boolValue];
    
    if (isAtBottom) {
        adTagView = [[ZEDOAdTag alloc] initWithAdTag: tag Frame:CGRectMake(0, 410, 320, 460)];
    } else {
        adTagView = [[ZEDOAdTag alloc] initWithAdTag: tag Frame:CGRectMake(0, 0, 320, 50)];
    }
    
    adVisible = NO;
    
    [adTagView setAdLoadedCallback:self withSelector:@selector(adLoadedEvent)]; 
    [adTagView setAdFailedCallback:self withSelector:@selector(adFailedEvent)];
    
    [adTagView setOpenCallback:self withSelector:@selector(adOpenEvent)]; 
    [adTagView setCloseCallback:self withSelector:@selector(adCloseEvent)];
    [adTagView setAdRequestedCallback:self withSelector:@selector(adRequestedEvent)];
    
    [adTagView setAutoRefresh:200]; // refresh the ad container every 200 seconds
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK];
    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    
}

-(void)setAdTag:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"at setAdTag native");
    NSString* newTag = [arguments objectAtIndex:0];
    
    [adTagView setAdTag: newTag];
}

-(void)setAdTagURL:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"at setAdTagURL native");
    NSString* newTagUrl = [arguments objectAtIndex:0];
    
    [adTagView setAdTagURL: newTagUrl];
}

-(void)setAutoRefresh:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"at setAutoRefresh native");
    NSString* newRefreshRate = [arguments objectAtIndex:0];
    
    [adTagView setAutoRefresh:[newRefreshRate intValue]];
}

-(void)setCollapsable:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"at setCollapsable native");
    NSString* isCollapsable = [arguments objectAtIndex:0];
    
    [adTagView setCollapsable:[isCollapsable boolValue]];
}


/* PRIVATE METHODS */

- (void) showAd:(BOOL)show {
    if (show == adVisible) { // same state, nothing to do
		return;
	}
	
	if (show)
	{
		[UIView beginAnimations:@"blah" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
		[[[super webView] superview] addSubview:adTagView];
		[[[super webView] superview] bringSubviewToFront:adTagView];
        [self resizeViews];
		
		[UIView commitAnimations];
        
		adVisible = YES;
	}
	else 
	{
		[UIView beginAnimations:@"blah" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		[adTagView removeFromSuperview];
        [self resizeViews];
		
		[UIView commitAnimations];
		
		adVisible = NO;
	}
	
}

- (void) adFailedEvent {
    NSString* jsCallback = [NSString stringWithFormat:@"ZEDOAdPlugin._onAdFailedCallback();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];

    [self showAd:NO];
}

- (void) adLoadedEvent {
    NSString* jsCallback = [NSString stringWithFormat:@"ZEDOAdPlugin._onAdLoadedCallback();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
    
    [self showAd:YES];
}

- (void) adOpenEvent {
    NSString* jsCallback = [NSString stringWithFormat:@"ZEDOAdPlugin._onOpenCallback();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

- (void) adCloseEvent {
    NSString* jsCallback = [NSString stringWithFormat:@"ZEDOAdPlugin._onCloseCallback();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

- (void) adRequestedEvent{
    NSString* jsCallback = [NSString stringWithFormat:@"ZEDOAdPlugin._onAdRequestedCallback();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}


- (void) resizeViews
{
    BOOL isLandscape = NO;
 	if (adTagView)
	{
        CGRect webViewFrame = [super webView].frame;
        CGRect superViewFrame = [[super webView] superview].frame;
        CGRect adViewFrame = adTagView.frame;
        
        BOOL adIsShowing = [[[super webView] superview].subviews containsObject:adTagView];
        if (adIsShowing) 
        {
            if (isAtBottom) {
                webViewFrame.origin.y = 0;
            } else {
                webViewFrame.origin.y = adViewFrame.size.height;
            }
            
            webViewFrame.size.height = isLandscape ? (superViewFrame.size.width - adViewFrame.size.height) : (superViewFrame.size.height - adViewFrame.size.height);
        } 
        else 
        {
            webViewFrame.size = isLandscape ? CGSizeMake(superViewFrame.size.height, superViewFrame.size.width) : superViewFrame.size;
            webViewFrame.origin = CGPointZero;
        }
        
        [UIView beginAnimations:@"blah" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [super webView].frame = webViewFrame;
        
        [UIView commitAnimations];
    }
}


@end
