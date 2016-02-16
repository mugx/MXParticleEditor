//
//  ShaderManager.h
//  ProjectKyut
//
//  Created by mugx on 10/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "MXShader.h"

typedef NS_ENUM(NSUInteger, MXShaderType) {
  MXShaderTypeStandard
};

@interface MXShaderManager : NSObject
- (void)load;
- (void)unload;
- (MXShader *)useShader:(MXShaderType)type;
@end
