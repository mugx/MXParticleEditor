//
//  MXParticleManager.h
//  ProjectKyut
//
//  Created by mugx on 17/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class MXSceneManager;
@class MXEntity;

typedef NS_ENUM(NSUInteger, ParticleSystem) {
  PSAfterburn,
  PSBigExplosion,
  PSMidExplosion,
  PSSmallExplosion
};
 
@interface MXParticleManager : NSObject
- (instancetype)init:(NSDictionary *)dictionary withScene:(MXSceneManager *)sceneManager;
- (void)make:(ParticleSystem)particleSystem parentEntity:(MXEntity *)parentEntity loop:(BOOL)loop;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw;
@end
   