//
//  MXSceneManager.h
//  ProjectKyut
//
//  Created by mugx on 03/06/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXCamera.h"
#import "MXParticleManager.h"

@interface MXSceneManager : NSObject
- (void)loadScene;
- (void)unloadScene;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
- (void)draw;
@property(readonly) MXCamera *camera;
@property(readonly) MXParticleManager *particleManager;
@end
