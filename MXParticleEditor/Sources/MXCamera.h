//
//  MXCamera.h
//  ProjectKyut
//
//  Created by mugx on 28/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class MXSceneManager;


typedef enum {
  FCRightFace = 0,
  FCLeftFace,
  FCBottomFace,
  FCTopFace,
  FCFarFace,
  FCNearFace,
  FCExtern,
  FCIntern,
  FCCount
} FrustumCollision;

@interface MXCamera : NSObject
{
@public
  double frustum[6][4];
}
- (instancetype)init:(NSDictionary *)dictionary withScene:(MXSceneManager *)sceneManager;
- (GLKMatrix4)getProjectionMatrix;
- (GLKMatrix4)getViewMatrix;
- (FrustumCollision)sphereInFrustum:(GLKVector3)position radius:(float)radius;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
@property(nonatomic,assign) GLKVector3 eye;
@property(nonatomic,assign) GLKVector3 center;
@property(nonatomic,assign) GLKVector3 velocity;
@property(nonatomic,assign) float zoomFactor;
@end
