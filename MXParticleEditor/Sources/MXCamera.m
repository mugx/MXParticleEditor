//
//  MXCamera.m
//  ProjectKyut
//
//  Created by mugx on 28/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import "MXCamera.h"
#import "MXMathUtils.h"

@interface MXCamera()
@property(nonatomic,weak) MXSceneManager *sceneManager;
@end

@implementation MXCamera

- (instancetype)init:(NSDictionary *)dictionary withScene:(MXSceneManager *)sceneManager
{
  self = [super init];
  _sceneManager = sceneManager;
  _eye = [MXMathUtils GLKVector3Make:dictionary[@"camera"][@"eye"]];
  _center = [MXMathUtils GLKVector3Make:dictionary[@"camera"][@"center"]];
  _velocity = [MXMathUtils GLKVector3Make:dictionary[@"camera"][@"velocity"]];
  _zoomFactor = 1.0f;
  return self;
}

- (FrustumCollision)sphereInFrustum:(GLKVector3)position radius:(float)radius
{
  for (int face = 0; face < 6; ++face)
  {
    float distance = self->frustum[face][0] * position.x +
    self->frustum[face][1] * position.y +
    self->frustum[face][2] * position.z +
    self->frustum[face][3];
    
    if ((distance <= +radius) && (distance > -radius)) // la sfera interseca la faccia 'face' del frustum
    {
      return face;
    }
    else if (distance <= -radius) // the sphere is outside the frustum, return
    {
      return FCExtern;
    }
  }
  
  return FCIntern;
}

- (GLKMatrix4)getProjectionMatrix
{
  CGRect bounds = [[[NSApplication sharedApplication] mainWindow] frame];
  float aspect = fabsf((float)bounds.size.width / (float)bounds.size.height);
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(50.0f) * self.zoomFactor, aspect, 0.1f, 3000.0f);
  return projectionMatrix;
}

- (GLKMatrix4)getViewMatrix
{
  return GLKMatrix4MakeLookAt(self.eye.x, self.eye.y, self.eye.z, self.center.x, self.center.y, self.center.z, 0.0, 1.0, 0.0);
}

