//
//  MXMesh.m
//  ProjectKyut
//
//  Created by mugx on 23/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXMesh.h"
#import "MXGameEngine.h"

@interface MXMesh()
@property(nonatomic,assign) GLuint vertexArray;
@property(nonatomic,assign) GLuint vertexBuffer;
@property(nonatomic,assign) GLuint indexBuffer;
@property(nonatomic,assign) GLuint vertexBufferBV;
@property(nonatomic,assign) GLuint textureBuffer;
@property(nonatomic,assign) GLuint normalBuffer;
@property(nonatomic,assign) GLuint positionSlot;
@property(nonatomic,assign) GLuint textureCoordSlot;
@property(nonatomic,assign) GLuint normalSlot;
@end

@implementation MXMesh

- (void)dealloc
{
  free(vertex);
  free(normal);
  free(mapcoord);
  free(polygon);

  glDeleteVertexArrays(1, &_vertexArray);
  glDeleteBuffers(1, &_vertexBuffer);
  glDeleteBuffers(1, &_indexBuffer);
  glDeleteBuffers(1, &_vertexBufferBV);
  glDeleteBuffers(1, &_normalBuffer);
  glDeleteBuffers(1, &_textureBuffer);
}

- (instancetype)init
{
  self = [super init];
  
  return self;
}

- (void)setup
{
  glGenVertexArrays(1, &_vertexArray);
  glBindVertexArray(self.vertexArray);
  
  //================ Generating VERTEX BUFFER ====================//
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData (GL_ARRAY_BUFFER, sizeof(vertex_type) * self->vertices_qty, &self->vertex[0], GL_STATIC_DRAW);
  
  //================ Generating INDEX BUFFER ====================//
  glGenBuffers(1, &_indexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(polygon_type) * self->polygons_qty, &self->polygon[0], GL_STATIC_DRAW);
  
  //================ Generating NORMALS BUFFER ====================//
  glGenBuffers(1, &_normalBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_type) * self->vertices_qty, &self->normal[0], GL_STATIC_DRAW);
  
  //================ Generating TEXTURE BUFFER ====================//
  glGenBuffers(1, &_textureBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _textureBuffer);
  glBufferData (GL_ARRAY_BUFFER, sizeof(mapcoord_type) * self->vertices_qty, &self->mapcoord[0], GL_STATIC_DRAW);
  
  //=============== Begin: bounding volume stuff ====================//
  const GLfloat boundingVolumeVertices[] =
  {
    self.boundingVolumeMin.x, self.boundingVolumeMin.y, self.boundingVolumeMin.z,
    self.boundingVolumeMin.x, self.boundingVolumeMax.y, self.boundingVolumeMin.z,
    self.boundingVolumeMax.x, self.boundingVolumeMax.y, self.boundingVolumeMin.z,
    self.boundingVolumeMax.x, self.boundingVolumeMin.y, self.boundingVolumeMin.z,
    
    self.boundingVolumeMin.x, self.boundingVolumeMin.y, self.boundingVolumeMax.z,
    self.boundingVolumeMin.x, self.boundingVolumeMax.y, self.boundingVolumeMax.z,
    self.boundingVolumeMax.x, self.boundingVolumeMax.y, self.boundingVolumeMax.z,
    self.boundingVolumeMax.x, self.boundingVolumeMin.y, self.boundingVolumeMax.z,
    
    self.boundingVolumeMax.x, self.boundingVolumeMax.y, self.boundingVolumeMin.z,
    self.boundingVolumeMax.x, self.boundingVolumeMax.y, self.boundingVolumeMax.z,
    self.boundingVolumeMin.x, self.boundingVolumeMax.y, self.boundingVolumeMax.z,
    self.boundingVolumeMin.x, self.boundingVolumeMax.y, self.boundingVolumeMin.z,
    
    self.boundingVolumeMax.x, self.boundingVolumeMin.y, self.boundingVolumeMax.z,
    self.boundingVolumeMin.x, self.boundingVolumeMin.y, self.boundingVolumeMax.z,
    self.boundingVolumeMin.x, self.boundingVolumeMin.y, self.boundingVolumeMin.z,
    self.boundingVolumeMax.x, self.boundingVolumeMin.y, self.boundingVolumeMin.z,
  };
  
  glGenBuffers(1, &_vertexBufferBV);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferBV);
  glBufferData(GL_ARRAY_BUFFER, sizeof(boundingVolumeVertices), boundingVolumeVertices, GL_STATIC_DRAW);
  //=============== End: bounding volume stuff ====================//
  
  glBindVertexArray(0);
}

- (void)draw:(MXShader *)shader
{
  //======================== BINDING BUFFERS ========================//
  glBindVertexArray(self.vertexArray);
  glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indexBuffer);
  
  // VERTEX BUFFER
  self.positionSlot = [shader getAttributeLocation:@"positionAttribute"];
  glEnableVertexAttribArray(self.positionSlot);
  glVertexAttribPointer(self.positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
  
  // NORMAL BUFFER
  self.normalSlot = [shader getAttributeLocation:@"normalAttribute"];
  glEnableVertexAttribArray(self.normalSlot);
  glBindBuffer(GL_ARRAY_BUFFER, self.normalBuffer);
  glVertexAttribPointer(self.normalSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
  
  // TEXTURE BUFFER
  self.textureCoordSlot = [shader getAttributeLocation:@"textureCoordinatesAttribute"];
  glEnableVertexAttribArray(self.textureCoordSlot);
  glBindBuffer(GL_ARRAY_BUFFER, self.textureBuffer);
  glVertexAttribPointer(self.textureCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, 0);
  
  glDrawElements(GL_TRIANGLES, self->polygons_qty * 3, GL_UNSIGNED_SHORT, 0);
  glDisableVertexAttribArray(self.textureCoordSlot);
  glDisableVertexAttribArray(self.normalSlot);
  
  // Bouding volume draw
  if (self.debugBoundingVolume)
  {
    glEnableVertexAttribArray(_positionSlot);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferBV);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 40);
  }
  glDisableVertexAttribArray(_positionSlot);
}

@end