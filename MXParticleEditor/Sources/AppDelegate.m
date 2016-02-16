//
//  AppDelegate.m
//  MXParticleEditor
//
//  Created by mugx on 11/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "AppDelegate.h"
#import "MXParticleOpenGLView.h"
#import "MXParticleEditorView.h"
#import "MXUtils.h"

@interface AppDelegate ()
@property IBOutlet NSWindow *window;
@property IBOutlet MXParticleOpenGLView *openGLView;
@property IBOutlet MXParticleEditorView *editorView;
@end

@implementation AppDelegate

int main(int argc, const char * argv[]) {  return NSApplicationMain(argc, argv); }

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//  self.window.isZoomed = YES;
  [self.openGLView startupGL];
  self.editorView.glView = self.openGLView;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  NSLog(@"applicationWillTerminate");
}

@end