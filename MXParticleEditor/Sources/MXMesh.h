//
//  MXMesh.h
//  ProjectKyut
//
//  Created by mugx on 23/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "MXShader.h"

#define MAX_VERTICES 8000 // Max number of vertices (for each object)
#define MAX_POLYGONS 8000 // Max number of polygons (for each object)

typedef struct{
  float x,y,z;
}vertex_type;

// The polygon (triangle), 3 numbers that aim 3 vertices
typedef struct{
  unsigned short a,b,c;
}polygon_type;

// The mapcoord type, 2 texture coordinates for each vertex
typedef struct{
  float u,v;
}mapcoord_type;

@interface MXMesh : NSObject
{
  @public
  int vertices_qty;
  int polygons_qty;
  int mapcoord_qty;
  
  vertex_type *vertex;
  vertex_type *normal;
  mapcoord_type *mapcoord;
  polygon_type *polygon;
}
- (void)setup;
- (void)draw:(MXShader *)shader;
@property(nonatomic,assign) GLKVector3 boundingVolumeMin;
@property(nonatomic,assign) GLKVector3 boundingVolumeMax;
@property(nonatomic,assign) GLKVector3 boundingVolumeCenter;
@property(nonatomic,assign) float boundingVolumeRadius;
@property(nonatomic,assign) BOOL debugBoundingVolume;
@end