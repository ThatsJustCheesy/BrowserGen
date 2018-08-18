//
//  AppDelegate.m
//  BrowserGen
//
//  Created by Ian Gregory on 16-08-2018.
//  Copyright © 2018 ThatsJustCheesy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property(weak) IBOutlet NSWindow *window;
@property(weak) IBOutlet NSImageView *appIconImageView;
@property(weak) IBOutlet NSObjectController *configurationOC;
    
@end

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    // Insert code here to tear down your application
}

static void addLine(NSMutableString *string, NSString *line) {
    [string appendString:line];
    [string appendString:@"\n"];
}
- (NSString *)scriptInputString {
    NSMutableString *string = [NSMutableString new];
    NSDictionary *configuration = self.configurationOC.content;
    addLine(string, configuration[@"siteName"]);
    addLine(string, configuration[@"homepage"]);
    addLine(string, [configuration[@"initialTextSize"] stringValue]);
    addLine(string, configuration[@"appIconPath"] ?: @"[none]");
    return string;
}

- (void)awakeFromNib {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.configurationOC.selection setValue:@1.0 forKey:@"initialTextSize"];
    });
}

- (IBAction)chooseAppIcon:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = (__bridge_transfer id)UTTypeCopyAllTagsWithClass(kUTTypeImage, kUTTagClassFilenameExtension);
    
    BOOL result = [openPanel runModal];
    if (result != NSModalResponseOK) return;
    
    [self.configurationOC.selection setValue:openPanel.URL.path forKey:@"appIconPath"];
}

static NSData* dataFromString(NSString *string) {
    return [NSData dataWithBytes:string.UTF8String length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
}
static NSTask* makeGenerationTask(NSString *scriptInput) {
    NSTask *generationTask = [NSTask new];
    
    NSString *scriptName = @"Generate", *scriptExtension = @"rb";
    if (@available(macOS 10.13, *)) {
        generationTask.executableURL = [[NSBundle mainBundle] URLForResource:scriptName withExtension:scriptExtension];
    } else {
        generationTask.launchPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:scriptExtension];
    }
    
    NSPipe *inputPipe = [NSPipe pipe],
           *outputPipe = [NSPipe pipe],
           *errorPipe = [NSPipe pipe];
    generationTask.standardInput = inputPipe;
    generationTask.standardOutput = outputPipe;
    generationTask.standardError = errorPipe;
    
    [inputPipe.fileHandleForWriting writeData:dataFromString(scriptInput)];
    [inputPipe.fileHandleForWriting closeFile];
    
    return generationTask;
}
static void copyFileHandleContents(NSFileHandle *source, NSFileHandle *destination) {
    [destination writeData:[source readDataToEndOfFile]];
}
static void launchGenerationTask(NSTask *task) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSError *error = nil;
        if (@available(macOS 10.13, *)) {
            [task launchAndReturnError:&error];
        } else {
            [task launch];
        }
        [task waitUntilExit];
        
        copyFileHandleContents([task.standardOutput fileHandleForReading], [NSFileHandle fileHandleWithStandardOutput]);
        copyFileHandleContents([task.standardError fileHandleForReading], [NSFileHandle fileHandleWithStandardError]);
        
        if (error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [NSApp presentError:error];
            });
        }
    });
}
- (IBAction)generate:(id)sender {
    NSTask *generationTask = makeGenerationTask([self scriptInputString]);
    launchGenerationTask(generationTask);
}

@end
