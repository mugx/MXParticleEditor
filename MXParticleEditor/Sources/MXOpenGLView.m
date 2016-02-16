//
//  MXOpenGLView.m
//  MXParticleEditor
//
//  Created by mugx on 11/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "MXOpenGLView.h"
#import "MXGameEngine.h"
#import "MXSceneManager.h"
#import "MXEntity.h"

typedef NS_ENUM(NSUInteger, SceneStatus) {
  SSStop,
  SSLoop,
  SSPlay,
  SSPause
};

#define UPDATE_TIME_BASE 0.025
#define UPDATE_TIME_INCR_STEP 0.01

@interface MXOpenGLView()
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) MXSceneManager *scene;
@property(nonatomic, strong) NSTimer *renderTimer;
@property(nonatomic, strong) MXEntity *mainEntity;
@property(nonatomic, assign) SceneStatus status;
@property(nonatomic, assign) float updateTime;
@property(nonatomic, assign) int incrSteps;
@property IBOutlet NSButton *button;
@end

@implementation MXOpenGLView

- (void)startupGL
{
  self.hidden = NO;
  [[self openGLContext] makeCurrentContext];
  [self initScene];
  [self initTimer:0];
}

- (void)initScene
{
  self.scene = [MXSceneManager new];
  [self.scene loadScene];
}

- (void)initTimer:(int)incrSteps
{
  self.incrSteps = incrSteps;
  if (incrSteps >= 0)
  {
    [self.button setTitle:[NSString stringWithFormat:@"%dx", 1 / 1 + incrSteps]];
  }
  else
  {
    [self.button setTitle:[NSString stringWithFormat:@"1/%dx", -(-1 + incrSteps)]];
  }
  self.timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_BASE - UPDATE_TIME_INCR_STEP * self.incrSteps target:self selector:@selector(updateWorld:) userInfo:nil repeats:YES];
  self.timer.tolerance = 0;
}

#pragma mark -Update & Draw

- (void)updateWorld:(id)sender
{
  if (self.status == SSPause)
  {
    return;
  }
  
  [self.scene update:0.025];
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];
  
  //--- Color & Depth buffer clearing ---//
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  //---- Viewport setting ----//
  glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
  
  [self.scene draw];
  [[self openGLContext] flushBuffer];
}

#pragma mark - IBActions

- (IBAction)loopTouched:(id)sender
{
  self.status = SSPlay;
  [self.scene.particleManager make:PSMidExplosion parentEntity:nil loop:YES];
}

- (IBAction)playTouched:(id)sender
{
  self.status = SSPlay;
  [self.scene.particleManager make:PSMidExplosion parentEntity:nil loop:NO];
}

- (IBAction)pauseTouched:(id)sender
{
  self.status = SSPause;
}

- (IBAction)stopTouched:(id)sender
{
  self.status = SSStop;
  [self.timer invalidate];
  [self initTimer:0];
  self.scene = nil;
  [self initScene];
}

- (IBAction)decrSpeedTouched:(id)sender
{
  [self.timer invalidate];
  [self initTimer:--self.incrSteps];
}

- (IBAction)incrSpeedTouched:(id)sender
{
  [self.timer invalidate];
  [self initTimer:++self.incrSteps];
}

@end