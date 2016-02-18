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

@interface MXParticleManager()
@property(nonatomic,strong) NSMutableArray *particles;
@property(nonatomic,strong,readwrite) NSMutableDictionary *particleSystemsDictionary;
@property(nonatomic,weak) MXParticle *particleAvailable;
@property(nonatomic,weak) MXSceneManager *sceneManager;
@end

@implementation MXParticleManager

- (instancetype)initWithScene:(MXSceneManager *)sceneManager
{
  self = [super init];
  _particleSystemsDictionary = [NSMutableDictionary dictionary];
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
  [self.particleSystemsDictionary removeAllObjects];
  _particleSystemsDictionary = nil;
}

#pragma mark - Making Particle Effects
- (void)loadParticleSystem:(id)particleSystem
{
  if (particleSystem)
  {
    [self.particleSystemsDictionary setObject:particleSystem forKey:particleSystem[@"particleSystem"]];
  }
}

- (void)make:(NSString *)particleSystemKey parentEntity:(MXEntity *)parentEntity loop:(BOOL)loop
{
  int count = [self.particleSystemsDictionary[particleSystemKey][@"count"] intValue];
  while (count > 0)
  {
    MXParticle *current = self.particleAvailable;
    [current respawnFrom:parentEntity dictionary:self.particleSystemsDictionary[particleSystemKey]];
    current.autoRespawn = loop;
    self.particleAvailable = self.particleAvailable.next;
    count--;
  }
}

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
