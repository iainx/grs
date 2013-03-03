//
//  AppDelegate.m
//  AppGrid
//
//  Created by Steven Degutis on 2/28/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "AppDelegate.h"

#import "MASShortcut.h"
#import "MyUniversalAccessHelper.h"
#import "MyGrid.h"

#import <AddressBook/AddressBook.h>



#import "CFobLicVerifier.h"
#import "NSString+PECrypt.h"



@implementation AppDelegate

+ (void) initialize {
    if (self == [AppDelegate self]) {
        NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    }
}

- (void) loadStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"statusitem"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"statusitem_pressed"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusBarMenu];
}

- (void) awakeFromNib {
    [self loadStatusItem];
}

- (IBAction) changeNumberOfGridColumns:(id)sender {
    NSInteger oldNum = [MyGrid width];
    NSInteger newNum = [[sender title] integerValue];
    
    if (oldNum != newNum)
        [MyGrid setWidth:newNum];
}

- (void) menuNeedsUpdate:(NSMenu *)menu {
    for (NSMenuItem* item in [menu itemArray]) {
        [item setState:NSOffState];
    }
    
    NSInteger num = [MyGrid width];
    NSString* numString = [NSString stringWithFormat:@"%ld", num];
    
    [[menu itemWithTitle:numString] setState:NSOnState];
}

- (IBAction) reallyShowAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction) showHotKeysWindow:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    
    if (self.myPrefsWindowController == nil)
        self.myPrefsWindowController = [[MyPrefsWindowController alloc] init];
    
    [self.myPrefsWindowController showWindow:self];
}

- (void) endTrialIfNecessary {
    NSDate* expires = [NSDate dateWithTimeIntervalSinceReferenceDate:383851680 + (60 * 60 * 24 * 7)];
    NSDate* now = [NSDate date];
    BOOL expired = ([now compare: expires] == NSOrderedDescending);
    
    if (expired) {
        [self.myActor unbindMyKeys];
        
        [NSApp activateIgnoringOtherApps:YES];
        NSRunAlertPanel(@"AppGrid's trial period is over", @"Let me know if you want an extended trial.", @"OK", nil, nil);
        [NSApp terminate:self];
    }
    
    [self performSelector:@selector(endTrialIfNecessary) withObject:nil afterDelay:60];
}

- (BOOL) verifyLicense:(NSString*)regCode for:(NSString*)regName {
//	NSString * regCode = @"GAWQE-FC67L-Q96B7-TVUHX-T66HB-CGJAE-CY94B-PT49C-CUAJD-K28HF-P69SF-RYCQ7-F9ZWS-FRSM8-AZP75-A";
	regName = [NSString stringWithFormat:@"AppGrid,%@", regName];
    
	NSString *publicKey =
    @"MIHxMIGpBgcqhkjOOAQBMIGdAkEApu5rog+tkWTO1cMy3284VgEMmDxQmY7hJRmn\n"
    @"skTFv7nRBCXva1pUhlOR/awOFyhkMBzRnen1NlimxOBSiCfivQIVAOtu+QXEbzXf\n"
    @"MMU1qyuhEp0o233zAkEApF6zQLuBy89fJ3gEP4V+N6J1hWzRv5VtQgrHpu635pkw\n"
    @"eQDtkQriu3tvrw85QotzKdgZVhmDkg0Uo7PfZpQ+lANDAAJAFuesN0blhZdMn0SX\n"
    @"EydQvrlQda7dEuI9zZo919yO/8SsSy9V7PU+HklIX7elMdhjtwdUlncKgZoaZREO\n"
    @"guP8lg==\n"
    ;
    
	publicKey = [CFobLicVerifier completePublicKeyPEM:publicKey];
    
	CFobLicVerifier * verifier = [[CFobLicVerifier alloc] init];
    [verifier setPublicKey:publicKey error:NULL];
    
	return ([verifier verifyRegCode:regCode forName:regName error:NULL]);
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
//    NSLog(@"%@", url);
    
    // URL has the following format:
	// com.mycompany.myapp.lic://<base64-encoded-username>/<serial-number>
	NSArray *protocolAndTheRest = [url componentsSeparatedByString:@"://"];
	if ([protocolAndTheRest count] != 2) {
		NSLog(@"License URL is invalid (no protocol)");
		return;
	}
	// Separate user name and serial number
	NSArray *userNameAndSerialNumber = [[protocolAndTheRest objectAtIndex:1] componentsSeparatedByString:@"/"];
	if ([userNameAndSerialNumber count] != 2) {
		NSLog(@"License URL is invalid (missing parts)");
		return;
	}
	// Decode base64-encoded user name
	NSString *usernameb64 = (NSString *)[userNameAndSerialNumber objectAtIndex:0];
	NSString *username = [usernameb64 base64Decode];
	NSLog(@"User name: %@", username);
	NSString *serial = (NSString *)[userNameAndSerialNumber objectAtIndex:1];
	NSLog(@"Serial: %@", serial);
    
    NSLog(@"valid license? %d", [self verifyLicense:serial for:username]);
    
	// TODO: Save registration to preferences.
	// TODO: Broadcast notification of a changed registration information.
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self endTrialIfNecessary];
    
    self.embeddedStoreController = [[FsprgEmbeddedStoreController alloc] init];
    self.embeddedStoreController.delegate = self;
    self.embeddedStoreController.webView = self.storeWebView;
    
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleURLEvent:withReplyEvent:)
                                                     forEventClass:kInternetEventClass
                                                        andEventID:kAEGetURL];
    
    [self loadStore:self];
    
    [MyUniversalAccessHelper complainIfNeeded];
    
    [MASShortcut setAllowsAnyHotkeyWithOptionModifier:YES];
    
    self.myActor = [[MyActor alloc] init];
    [self.myActor bindMyKeys];
    
    self.howToWindowController = [[SDHowToWindowController alloc] init];
    [self.howToWindowController showInstructionsWindowFirstTimeOnly];
}


- (IBAction) loadStore:(id)sender
{
	FsprgStoreParameters *parameters = [FsprgStoreParameters parameters];
	[parameters setOrderProcessType:kFsprgOrderProcessDetail];
	[parameters setStoreId:@"applyconcat" withProductId:@"appgrid"];
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

- (void)didLoadStore:(NSURL *)url
{
}

- (void)didLoadPage:(NSURL *)url ofType:(FsprgPageType)pageType
{
}

- (void)didReceiveOrder:(FsprgOrder *)order
{
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

- (NSView *)viewWithFrame:(NSRect)frame forOrder:(FsprgOrder *)order
{
    NSLog(@"ignoring this thing");
    
    return [[NSBox alloc] initWithFrame:NSZeroRect];
//	OrderViewController *orderViewController = [[OrderViewController alloc] initWithNibName:@"OrderView" bundle:nil];
//	[orderViewController setRepresentedObject:order];
//    
//	[[orderViewController view] setFrame:frame];
//	return [orderViewController view];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	NSRunAlertPanel(@"Alert", [error localizedDescription], @"OK", nil, nil);
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	NSRunAlertPanel(@"Alert", [error localizedDescription], @"OK", nil, nil);
}

@end
