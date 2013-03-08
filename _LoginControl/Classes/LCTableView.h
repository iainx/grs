//
//  SDTableView.h
//  LoginControl
//
//  Created by Steven Degutis on 5/27/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LCTableView : NSTableView {

}

- (void) registerDragOffTypes:(NSArray*)types;

@end

@interface NSObject(LCTableViewDelegateAdditions)

- (NSMenu*) tableView:(NSTableView*)tableView menuForRow:(NSInteger)row;
- (void) tableViewDidReceiveDeleteRequest:(NSTableView*)tableView;
- (BOOL) tableView:(NSTableView*)tableView shouldDragOffToDelete:(id<NSDraggingInfo>)info;

@end
