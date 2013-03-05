//
//  MyLicenseWindowController.m
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyStoreWindowController.h"

#import <AddressBook/AddressBook.h>

@implementation MyStoreWindowController

- (NSString*) windowNibName {
    return @"MyStoreWindow";
}

- (void) windowDidLoad {
    [super windowDidLoad];
    
    self.embeddedStoreController = [[FsprgEmbeddedStoreController alloc] init];
    self.embeddedStoreController.delegate = self;
    self.embeddedStoreController.webView = self.storeWebView;
    
	FsprgStoreParameters *parameters = [FsprgStoreParameters parameters];
	[parameters setOrderProcessType:kFsprgOrderProcessInstant];
	[parameters setStoreId:@"giantrobotsoftware" withProductId:@"appgrid"];
	[parameters setMode:kFsprgModeTest];
	
	ABPerson *me = [[ABAddressBook sharedAddressBook] me];
	[parameters setContactFname:[me valueForProperty:kABFirstNameProperty]];
	[parameters setContactLname:[me valueForProperty:kABLastNameProperty]];
	[parameters setContactCompany:[me valueForProperty:kABOrganizationProperty]];
	
	ABMultiValue *allEmails = [me valueForProperty:kABEmailProperty];
	NSString *email = [allEmails valueAtIndex:[allEmails indexForIdentifier:[allEmails primaryIdentifier]]];
	[parameters setContactEmail:email];
	
	ABMultiValue *allPhones = [me valueForProperty:kABPhoneProperty];
	NSString *phone = [allPhones valueAtIndex:[allPhones indexForIdentifier:[allPhones primaryIdentifier]]];
	[parameters setContactPhone:phone];
	
	[self.embeddedStoreController loadWithParameters:parameters];
}

// FsprgEmbeddedStoreDelegate

- (void)didLoadStore:(NSURL *)url {
}

- (void)didLoadPage:(NSURL *)url ofType:(FsprgPageType)pageType {
}

- (void)didReceiveOrder:(FsprgOrder *)order {
	NSLog(@"Order from %@ successfully received.", [order customerEmail]);
    
    for (FsprgOrderItem* item in [order orderItems]) {
        if ([[item productName] hasPrefix:@"MyItemNamePrefix"]) {
            NSString *userName = [[item license] licenseName];
            NSString *serialNumber = [[item license] firstLicenseCode];
            if ([[[item productName] lowercaseString] rangeOfString:@"upgrade"].location != NSNotFound) {
                NSLog(@"Upgrade purchase:\nName: %@\nSerial #: %@", userName, serialNumber);
            } else {
                NSLog(@"Full purchase:\nName: %@\nSerial #: %@", userName, serialNumber);
            }
        }
    }
}

- (NSView *)viewWithFrame:(NSRect)frame forOrder:(FsprgOrder *)order {
    return [[NSBox alloc] initWithFrame:frame];
    //	OrderViewController *orderViewController = [[OrderViewController alloc] initWithNibName:@"OrderView" bundle:nil];
    //	[orderViewController setRepresentedObject:order];
    //
    //	[[orderViewController view] setFrame:frame];
    //	return [orderViewController view];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
	NSRunAlertPanel(@"Alert", [error localizedDescription], @"OK", nil, nil);
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
	NSRunAlertPanel(@"Alert", [error localizedDescription], @"OK", nil, nil);
}

@end
