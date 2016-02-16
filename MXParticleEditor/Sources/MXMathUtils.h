//
//  MXMathUtils.h
//  ProjectKyut
//
//  Created by mugx on 28/12/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define RAND(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)

@interface MXMathUtils : NSObject
+ (GLKVector3)GLKVector3Make:(NSDictionary *)dictionary;
+ (GLKVector3)GLKVectorRGBMake:(NSDictionary *)dictionary;
@end
