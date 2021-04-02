//
//  AppDelegate.m
//  OrgClockStatusbar
//
//  Created by Alex Scherbanov on 11/09/14.
//  Copyright (c) 2014 egotv.ru. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "RegExCategories.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@synthesize statusBar = _statusBar;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // self.statusBar.title = @"Text";
    self.orgClockedOut = [NSImage imageNamed:@"black box"];
    self.orgClockedIn = [NSImage imageNamed:@"red box"];
    self.statusBar.menu = self.statusMenu;
    [self.statusBar.button setImagePosition:NSImageRight];
    self.statusBar.button.highlighted = YES;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"swapRedAndBlack"]) {
    
    }
    [self loadPrefs];
    [self clockOut];
    
    NSTimer *_timer;
    _timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(onBarClockIn) userInfo:nil repeats:YES];
   [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void) onBarClockIn
{
    //通过appScript调用emacsclient获取任务
    NSString *task = [self emacsTaskName];
    [self.statusBar.menu itemWithTag:1].title = task;
    self.statusBar.button.toolTip = task;
    //设置在状态栏显示当前任务
    [self.statusBar.button setTitle:task];
    self.status = YES;
}


-(void) clockOut {
    NSString *task = [self emacsTaskName];
    self.statusBar.button.image = self.orgClockedOut;
    [self.statusBar.menu itemWithTag:1].title = task;
    self.statusBar.button.toolTip = task;
    self.status = NO;
}

-(void) refresh {
    if (self.status) {
        self.statusBar.button.image = self.orgClockedIn;
    } else {
        self.statusBar.button.image = self.orgClockedOut;
    }
}

-(IBAction)openGithubPage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/iT-Boyer/org-clock-statusbar-app"]];
}

-(IBAction)toggleRedMeansClockedOut:(id)sender
{
    [self toggle];
}

- (void)loadPrefs {
    NSMenuItem * theItem = [self.statusBar.menu itemWithTag:2];   // set it manually in interface builder
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"swapRedAndBlack"]) {
        [theItem setState: NSControlStateValueOn];
        self.orgClockedOut = [NSImage imageNamed:@"black box"];
        self.orgClockedIn = [NSImage imageNamed:@"red box"];
    } else {
        [theItem setState: NSControlStateValueOff];
        self.orgClockedOut = [NSImage imageNamed:@"red box"];
        self.orgClockedIn = [NSImage imageNamed:@"black box"];
    }
    [self refresh];
}

- (NSString*)toggle {
    NSMenuItem * theItem = [self.statusBar.menu itemWithTag:2];   // set it manually in interface builder
    NSString* result;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"swapRedAndBlack"]) {
        [theItem setState: NSControlStateValueOff];
        self.orgClockedOut = [NSImage imageNamed:@"red box"];
        self.orgClockedIn = [NSImage imageNamed:@"black box"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"swapRedAndBlack"];
        result = @"now unchecked";
    } else {
        [theItem setState: NSControlStateValueOn];
        self.orgClockedOut = [NSImage imageNamed:@"black box"];
        self.orgClockedIn = [NSImage imageNamed:@"red box"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"swapRedAndBlack"];
        result = @"now checked";
    }
    [self refresh];
    
    return result;
}


#pragma mark - emacs
-(NSString *)emacsTaskName
{
    NSString *active = [self outOfAppScriptcommand:@"org-clock-is-active"];
    if ([active isEqualToString:@"nil"]) {
        return @"无安排";
    }
    NSString *clock = [self outOfAppScriptcommand:@"org-clock-get-clock-string"];
    //处理字符串：#(" [22:54] (org-agenda 科学使用 [0%])" 0 31
    //(face org-mode-line-clock))
    clock = [RX(@"\\[\\d.*\\)") firstMatch:clock];
    return clock;
}

//通过AppScript脚本获取任务
-(NSString *)outOfAppScriptcommand:(NSString *)command
{
    NSString *script = [NSString stringWithFormat:@"on run\ndo shell script \"/usr/local/bin/emacsclient -e '(%@)'\"\nend run",command];
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:script];
    NSString *result = @"nil";
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    if (!errorDict)
    {
        result = returnDescriptor.stringValue;
    }
    return result;
}
//使用shell命令获取：无效
-(NSString *)outOfcommand:(NSArray *)commandArguments
{
    NSTask *_emacsTask = [NSTask new];
    _emacsTask.launchPath = @"/usr/local/bin/emacsclient";
    _emacsTask.arguments = commandArguments;
    NSPipe *pipe = [NSPipe pipe];
    [_emacsTask setStandardOutput:pipe];
    [_emacsTask setStandardError:pipe];
    [_emacsTask launch];
    NSFileHandle *handle = [pipe fileHandleForReading];
    NSString *output = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding];
    return output;
}

@end
