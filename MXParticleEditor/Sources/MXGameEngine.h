//
//  MXGameEngine.h
//  ProjectKyut
//
//  Created by mugx on 15/01/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXShaderManager.h"
#import "MXTextureManager.h"
#import "MXMeshManager.h"
#import "MXMathUtils.h"
#import "MXUtils.h"

@interface MXGameEngine : NSObject
+ (instancetype)sharedInstance;
- (void)load;
- (void)unload;
@property(readonly) MXShaderManager *shaderManager;
@property(readonly) MXTextureManager *textureManager;
@property(readonly) MXMeshManager *meshManager;
@end
