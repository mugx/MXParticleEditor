//
//  AppDelegate.m
//  MXParticleEditor
//
//  Created by mugx on 11/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "AppDelegate.h"
#import "MXOpenGLView.h"
#import "MXTextView.h"
#import "MXUtils.h"

@interface AppDelegate ()
@property IBOutlet NSWindow *window;
@property IBOutlet MXOpenGLView *openglView;
@property IBOutlet MXTextView *textView;
@end

@implementation AppDelegate

int main(int argc, const char * argv[]) {  return NSApplicationMain(argc, argv); }

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//  self.window.isZoomed = YES;
  [self.openglView startupGL];
  
  NSString *fileName = @"particlesConfig.json";
  NSString *file = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  NSString *json = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:nil];
  [self.textView setString:json];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  NSLog(@"applicationWillTerminate");
}

@end