//
//  MXEntity.m
//  ProjectKyut
//
//  Created by mugx on 17/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import "MXEntity.h"
#import "MXGameEngine.h"
#import "MXSceneManager.h"

@interface MXEntity()
@end

@implementation MXEntity

- (instancetype)init:(NSDictionary *)dictionary withScene:(MXSceneManager *)sceneManager
{
  self = [self init];
  _sceneManager = sceneManager;
  self.textureID = [[MXGameEngine sharedInstance].textureManager loadTexture:dictionary[@"texture"]];
  self.mesh = [[MXGameEngine sharedInstance].meshManager loadMesh:dictionary[@"model"]];
  self.scale = GLKVector3Make([dictionary[@"scale"] floatValue], [dictionary[@"scale"] floatValue], [dictionary[@"scale"] floatValue]);
  self.rotation = [MXMathUtils GLKVector3Make:dictionary[@"rotation"]];
  self.position = [MXMathUtils GLKVector3Make:dictionary[@"position"]];
  self.velocity = [MXMathUtils GLKVector3Make:dictionary[@"velocity"]];
  self.initialVelocity = self.velocity;
  return self;
}

- (instancetype)init
{
  self = [super init];
  _isVisible = YES;
  _alpha = 1.0f;
  _ambientMaterial = GLKVector3Make(0.6, 0.1, 0.8);
  _specularMaterial = GLKVector3Make(1.0, 1.0, 1.0);
  _diffuseMaterial = GLKVector3Make(1.0, 1.0, 1.0);
  _shininessMaterial = 20.0;
  return self;
}

#pragma mark - Collision Stuff

- (BOOL)isColliding:(MXEntity *)otherEntity
{
  GLKVector3 temp_min = self.mesh.boundingVolumeMin;
  GLKVector3 temp_max = self.mesh.boundingVolumeMax;
  
  temp_min = GLKVector3Multiply(temp_min, self.scale);
  temp_min = GLKVector3Add(temp_min, self.position);
  temp_max = GLKVector3Multiply(temp_max, self.scale);
  temp_max = GLKVector3Add(temp_max, self.position);
  
  GLKVector3 other_temp_min = otherEntity.mesh.boundingVolumeMin;
  GLKVector3 other_temp_max = otherEntity.mesh.boundingVolumeMax;
  
  other_temp_min = GLKVector3Multiply(other_temp_min, otherEntity.scale);
  other_temp_min = GLKVector3Add(other_temp_min, otherEntity.position);
  other_temp_max = GLKVector3Multiply(other_temp_max, otherEntity.scale);
  other_temp_max = GLKVector3Add(other_temp_max, otherEntity.position);
  
  bool a = GLKVector3AllGreaterThanVector3(other_temp_max, temp_min);
  bool b = GLKVector3AllGreaterThanVector3(temp_max, other_temp_min);
  return a && b;
}

- (float)offset
{
  return self.mesh.boundingVolumeRadius * self.scale.y;
}

#pragma mark - Update & Draw

// chasing camera: http://twoflygames.tumblr.com
- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
  if (!self.isVisible) return;
  
  self.velocity = GLKVector3Add(self.velocity, GLKVector3MultiplyScalar(self.acceleration, timeSinceLastUpdate));
  self.position = GLKVector3Add(self.position, GLKVector3MultiplyScalar(self.velocity, timeSinceLastUpdate));
  self.rotation = GLKVector3Add(self.rotation, self.rotationVelocity);
  
  GLKMatrix4 modelMatrix = GLKMatrix4Identity;
  modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
  modelMatrix = GLKMatrix4Translate(modelMatrix, self.centerOfCoordinateSystem.x, self.centerOfCoordinateSystem.y, self.centerOfCoordinateSystem.z);
  modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotation.x, 1.0f, 0.0f, 0.0f);
  modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotation.y, 0.0f, 1.0f, 0.0f);
  modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotation.z, 0.0f, 0.0f, 1.0f);
  modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale.x, self.scale.y, self.scale.z);
  
  GLKMatrix4 viewMatrix = [self.sceneManager.camera getViewMatrix];
  GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
  self.normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  self.modelViewProjectionMatrix = GLKMatrix4Multiply([self.sceneManager.camera getProjectionMatrix], modelViewMatrix);
}

- (void)draw
{
  if (!self.isVisible) return;
  
  //======================== SETTING UNIFORMS ========================//
  MXShader *shader = [[MXGameEngine sharedInstance].shaderManager useShader:MXShaderTypeStandard];
  [shader setUniform:@"lightPosition" floatValue:self.sceneManager.camera.eye.y];
  [shader setUniform:@"modelViewProjectionMatrix" floatMatrix4:self.modelViewProjectionMatrix.m];
  [shader setUniform:@"normalMatrix" floatMatrix3:self.normalMatrix.m];
  
  // texture
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, _textureID);
  
  // material
  [shader setUniform:@"colorMaterial" floatVector3:self.colorMaterial.v];
  [shader setUniform:@"ambientMaterial" floatVector3:self.ambientMaterial.v];
  [shader setUniform:@"specularMaterial" floatVector3:self.specularMaterial.v];
  [shader setUniform:@"diffuseMaterial" floatVector3:self.diffuseMaterial.v];
  [shader setUniform:@"shininessMaterial" floatValue:self.shininessMaterial];
  [shader setUniform:@"alpha" floatValue:self.alpha];

  // draw
  [self.mesh draw:shader];
}

@end