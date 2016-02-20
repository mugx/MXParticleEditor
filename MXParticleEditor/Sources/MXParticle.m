//
//  MXParticle.m
//  ProjectKyut
//
//  Created by mugx on 17/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXParticle.h"
#import "MXGameEngine.h"

@implementation MXParticle

- (instancetype)init
{
  self = [super init];
  super.isVisible = NO;
  return self;
}

- (void)randomizePosition
{
  self.position = GLKVector3Make(0, RAND(0, -0.1), 0);
  self.fade = RAND(0.05, 0.2);
  self.velocity = GLKVector3Make(RAND(-0.05, 0.05), RAND(self.fade * -0.5f, self.fade * -0.1f), 0);
}
 
- (void)respawnFrom:(MXEntity *)parentEntity dictionary:(NSDictionary *)dictionary
{
  self.parentEntity = parentEntity;
  self.isVisible = YES;
  self.alpha = 1.0f;
  self.dictionary = dictionary;
  
  self.textureID = [[MXGameEngine sharedInstance].textureManager loadTexture:dictionary[@"texture"]];
  self.scale = GLKVector3(dictionary[@"scale"]);
  self.colorMaterial = GLKVectorRGB(dictionary[@"color"]);
  self.mesh = [[MXGameEngine sharedInstance].meshManager loadMesh:dictionary[@"model"]];
  self.centerOfCoordinateSystemOffset = GLKVector3(dictionary[@"centerOfCoordinateSystemOffset"]);
  
  self.fade = RAND([dictionary[@"fade"][@"min"] floatValue],
                   [dictionary[@"fade"][@"max"] floatValue]);
  
  if (dictionary[@"scale"][@"min"])
  {
    float scale = RAND([dictionary[@"scale"][@"min"] floatValue],
                       [dictionary[@"scale"][@"max"] floatValue]);
    self.scale = GLKVector3Make(scale,scale,scale);
  }
  else if (dictionary[@"scale"][@"x"])
  {
    self.scale = GLKVector3(dictionary[@"scale"]);
  }
  
  self.position = GLKVector3Make(0, 0, 0);
  self.velocity = GLKVector3Make(RAND([dictionary[@"velocity"][@"min_x"] floatValue], [dictionary[@"velocity"][@"max_x"] floatValue]),
                                 RAND([dictionary[@"velocity"][@"min_y"] floatValue], [dictionary[@"velocity"][@"max_y"] floatValue]),
                                 0);
  self.acceleration = GLKVector3Make(self.velocity.x * [dictionary[@"acceleration"][@"x"] floatValue],
                                     self.velocity.y * [dictionary[@"acceleration"][@"y"] floatValue],
                                     0);
  
  [self updateCenterOfCoordinateSystem:parentEntity];
  [self update:0];
}

- (void)updateCenterOfCoordinateSystem:(MXEntity *)parentEntity
{
  if (parentEntity)
  {
    float posy = -parentEntity.mesh.boundingVolumeRadius * parentEntity.scale.y + self.centerOfCoordinateSystemOffset.y;
    self.centerOfCoordinateSystem = GLKVector3Make(parentEntity.position.x, posy + parentEntity.position.y, parentEntity.position.z);
  }
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
  [super update:timeSinceLastUpdate];
  
  self.alpha -= self.fade;
  if (self.alpha <= 0.0f)
  {
    self.isVisible = NO;
  }
}

@end
