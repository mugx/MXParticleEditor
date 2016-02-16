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

@interface MXParticleManager : NSObject
- (instancetype)initWithScene:(MXSceneManager *)sceneManager;
- (void)loadParticleSystem:(id)particleSystem;
- (void)make:(NSString *)particleSystemKey parentEntity:(MXEntity *)parentEntity loop:(BOOL)loop;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw;
@end
   