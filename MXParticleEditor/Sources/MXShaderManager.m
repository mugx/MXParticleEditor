//
//  ShaderManager.m
//  ProjectKyut
//
//  Created by mugx on 10/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import "MXShaderManager.h"

@interface MXShaderManager()
@property(nonatomic,strong) NSMutableDictionary *shadersDictionary;
@end

@implementation MXShaderManager

#pragma mark - Manager setup

- (void)load
{
  if (self.shadersDictionary)
  {
    return;
  }
  else
  {
    self.shadersDictionary = [NSMutableDictionary dictionary];
  }
  
  MXShader *shader = [MXShader create:@"Shader"];
  if (shader)
  {
    [self.shadersDictionary setObject:shader forKey:[NSNumber numberWithInt:MXShaderTypeStandard]];
  }
  else
  {
    NSLog(@"Error loading shaders...");
  }
}

- (void)unload
{
  NSLog(@"MXShaderManager::unload");
  if (!self.shadersDictionary)
  {
    return;
  }
  
  [self.shadersDictionary removeAllObjects];
  self.shadersDictionary = nil;
}

#pragma mark - Use Shader

- (MXShader *)useShader:(MXShaderType)type
{
  MXShader *shader = self.shadersDictionary[[NSNumber numberWithInt:type]];
  if (shader)
  {
    [shader useProgram];
  }
  return shader;
}

@end