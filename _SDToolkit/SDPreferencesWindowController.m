//
//  Copyright (c) 2013 Steven Degutis. All rights reserved.
//

#import "SDPreferencesWindowController.h"

#import "NSWindow+Geometry.h"


@interface SDPreferencesWindowController ()

@property BOOL showsPreferencesToolbar;

@property (weak) IBOutlet NSToolbar *toolbar;
@property (weak) IBOutlet NSView *paneContainerView;

@property NSMutableArray *toolbarItems;
@property NSMutableArray *preferencePaneControllers;

@end


@implementation SDPreferencesWindowController

- (NSString*) windowNibName {
    return @"SDPreferencesWindow";
}

- (void) showWindow:(id)sender {
    if (![[self window] isVisible])
        [[self window] center];
    
    [super showWindow:sender];
}

- (void) windowDidLoad {
    if (self.shouldFadeBetweenPanes)
        [self.paneContainerView setWantsLayer:YES];
    
	[self.toolbar setVisible:self.showsPreferencesToolbar];
	
	if ([[self toolbarItemIdentifiers] count] > 0)
		[self selectPreferencePaneWithIdentifier:[[self toolbarItemIdentifiers] objectAtIndex:0]];
}

- (void) usePreferencePaneControllerClasses:(NSArray*)classes {
    if (self.preferencePaneControllers) {
        NSLog(@"ERROR: you tried to call usePreferencePaneControllerClasses: more than once; not cool.");
        return;
    }
    
    self.preferencePaneControllers = [NSMutableArray array];
    self.toolbarItems = [NSMutableArray array];
    
    self.showsPreferencesToolbar = ([classes count] > 1);
    
	for (Class PrefPaneClass in classes) {
		// throw exception if it doesnt fit the protocol
		if ([PrefPaneClass conformsToProtocol:@protocol(SDPreferencePane)] == NO)
			@throw [NSException exceptionWithName:@"Illegal Preference Pane"
										   reason:@"Returned Preference pane does not conform to protocol"
										 userInfo:nil];
		
		id <SDPreferencePane> pane = [[PrefPaneClass alloc] init];
		[self.preferencePaneControllers addObject:pane];
		
		NSString *identifier = NSStringFromClass(PrefPaneClass);
		NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
		[self.toolbarItems addObject:item];
        
        NSImage* paneImage;
        
        if ([pane respondsToSelector:@selector(image)])
            paneImage = [pane image];
		
		[item setImage:paneImage];
		[item setLabel:[pane title]];
		[item setTarget:self];
		[item setAction:@selector(preferencesToolbarItemClicked:)];
	}
}

- (NSArray*) toolbarItemIdentifiers {
	return [self.toolbarItems valueForKey:@"itemIdentifier"];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)someToolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSUInteger index = [[self toolbarItemIdentifiers] indexOfObject:itemIdentifier];
	return [self.toolbarItems objectAtIndex:index];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)someToolbar {
	return [self toolbarItemIdentifiers];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)someToolbar {
	return [self toolbarItemIdentifiers];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)someToolbar {
	return [self toolbarItemIdentifiers];
}

- (void) selectPreferencePaneWithIdentifier:(NSString*)identifier {
	[self.toolbar setSelectedItemIdentifier:identifier];
	
	NSUInteger index = [[self toolbarItemIdentifiers] indexOfObject:identifier];
	id <SDPreferencePane> paneToSelect = [self.preferencePaneControllers objectAtIndex:index];
	
	NSView *oldSubview = [[self.paneContainerView subviews] lastObject];
	NSView *newSubview = [paneToSelect view];
	
	// remove old pane
    [[oldSubview animator] removeFromSuperview];
	
	// animate window
	[[self window] sd_setContentViewSize:[newSubview frame].size display:YES animate:YES];
	
	// add new pane
	[newSubview setFrameOrigin:NSZeroPoint];
	[[self.paneContainerView animator] addSubview:newSubview];
	
	// setting window title (if toolbar is shown)
	if (self.showsPreferencesToolbar)
		[[self window] setTitle:[paneToSelect title]];
}

- (IBAction) preferencesToolbarItemClicked:(id)sender {
	[self selectPreferencePaneWithIdentifier:[sender itemIdentifier]];
}

@end
