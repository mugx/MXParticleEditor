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
  NSLog(@"MXSceneManager::unloadScene");
  _camera = nil;
  _particleManager = nil;
  [[MXGameEngine sharedInstance] unload];
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