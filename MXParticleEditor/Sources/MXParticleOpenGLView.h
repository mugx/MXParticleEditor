//
//  MXParticleOpenGLView.h
//  MXParticleEditor
//
//  Created by mugx on 11/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MXParticleOpenGLView : NSOpenGLView
- (void)startupGL;
- (void)loadParticleSystem:(id)particleSystem;
@property(nonatomic,strong) NSString *currentParticleSystemKey;
@end
