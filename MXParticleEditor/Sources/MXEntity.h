//
//  MXEntity.h
//  ProjectKyut
//
//  Created by mugx on 17/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class MXSceneManager;
@class MXMesh;

@interface MXEntity : NSObject
- (instancetype)init:(NSDictionary *)dictionary withScene:(MXSceneManager *)sceneManager;
- (BOOL)isColliding:(MXEntity *)otherEntity;
- (float)offset;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw;
@property(nonatomic,weak) MXSceneManager *sceneManager;
@property(nonatomic,weak) MXMesh *mesh;
@property(nonatomic,weak) MXEntity *parentEntity;
@property(nonatomic,assign) BOOL isVisible;

@property(nonatomic,assign) GLuint textureID;
@property(nonatomic,assign) GLKVector3 position;
@property(nonatomic,assign) GLKVector3 centerOfCoordinateSystem;
@property(nonatomic,assign) GLKVector3 target;
@property(nonatomic,assign) GLKVector3 velocity;
@property(nonatomic,assign) GLKVector3 initialVelocity;
@property(nonatomic,assign) GLKVector3 acceleration;
@property(nonatomic,assign) GLKVector3 rotation;
@property(nonatomic,assign) GLKVector3 rotationVelocity;
@property(nonatomic,assign) GLKVector3 scale;
@property(nonatomic,assign) GLKMatrix4 projectionMatrix;
@property(nonatomic,assign) GLKMatrix4 modelViewProjectionMatrix;
@property(nonatomic,assign) GLKMatrix3 normalMatrix;

//--- material ---//
@property(nonatomic,assign) GLKVector3 colorMaterial;
@property(nonatomic,assign) GLKVector3 ambientMaterial;
@property(nonatomic,assign) GLKVector3 specularMaterial;
@property(nonatomic,assign) GLKVector3 diffuseMaterial;
@property(nonatomic,assign) float shininessMaterial;
@property(nonatomic,assign) float alpha;
@end