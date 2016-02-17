//
//  MXParticleOpenGLView.h
//  MXParticleEditor
//
//  Created by mugx on 11/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXSceneManager.h"

@interface MXParticleOpenGLView : NSOpenGLView
- (void)startupGL;
- (void)loadParticleSystem:(id)particleSystem;
@property(readonly) MXSceneManager *scene;
@property(nonatomic,strong) NSString *currentParticleSystemKey;
@end
