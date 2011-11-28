// (c) 2011 Nadav Greenberg

/*global PhoneGap */

function ZEDOAdPlugin() {
    // do nothing
}

/**
 * initAds - true to show the ad at screen bottom, false to show at top
 * ad size is fixed at 320x50, without ability to listen to orientation change
 * or be presented normally at vertical orientation
 */
ZEDOAdPlugin.prototype.initAds = function(isAtBottom)
{
    console.log('initAds js called');
    
	PhoneGap.exec(function success() {
            console.log('success: initAds');
        }, 
        function failure() {
            console.log('failure: initAds');
        },
    "ZEDOAdPlugin", "initAds", [isAtBottom]);
    
}

/**
* setAdTag - newTag is a full script tag to use
*/
ZEDOAdPlugin.prototype.setAdTag = function(newTag) {
    console.log('setAdTag js called');
        
    // no need for callback    
    PhoneGap.exec("ZEDOAdPlugin.setAdTag", newTag);
}

/**
* setAdTagURL - newTagUrl is a url from which to fetch tags
*/
ZEDOAdPlugin.prototype.setAdTagURL = function(newTagUrl) {
    console.log('setAdTagURL js called');
    
    // no need for callback    
    PhoneGap.exec("ZEDOAdPlugin.setAdTagURL", newTagUrl);
}

/**
* setAutoRefresh - refreshRateSec is refresh time in seconds. 
* if this method is not called, the default is 200 seconds
*/
ZEDOAdPlugin.prototype.setAutoRefresh = function(refreshRateSec) {
    console.log('setAutoRefresh js called');
    
    // no need for callback    
    PhoneGap.exec("ZEDOAdPlugin.setAutoRefresh", refreshRateSec);
}

/**
* setCollapsable - isCollapsable Tells the library if it should or should not collapse (hide) the web view area when a blank ad is being served. If a blank ad is being served it may be deemed appropriate to hide the empty white area from the screen. The default behavior of the library is to hide the web view in such cases.
*/
ZEDOAdPlugin.prototype.setCollapsable = function(isCollapsable) {
    console.log('setCollapsable js called');

    // no need for callback    
    PhoneGap.exec("ZEDOAdPlugin.setCollapsable", isCollapsable);
}


/** 
*    Various events the user can set callbacks to
*/

// user can register to callback on ad opened (after clicked) event 
ZEDOAdPlugin.prototype.setOpenCallback = function(callback) {
    //ZEDOAdPlugin.prototype.onOpenCallback = callback;
    window.plugins.ZEDOAdPlugin.onOpenCallback = callback;
}

// user can register to callback on ad closed (from ad's view) event 
ZEDOAdPlugin.prototype.setCloseCallback = function(callback) {
    window.plugins.ZEDOAdPlugin.onCloseCallback = callback;
}

// user can register to callback on ad requested from server event 
ZEDOAdPlugin.prototype.setAdRequestedCallback = function(callback) {
    window.plugins.ZEDOAdPlugin.onAdRequestedCallback = callback;
}

// user can register to callback on ad loaded (from server) event 
ZEDOAdPlugin.prototype.setAdLoadedCallback = function(callback) {
    window.plugins.ZEDOAdPlugin.onAdLoadedCallback = callback;
}

// user can register to callback on ad failed to load (from server) event 
ZEDOAdPlugin.prototype.setAdFailedCallback = function(callback) {
    window.plugins.ZEDOAdPlugin.onAdFailedCallback = callback;
}


/**
*       Methods called from native
*/

// called when native event onOpen occurs
ZEDOAdPlugin._onOpenCallback = function() {
    if (window.plugins.ZEDOAdPlugin.onOpenCallback) {
        window.plugins.ZEDOAdPlugin.onOpenCallback();
    }
}

// called when native event onClose occurs
ZEDOAdPlugin._onCloseCallback = function() {
    if (window.plugins.ZEDOAdPlugin.onCloseCallback) {
        window.plugins.ZEDOAdPlugin.onCloseCallback();
    }
}

// called when native event onAdRequested occurs
ZEDOAdPlugin._onAdRequestedCallback = function() {
    if (window.plugins.ZEDOAdPlugin.onAdRequestedCallback) {
        window.plugins.ZEDOAdPlugin.onAdRequestedCallback();
    }
}

// called when native event onAdLoaded occurs
ZEDOAdPlugin._onAdLoadedCallback = function() {
    if (window.plugins.ZEDOAdPlugin.onAdLoadedCallback) {
        window.plugins.ZEDOAdPlugin.onAdLoadedCallback();
    }
}

// called when native event onAdFailed occurs
ZEDOAdPlugin._onAdFailedCallback = function() {
    if (window.plugins.ZEDOAdPlugin.onAdFailedCallback) {
        window.plugins.ZEDOAdPlugin.onAdFailedCallback();
    }
}



/**
 * Install function
 */
ZEDOAdPlugin.install = function()
{
	if ( !window.plugins ) 
		window.plugins = {}; 
	if ( !window.plugins.ZEDOAdPlugin ) 
		window.plugins.ZEDOAdPlugin = new ZEDOAdPlugin();
}

/**
 * Add to PhoneGap constructor
 */
PhoneGap.addConstructor(ZEDOAdPlugin.install);