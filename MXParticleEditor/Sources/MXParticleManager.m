//
//  MXParticleManager.m
//  ProjectKyut
//
//  Created by mugx on 17/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXParticleManager.h"
#import "MXParticle.h"

#define MAX_PARTICLES 200
#define kExplosionSystem @"explosionSystem"
#define kAfterburnSystem @"afterburnSystem"

@interface MXParticleManager()
@property(nonatomic,strong) NSMutableArray *particles;
@property(nonatomic,strong) NSDictionary *particleSystemsDictionary;
@property(nonatomic,weak) MXParticle *particleAvailable;
@property(nonatomic,weak) MXSceneManager *sceneManager;
@end

@implementation MXParticleManager

- (instancetype)init:(NSDictionary *)dictionary withScene:(MXSceneManager *)sceneManager
{
  self = [super init];
  _particleSystemsDictionary = dictionary[@"particleManager"];
  _sceneManager = sceneManager;
  _particles = [NSMutableArray array];
  
  for (int i = 0;i < MAX_PARTICLES;++i)
  {
    MXParticle *particle = [[MXParticle alloc] init];
    particle.sceneManager = _sceneManager;
    [self.particles addObject:particle];
  }
  
  for (int i = 0;i < MAX_PARTICLES - 1;++i)
  {
    MXParticle *particle = self.particles[i];
    particle.next = self.particles[i + 1];
  }
  self.particleAvailable = self.particles.firstObject;
  return self;
}

- (void)dealloc
{
  [self.particles removeAllObjects];
  _particles = nil;
  _particleSystemsDictionary = nil;
}

#pragma mark - Making Particle Effects

- (void)make:(ParticleSystem)particleSystem parentEntity:(MXEntity *)parentEntity loop:(BOOL)loop
{
  int count = particleSystem == PSBigExplosion ? 30 : particleSystem == PSMidExplosion ? 5 : 1;
  while (count > 0)
  {
    MXParticle *current = self.particleAvailable;
    [current respawnFrom:parentEntity dictionary:self.particleSystemsDictionary[kExplosionSystem]];
    current.autoRespawn = loop;
    self.particleAvailable = self.particleAvailable.next;
    count--;
  }
}
/*
- (void)makeAfterBurn:(MXEntity *)parentEntity
{
  int count = 30;
  while (count > 0)
  {
    MXParticle *current = self.particleAvailable;
    [current respawnFrom:parentEntity dictionary:self.particleSystemsDictionary[kAfterburnSystem]];
    [current randomizePosition];
    current.autoRespawn = YES;
    self.particleAvailable = self.particleAvailable.next;
    count--;
  }
}
*/
#pragma mark - Update & Draw
- (void)setAvailableParticle:(MXParticle *)particle
{
  particle.next = self.particleAvailable;
  self.particleAvailable = particle;
}

- (void)update:(NSTimeInterval)timeSinceLastUpdate
{
  for (MXParticle *particle in self.particles)
  {
    if (particle.isVisible)
    {
      [particle updateCenterOfCoordinateSystem:particle.parentEntity];
      [particle update:timeSinceLastUpdate];
    }
    else if (particle.autoRespawn)
    {
      [particle respawnFrom:particle.parentEntity dictionary:particle.dictionary];
    }
    else
    {
      [self setAvailableParticle:particle];
    }
  }
}

- (void)draw
{
  for (MXParticle *particle in self.particles)
  {
    [particle draw];
  }
}

@end
