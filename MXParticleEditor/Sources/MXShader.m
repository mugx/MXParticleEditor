//
//  MXShader.m
//  ProjectKyut
//
//  Created by mugx on 15/12/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXShader.h"

@interface MXShader()
@property(nonatomic,assign) GLuint program;
@end

@implementation MXShader

+ (instancetype)create:(NSString *)shaderName
{
  MXShader *shader = [[MXShader alloc] init];
  
  //--- load vertex shader ---//
  NSString *path = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"vsh"];
  const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] UTF8String];
  GLuint vertexShaderId = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(vertexShaderId, 1, &source, NULL);
  glCompileShader(vertexShaderId);
  
  //--- load fragment shader ---//
  path = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"fsh"];
  source = (GLchar *)[[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] UTF8String];
  GLuint fragmentShaderId = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(fragmentShaderId, 1, &source, NULL);
  glCompileShader(fragmentShaderId);

  //-- attaching ---//
  shader.program = glCreateProgram();
  glAttachShader(shader.program, vertexShaderId);
  glAttachShader(shader.program, fragmentShaderId);
  glLinkProgram(shader.program);

  GLint status;
  glGetProgramiv(shader.program, GL_LINK_STATUS, &status);
  
  if (!status)
  {
    GLchar error[1024];
    glGetShaderInfoLog(vertexShaderId, 1024, NULL, error);
    NSLog(@"%@", [NSString stringWithUTF8String:error]);

    glGetShaderInfoLog(fragmentShaderId, 1024, NULL, error);
    NSLog(@"%@", [NSString stringWithUTF8String:error]);
  }
  
  if (vertexShaderId)
  {
    glDetachShader(shader.program, vertexShaderId);
    glDeleteShader(vertexShaderId);
  }
  
  if (fragmentShaderId)
  {
    glDetachShader(shader.program, fragmentShaderId);
    glDeleteShader(fragmentShaderId);
  }

//  return status ? shader : nil;
  return shader;
}

- (void)dealloc
{
  glDeleteProgram(self.program);
}

- (void)setUniform:(NSString *)uniformName intValue:(GLint)intValue
{
  glUniform1i(glGetUniformLocation(self.program, uniformName.UTF8String), intValue);
}

- (void)setUniform:(NSString *)uniformName floatValue:(GLfloat)floatValue
{
  glUniform1f(glGetUniformLocation(self.program, uniformName.UTF8String), floatValue);
}

- (void)setUniform:(NSString *)uniformName floatVector3:(GLfloat*)floatVector3
{
  glUniform3fv(glGetUniformLocation(self.program, uniformName.UTF8String), 1, floatVector3);
}

- (void)setUniform:(NSString *)uniformName floatVector4:(GLfloat*)floatVector4
{
  glUniform4fv(glGetUniformLocation(self.program, uniformName.UTF8String), 1, floatVector4);
}

- (void)setUniform:(NSString *)uniformName floatMatrix3:(GLfloat*)floatMatrix3
{
  glUniformMatrix3fv(glGetUniformLocation(self.program, uniformName.UTF8String), 1, false, floatMatrix3);
}

- (void)setUniform:(NSString *)uniformName floatMatrix4:(GLfloat*)floatMatrix4
{
  glUniformMatrix4fv(glGetUniformLocation(self.program, uniformName.UTF8String), 1, false, floatMatrix4);
}

- (GLuint)getAttributeLocation:(NSString *)attributeName
{
  return glGetAttribLocation(self.program, attributeName.UTF8String);
}

- (void)useProgram
{
  glUseProgram(self.program);
}

@end
