//
//  MXShader.h
//  ProjectKyut
//
//  Created by mugx on 15/12/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MXShader : NSObject
+ (instancetype)create:(NSString *)shaderName;
- (void)setUniform:(NSString *)uniformName intValue:(GLint)intValue;
- (void)setUniform:(NSString *)uniformName floatValue:(GLfloat)floatValue;
- (void)setUniform:(NSString *)uniformName floatVector3:(GLfloat*)floatVector3;
- (void)setUniform:(NSString *)uniformName floatVector4:(GLfloat*)floatVector4;
- (void)setUniform:(NSString *)uniformName floatMatrix4:(GLfloat*)floatMatrix4;
- (void)setUniform:(NSString *)uniformName floatMatrix3:(GLfloat*)floatMatrix3;
- (GLuint)getAttributeLocation:(NSString *)attributeName;
- (void)useProgram;
@end