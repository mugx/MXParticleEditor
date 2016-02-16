//
//  MXGameEngine.m
//  ProjectKyut
//
//  Created by mugx on 15/01/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "MXGameEngine.h"

@interface MXGameEngine()
@property(nonatomic,strong,readwrite) MXShaderManager *shaderManager;
@property(nonatomic,strong,readwrite) MXTextureManager *textureManager;
@property(nonatomic,strong,readwrite) MXMeshManager *meshManager;
@end

@implementation MXGameEngine

+ (instancetype)sharedInstance
{
  static MXGameEngine *instance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[MXGameEngine alloc] init];
  });
  return instance;
}

- (instancetype)init
{
  self = [super init];
  return self;
}

- (void)dealloc
{
  [self unload];
}

- (void)load
{
  self.shaderManager = [[MXShaderManager alloc] init];
  [self.shaderManager load];

  self.textureManager = [[MXTextureManager alloc] init];
  [self.textureManager load];

  self.meshManager = [[MXMeshManager alloc] init];
  [self.meshManager load];
}

- (void)unload
{
  if (self.shaderManager)
  {
    [self.shaderManager unload];
    self.shaderManager = nil;
  }

  if (self.textureManager)
  {
    [self.textureManager unload];
    self.textureManager = nil;
  }
  
  if (self.meshManager)
  {
    [self.meshManager unload];
    self.meshManager = nil;
  }
}

@end