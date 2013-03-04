//
//  MyLicenseWindowController.h
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FsprgEmbeddedStoreController.h"
#import "FsprgEmbeddedStoreDelegate.h"

@interface MyStoreWindowController : NSWindowController <FsprgEmbeddedStoreDelegate>

@property (weak) IBOutlet WebView* storeWebView;

@property FsprgEmbeddedStoreController *embeddedStoreController;

@end
