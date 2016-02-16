//
//  MeshManager.h
//  ProjectKyut
//
//  Created by mugx on 09/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXMesh.h"
 
@interface MXMeshManager : NSObject
- (void)load;
- (void)unload;
- (MXMesh *)loadMesh:(NSString *)fileName;
@end
