//
//  MXTextureManager.m
//  ProjectKyut
//
//  Created by mugx on 23/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXTextureManager.h"
#import <GLKit/GLKit.h>

@interface MXTextureManager()
@property(nonatomic,strong) NSMutableDictionary *textureDictionary;
@end

@implementation MXTextureManager

- (void)dealloc
{
  [self unload];
}

- (void)load
{
  self.textureDictionary = [[NSMutableDictionary alloc] init];
}

- (void)unload
{
  for (GLKTextureInfo *textureInfo in [self.textureDictionary allValues])
  {
    GLuint name = textureInfo.name;
    glDeleteTextures(1,&name);
  }
  [self.textureDictionary removeAllObjects];
  self.textureDictionary = nil;
}

// https://developer.apple.com/library/ios/documentation/GLkit/Reference/GLKTextureLoader_ClassRef/index.html
- (GLuint)loadTexture:(NSString *)fileName
{
  if (self.textureDictionary[fileName])
  {
    GLKTextureInfo *textureInfo = self.textureDictionary[fileName];
    return textureInfo.name;
  }
  
  NSError *error;
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:YES],
                           GLKTextureLoaderOriginBottomLeft,
                           [NSNumber numberWithBool:YES],
                           GLKTextureLoaderGenerateMipmaps,
                           [NSNumber numberWithBool:NO],
                           GLKTextureLoaderApplyPremultiplication,
                           nil];
  NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:&error];
  // GL_LINEAR_MIPMAP_NEAREST // bilinear with mipmaps
  // GL_LINEAR_MIPMAP_LINEAR // trilinear
  // GL_CLAMP_TO_EDGE
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  
  if (!error)
  {
    [self.textureDictionary setObject:textureInfo forKey:fileName];
    return textureInfo.name;
  }
  else
  {
    return -1;
  }
}

- (GLuint)loadCubeMapTexture:(NSArray *)array
{
  NSMutableArray *skyboxArray = [NSMutableArray array];
  for (NSString *fileName in array)
  {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    [skyboxArray addObject:filePath];
  }
  NSString *skyboxId = [skyboxArray description];
  
  if (self.textureDictionary[skyboxId])
  {
    GLKTextureInfo *textureInfo = self.textureDictionary[skyboxId];
    return textureInfo.name;
  }
  
  NSError *error;
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:YES],
                           GLKTextureLoaderOriginBottomLeft,
                           [NSNumber numberWithBool:YES],
                           GLKTextureLoaderGenerateMipmaps,
                           [NSNumber numberWithBool:NO],
                           GLKTextureLoaderApplyPremultiplication,
                           nil];
  GLKTextureInfo *textureInfo = [GLKTextureLoader cubeMapWithContentsOfFiles:skyboxArray options:options error:&error];
  if (!error)
  {
    [self.textureDictionary setObject:textureInfo forKey:skyboxId];
    return textureInfo.name;
  }
  else
  {
    return -1;
  }
}

@end