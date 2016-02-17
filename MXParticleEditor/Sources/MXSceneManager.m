//
//  MXSceneManager.m
//  ProjectKyut
//
//  Created by mugx on 03/06/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import "MXSceneManager.h"
#import "MXGameEngine.h"

@interface MXSceneManager()
@property(nonatomic, strong, readwrite) MXCamera *camera;
@property(nonatomic, strong, readwrite) MXParticleManager *particleManager;
@end

@implementation MXSceneManager

+ (instancetype)sharedInstance
{
  static dispatch_once_t predicate;
  static MXSceneManager *instance = 0;
  dispatch_once(&predicate, ^{
    instance = [[MXSceneManager alloc] init];
  });
  return instance;
}

#pragma mark - LoadScene
- (void)loadScene
{
  [[MXGameEngine sharedInstance] load];  
  NSDictionary *gameJson = [MXUtils jsonFromFile:@"globalConfig.json"];
  self.camera = [[MXCamera alloc] init:gameJson withScene:self];
  self.particleManager = [[MXParticleManager alloc] initWithScene:self];
}

- (void)unloadScene
{
  [[MXGameEngine sharedInstance] unload];
  
  _camera = nil;
  _particleManager = nil;
}

#pragma mark - Update & Draw
- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
  [self.camera update:timeSinceLastUpdate];
  [self.particleManager update:timeSinceLastUpdate];
}

- (void)draw
{
  glDepthMask(GL_FALSE);
  glEnable(GL_BLEND);
  glBlendFunc(GL_ONE, GL_ONE);
  [self.particleManager draw];
  glDepthMask(GL_TRUE);
}

@end