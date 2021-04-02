//
//  AppDelegate.h
//  OrgClockStatusbar
//
//  Created by Alex Scherbanov on 11/09/14.
//  Copyright (c) 2014 egotv.ru. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;

@property NSImage* orgClockedIn;  // both should be readonly
@property NSImage* orgClockedOut;  // but whatever
@property BOOL status;


- (IBAction)openGithubPage:(id)sender;
- (IBAction)toggleRedMeansClockedOut:(id)sender;

- (void) onBarClockIn;
- (void) clockOut;
- (NSString*) toggle;


@end