- (void)extractFrustum
{
  float clip[16];
  float *model = [self getViewMatrix].m;
  float *projection = [self getProjectionMatrix].m;
  
  clip[0] = model[0] * projection[0] + model[1] * projection[4] + model[2] * projection[8] + model[3] * projection[12];
  clip[1] = model[0] * projection[1] + model[1] * projection[5] + model[2] * projection[9] + model[3] * projection[13];
  clip[2] = model[0] * projection[2] + model[1] * projection[6] + model[2] * projection[10] + model[3] * projection[14];
  clip[3] = model[0] * projection[3] + model[1] * projection[7] + model[2] * projection[11] + model[3] * projection[15];
  
  clip[4] = model[4] * projection[0] + model[5] * projection[4] + model[6] * projection[8] + model[7] * projection[12];
  clip[5] = model[4] * projection[1] + model[5] * projection[5] + model[6] * projection[9] + model[7] * projection[13];
  clip[6] = model[4] * projection[2] + model[5] * projection[6] + model[6] * projection[10] + model[7] * projection[14];
  clip[7] = model[4] * projection[3] + model[5] * projection[7] + model[6] * projection[11] + model[7] * projection[15];
  
  clip[8] = model[8] * projection[0] + model[9] * projection[4] + model[10] * projection[8] + model[11] * projection[12];
  clip[9] = model[8] * projection[1] + model[9] * projection[5] + model[10] * projection[9] + model[11] * projection[13];
  clip[10] = model[8] * projection[2] + model[9] * projection[6] + model[10] * projection[10] + model[11] * projection[14];
  clip[11] = model[8] * projection[3] + model[9] * projection[7] + model[10] * projection[11] + model[11] * projection[15];
  
  clip[12] = model[12] * projection[0] + model[13] * projection[4] + model[14] * projection[8] + model[15] * projection[12];
  clip[13] = model[12] * projection[1] + model[13] * projection[5] + model[14] * projection[9] + model[15] * projection[13];
  clip[14] = model[12] * projection[2] + model[13] * projection[6] + model[14] * projection[10] + model[15] * projection[14];
  clip[15] = model[12] * projection[3] + model[13] * projection[7] + model[14] * projection[11] + model[15] * projection[15];
  
  // Extract the numbers for the RIGHT plane
  frustum[0][0] = clip[3] - clip[0];
  frustum[0][1] = clip[7] - clip[4];
  frustum[0][2] = clip[11] - clip[8];
  frustum[0][3] = clip[15] - clip[12];
  
  // Normalize the result
  double t = sqrt(frustum[0][0] * frustum[0][0] + frustum[0][1] * frustum[0][1] + frustum[0][2] * frustum[0][2]);
  frustum[0][0] /= t;
  frustum[0][1] /= t;
  frustum[0][2] /= t;
  frustum[0][3] /= t;
  
  // Extract the numbers for the LEFT plane
  frustum[1][0] = clip[3] + clip[0];
  frustum[1][1] = clip[7] + clip[4];
  frustum[1][2] = clip[11] + clip[8];
  frustum[1][3] = clip[15] + clip[12];
  
  // Normalize the result
  t = sqrt(frustum[1][0] * frustum[1][0] + frustum[1][1] * frustum[1][1] + frustum[1][2] * frustum[1][2]);
  frustum[1][0] /= t;
  frustum[1][1] /= t;
  frustum[1][2] /= t;
  frustum[1][3] /= t;
  
  // Extract the BOTTOM plane
  frustum[2][0] = clip[3] + clip[1];
  frustum[2][1] = clip[7] + clip[5];
  frustum[2][2] = clip[11] + clip[9];
  frustum[2][3] = clip[15] + clip[13];
  
  // Normalize the result
  t = sqrt(frustum[2][0] * frustum[2][0] + frustum[2][1] * frustum[2][1] + frustum[2][2] * frustum[2][2]);
  frustum[2][0] /= t;
  frustum[2][1] /= t;
  frustum[2][2] /= t;
  frustum[2][3] /= t;
  
  // Extract the TOP plane
  frustum[3][0] = clip[3] - clip[1];
  frustum[3][1] = clip[7] - clip[5];
  frustum[3][2] = clip[11] - clip[9];
  frustum[3][3] = clip[15] - clip[13];
  
  // Normalize the result
  t = sqrt(frustum[3][0] * frustum[3][0] + frustum[3][1] * frustum[3][1] + frustum[3][2] * frustum[3][2]);
  frustum[3][0] /= t;
  frustum[3][1] /= t;
  frustum[3][2] /= t;
  frustum[3][3] /= t;
  
  // Extract the FAR plane
  frustum[4][0] = clip[3] - clip[2];
  frustum[4][1] = clip[7] - clip[6];
  frustum[4][2] = clip[11] - clip[10];
  frustum[4][3] = clip[15] - clip[14];
  
  // Normalize the result
  t = sqrt(frustum[4][0] * frustum[4][0] + frustum[4][1] * frustum[4][1] + frustum[4][2] * frustum[4][2]);
  frustum[4][0] /= t;
  frustum[4][1] /= t;
  frustum[4][2] /= t;
  frustum[4][3] /= t;
  
  // Extract the NEAR plane
  frustum[5][0] = clip[3] + clip[2];
  frustum[5][1] = clip[7] + clip[6];
  frustum[5][2] = clip[11] + clip[10];
  frustum[5][3] = clip[15] + clip[14];
  
  // Normalize the result
  t = sqrt(frustum[5][0] * frustum[5][0] + frustum[5][1] * frustum[5][1] + frustum[5][2] * frustum[5][2]);
  frustum[5][0] /= t;
  frustum[5][1] /= t;
  frustum[5][2] /= t;
  frustum[5][3] /= t;
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
  self.eye = GLKVector3Add(self.eye, GLKVector3MultiplyScalar(self.velocity, timeSinceLastUpdate));
  self.center = GLKVector3Add(self.center, GLKVector3MultiplyScalar(self.velocity, timeSinceLastUpdate));
  [self extractFrustum];
}

@end