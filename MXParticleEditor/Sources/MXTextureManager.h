//
//  MXTextureManager.h
//  ProjectKyut
//
//  Created by mugx on 23/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MXTextureManager : NSObject
- (void)load;
- (void)unload;
- (GLuint)loadTexture:(NSString *)fileName;
- (GLuint)loadCubeMapTexture:(NSArray *)array;
@end
