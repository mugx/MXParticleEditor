//
//  MXParticle.h
//  ProjectKyut
//
//  Created by mugx on 17/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXEntity.h"

@class MXParticleManager;

@interface MXParticle : MXEntity
- (instancetype)init;
- (void)randomizePosition;
- (void)respawnFrom:(MXEntity *)parentEntity dictionary:(NSDictionary *)dictionary;
- (void)updateCenterOfCoordinateSystem:(MXEntity *)parentEntity;
- (void)update:(NSTimeInterval)timeSinceLastUpdate;
@property(nonatomic,weak) NSDictionary *dictionary;
@property(nonatomic,weak) MXParticle *next;
@property(nonatomic,assign) BOOL autoRespawn;
@property(nonatomic,assign) float fade;
@property(nonatomic,assign) GLKVector3 centerOfCoordinateSystemOffset;
@end
    