//
//  OrgClockStatusbarTests.m
//  OrgClockStatusbarTests
//
//  Created by Alex Scherbanov on 11/09/14.
//  Copyright (c) 2014 egotv.ru. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface OrgClockStatusbarTests : XCTestCase

@end

@implementation OrgClockStatusbarTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    //定时获取任务信息
    NSTask *task1 = [NSTask new];
    task1.launchPath = @"/usr/local/bin/emacsclient";
    task1.arguments = @[@"-e",@"'(org-clock-get-clock-string)'"];
    NSPipe *pipe = [NSPipe pipe];
    [task1 setStandardOutput:pipe];
    [task1 setStandardError:pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    [task1 launch];
    
NSString *securityResult = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding];
    
//函数输出结果
    NSLog(@"9999%@",securityResult);
//    NSError *err;
//    [NSTask launchedTaskWithExecutableURL:[NSURL URLWithString:@"/usr/local/bin/emacsclient"] arguments:@[@"-h"] error:&err terminationHandler:^(NSTask * task) {
//
//    }];
//    NSLog(@"错误信息：%@",err);
}
- (void)testTask
{
    
    /**
     
     let myAppleScript = "on run\ndo shell script \"open -na /Applications/mpv.app \(videoPath!)\"\n tell application \"mpv\" to activate\n end run"
     print(myAppleScript)
     var error: NSDictionary?
     if let scriptObject = NSAppleScript(source: myAppleScript) {
         if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
             &error) {
             print(output.stringValue)
         } else if (error != nil) {
             print("error: \(error)")
         }
     }
     */
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"on run\ndo shell script \"/usr/local/bin/emacsclient -e '(org-clock-get-clock-string)'\"\nend run"];
    
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    
    if (returnDescriptor != NULL)
    {
        NSLog(@"Script execution has succeed. Result(%@)",returnDescriptor);
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
            // script returned an AppleScript result
            if (cAEList == [returnDescriptor descriptorType])
            {
                // result is a list of other descriptors
            }
            else
            {
                // coerce the result to the appropriate ObjC type
            }
        }
    }
    else
    {
        // no script result, handle error here
        
    }
}

@end
