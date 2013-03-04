//
//  MyLicenseWindowController.m
//  AppGrid
//
//  Created by Steven Degutis on 3/3/13.
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "MyLicenseWindowController.h"

@implementation MyLicenseWindowController

- (NSString*) windowNibName {
    return @"MyLicenseWindow";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) showStore:(id)sender {
    self.myStoreWindowController = [[MyStoreWindowController alloc] init];
    [self.myStoreWindowController showWindow:self];
}

@end
