//
//  MeshManager.m
//  ProjectKyut
//
//  Created by mugx on 09/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
// http://cse.csusb.edu/tongyu/courses/cs520/notes/3DSINFO.TXT

#import "MXMeshManager.h"

@interface MXMeshManager()
@property(nonatomic,strong) NSMutableDictionary *meshDictionary;
@end

@implementation MXMeshManager

#pragma mark - Manager setup

- (void)load
{
  self.meshDictionary = [[NSMutableDictionary alloc] init];
}

- (void)unload
{
  NSLog(@"MXMeshManager::unload");
  [self.meshDictionary removeAllObjects];
  self.meshDictionary = nil;
}

#pragma mark - Public functions

- (MXMesh *)loadMesh:(NSString *)fileName
{
  if (!fileName || fileName.length == 0)
  {
    return nil;
  }
  
  if (self.meshDictionary[fileName])
  {
    return self.meshDictionary[fileName];
  }
  NSString* path = [[NSBundle mainBundle] pathForResource:[[fileName lastPathComponent] stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  
  FILE* file = fopen([path UTF8String],"r");
  size_t pos = ftell(file);
  fseek(file, 0, SEEK_END);    // Go to end
  size_t file_length = ftell(file); // read the position which is the size
  fseek(file, pos, SEEK_SET);  // restore original position
  
  MXMesh *mesh = [[MXMesh alloc] init];
  
  while (ftell (file) < file_length) // file scanning
  {
    //----------------------------------------//
    unsigned short idChunk = 0;
    unsigned int lengthChunk = 0;
    //----------------------------------------//
    
    fread (&idChunk, 2, 1, file); // reading chunk header
    fread (&lengthChunk, 4, 1, file); // reading chunk lenght
    
    switch (idChunk)
    {
        // Chunk #    : 0x4D4D
        // Name       : Main chunk
        // Level      : 0
        // Size       : 0 + sub-chunks
        // Father     : none
      case 0x4d4d:
        break;
        // Chunk #    : 0x3D3D
        // Name       : 3D Editor chunk
        // Level      : 1
        // Size       : 0 + sub-chunks
        // Father     : 0x4D4D (Main chunk)
      case 0x3d3d:
        break;
        // Chunk #    : 0x4000
        // Name       : OBJECT BLOCK
        // Level      : 2
        // Size       : varying + sub-chunks
        // Father     : 0x3D3D (3D Editor chunk)
        // Format     :
        //              strz     Object name
      case 0x4000:
      {
        int i = 0;
        char charTemp; // char variabile
        do
        {
          fread (&charTemp, 1, 1, file);
          ++i;
        } while(charTemp != '\0' && i < 20);
        break;
      }
        // Chunk #    : 0x4100
        // Name       : Triangular Mesh
        // Level      : 3
        // Size       : 0 + sub-chunks
        // Father     : 0x4000 (Object block)
      case 0x4100:
        break;
        
        // Chunk #    : 0x4110
        // Name       : Vertices list
        // Level      : 4
        // Size       : varying
        // Father     : 0x4100 (Triangular mesh)
        // Format     :
        //              word     Number of vertices
        // Then, for each vertex
        //              vector   Position
      case 0x4110:
      {
        fread (&mesh->vertices_qty, sizeof (unsigned short), 1, file);
        mesh->vertex = malloc(sizeof(vertex_type) * mesh->vertices_qty);
        for (int i = 0; i < mesh->vertices_qty;++i)
        {
          fread (&mesh->vertex[i].x, sizeof(float), 1, file);
          fread (&mesh->vertex[i].y, sizeof(float), 1, file);
          fread (&mesh->vertex[i].z, sizeof(float), 1, file);
        }
        break;
      }
        //  Chunk #    : 0x4120
        //  Name       : Faces description
        //  Level      : 4
        //  Size       : varying + sub-chunks
        //  Father     : 0x4100 (Triangular mesh)
        //  Format     :
        //               word     Number of faces
        //  Then, for each face:
        //               word     Vertex for corner A (number reference)
        //               word     Vertex for corner B (number reference)
        //               word     Vertex for corner C (number reference)
        //               word     Face flag
        //                        * bit 0 : CA visible
        //                        * bit 1 : BC visible
        //                        * bit 2 : AB visible
        //  After datas, parse sub-chunks (0x4130, 0x4150).
      case 0x4120:
      {
        unsigned short l_face_flags;
        fread (&mesh->polygons_qty, sizeof (unsigned short), 1, file);
        mesh->polygon = malloc(sizeof(polygon_type) * mesh->polygons_qty);
        for (int i = 0; i < mesh->polygons_qty;++i)
        {
          fread (&mesh->polygon[i].a, sizeof (unsigned short), 1, file);
          fread (&mesh->polygon[i].b, sizeof (unsigned short), 1, file);
          fread (&mesh->polygon[i].c, sizeof (unsigned short), 1, file);
          fread (&l_face_flags, sizeof (unsigned short), 1, file);
        }
        break;
      }
        // Chunk #    : 0x4130
        // Name       : Faces material list
        // Level      : 5
        // Size       : varying
        // Father     : 0x4120 (Faces description)
        // Format     :
        //              strz     Material name
        //              word     Number of entries
        // Then, for each entry:
        //              word     Face assigned to this material (number reference)
        // I think the faces of one object can have different materials. Therefore, this chunk can be present more than once.
      case 0x4130:
        break;
        
        // Chunk #    : 0x4140
        // Name       : Mapping coordinates list for each vertex
        // Level      : 4
        // Size       : varying
        // Father     : 0x4100 (Triangular mesh)
        // Format     :
        //              word     Number of vertices
        //  Then, for each vertex
        //              float    U coordinate
        //              float    V coordinate
      case 0x4140:
      {
        fread (&mesh->mapcoord_qty, sizeof (unsigned short), 1, file);
        mesh->mapcoord = malloc(sizeof(mapcoord_type) * mesh->mapcoord_qty);
        for (int i = 0; i < mesh->mapcoord_qty;++i)
        {
          fread (&mesh->mapcoord[i].u, sizeof (float), 1, file);
          fread (&mesh->mapcoord[i].v, sizeof (float), 1, file);
        }
        break;
      }
        // Not used Chunks: skipping to the next one using the chunk lenght
      default:
        fseek(file, lengthChunk - 6, SEEK_CUR);
    }
  }
  fclose (file);
  
  //--- extracting the mesh ---//
  [self makeNormals:mesh];
  [self extractBoundingVolume:mesh];
  [mesh setup];
  [self.meshDictionary setObject:mesh forKey:fileName];
  return mesh;
}

#pragma mark - Private functions

- (void)makeNormals:(MXMesh *)mesh
{
  GLKVector3 l_vect1,l_vect2,l_vect3,l_vect_b1,l_vect_b2,l_normal;  //Some local vectors
  int l_connections_qty[MAX_VERTICES]; //Number of poligons around each vertex
  
  // Resetting vertices' normals...
  mesh->normal = malloc(sizeof(vertex_type) * mesh->vertices_qty);
  for (int i=0; i<mesh->vertices_qty; i++)
  {
    mesh->normal[i].x = 0.0;
    mesh->normal[i].y = 0.0;
    mesh->normal[i].z = 0.0;
    l_connections_qty[i] = 0;
  }
  
  for (int i=0; i<mesh->polygons_qty; i++)
  {
    l_vect1.x = mesh->vertex[mesh->polygon[i].a].x;
    l_vect1.y = mesh->vertex[mesh->polygon[i].a].y;
    l_vect1.z = mesh->vertex[mesh->polygon[i].a].z;
    l_vect2.x = mesh->vertex[mesh->polygon[i].b].x;
    l_vect2.y = mesh->vertex[mesh->polygon[i].b].y;
    l_vect2.z = mesh->vertex[mesh->polygon[i].b].z;
    l_vect3.x = mesh->vertex[mesh->polygon[i].c].x;
    l_vect3.y = mesh->vertex[mesh->polygon[i].c].y;
    l_vect3.z = mesh->vertex[mesh->polygon[i].c].z;
    
    // Polygon normal calculation
    l_vect_b1 = GLKVector3Normalize(GLKVector3Subtract(l_vect1, l_vect2));
    l_vect_b2 = GLKVector3Normalize(GLKVector3Subtract(l_vect1, l_vect3));
    l_normal = GLKVector3CrossProduct(l_vect_b1, l_vect_b2);
    l_normal = GLKVector3Normalize(l_normal);
    
    l_connections_qty[mesh->polygon[i].a] += 1; // For each vertex shared by this polygon we increase the number of connections
    l_connections_qty[mesh->polygon[i].b] += 1;
    l_connections_qty[mesh->polygon[i].c] += 1;
    
    mesh->normal[mesh->polygon[i].a].x += l_normal.x; // For each vertex shared by this polygon we add the polygon normal
    mesh->normal[mesh->polygon[i].a].y += l_normal.y;
    mesh->normal[mesh->polygon[i].a].z += l_normal.z;
    mesh->normal[mesh->polygon[i].b].x += l_normal.x;
    mesh->normal[mesh->polygon[i].b].y += l_normal.y;
    mesh->normal[mesh->polygon[i].b].z += l_normal.z;
    mesh->normal[mesh->polygon[i].c].x += l_normal.x;
    mesh->normal[mesh->polygon[i].c].y += l_normal.y;
    mesh->normal[mesh->polygon[i].c].z += l_normal.z;
  }
  
  for (int i=0; i<mesh->vertices_qty; i++)
  {
    if (l_connections_qty[i]>0)
    {
      mesh->normal[i].x /= l_connections_qty[i]; // Let's now average the polygons' normals to obtain the vertex normal!
      mesh->normal[i].y /= l_connections_qty[i];
      mesh->normal[i].z /= l_connections_qty[i];
    }
  }
}

- (void)extractBoundingVolume:(MXMesh *)mesh
{
  for (int i = 0;i < mesh->polygons_qty;++i)
  {
    polygon_type triangle = mesh->polygon[i];
    vertex_type firstVertex = mesh->vertex[triangle.a];
    vertex_type secondVertex = mesh->vertex[triangle.b];
    vertex_type thirdVertex = mesh->vertex[triangle.c];
    mesh.boundingVolumeMin = GLKVector3Make(firstVertex.x <= mesh.boundingVolumeMin.x ? firstVertex.x : mesh.boundingVolumeMin.x,
                                            firstVertex.y <= mesh.boundingVolumeMin.y ? firstVertex.y : mesh.boundingVolumeMin.y,
                                            firstVertex.z <= mesh.boundingVolumeMin.z ? firstVertex.z : mesh.boundingVolumeMin.z);
    mesh.boundingVolumeMin = GLKVector3Make(secondVertex.x <= mesh.boundingVolumeMin.x ? secondVertex.x : mesh.boundingVolumeMin.x,
                                            secondVertex.y <= mesh.boundingVolumeMin.y ? secondVertex.y : mesh.boundingVolumeMin.y,
                                            secondVertex.z <= mesh.boundingVolumeMin.z ? secondVertex.z : mesh.boundingVolumeMin.z);
    mesh.boundingVolumeMin = GLKVector3Make(thirdVertex.x <= mesh.boundingVolumeMin.x ? thirdVertex.x : mesh.boundingVolumeMin.x,
                                            thirdVertex.y <= mesh.boundingVolumeMin.y ? thirdVertex.y : mesh.boundingVolumeMin.y,
                                            thirdVertex.z <= mesh.boundingVolumeMin.z ? thirdVertex.z : mesh.boundingVolumeMin.z);
    
    mesh.boundingVolumeMax = GLKVector3Make(firstVertex.x >= mesh.boundingVolumeMax.x ? firstVertex.x : mesh.boundingVolumeMax.x,
                                            firstVertex.y >= mesh.boundingVolumeMax.y ? firstVertex.y : mesh.boundingVolumeMax.y,
                                            firstVertex.z >= mesh.boundingVolumeMax.z ? firstVertex.z : mesh.boundingVolumeMax.z);
    mesh.boundingVolumeMax = GLKVector3Make(secondVertex.x >= mesh.boundingVolumeMax.x ? secondVertex.x : mesh.boundingVolumeMax.x,
                                            secondVertex.y >= mesh.boundingVolumeMax.y ? secondVertex.y : mesh.boundingVolumeMax.y,
                                            secondVertex.z >= mesh.boundingVolumeMax.z ? secondVertex.z : mesh.boundingVolumeMax.z);
    mesh.boundingVolumeMax = GLKVector3Make(thirdVertex.x >= mesh.boundingVolumeMax.x ? thirdVertex.x : mesh.boundingVolumeMax.x,
                                            thirdVertex.y >= mesh.boundingVolumeMax.y ? thirdVertex.y : mesh.boundingVolumeMax.y,
                                            thirdVertex.z >= mesh.boundingVolumeMax.z ? thirdVertex.z : mesh.boundingVolumeMax.z);
  }
  mesh.boundingVolumeCenter = GLKVector3DivideScalar(GLKVector3Add(mesh.boundingVolumeMin, mesh.boundingVolumeMax), 2.0);
  
  float maxDistance = 0;
  float currentDistance = 0;
  for (int i = 0;i < mesh->vertices_qty;++i)
  {
    GLKVector3 vertex = GLKVector3Make(mesh->vertex[i].x, mesh->vertex[i].y, mesh->vertex[i].z);
    currentDistance = GLKVector3Distance(mesh.boundingVolumeCenter, vertex);
    if (currentDistance >= maxDistance)
    {
      maxDistance = currentDistance;
    }
  }
  mesh.boundingVolumeRadius = maxDistance;
}

@end