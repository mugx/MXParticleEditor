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
#define GLKVectorRGBMake(dictionary) GLKVector3Make([dictionary[@"r"] floatValue], [dictionary[@"g"] floatValue], [dictionary[@"b"] floatValue])

@interface MXMathUtils : NSObject
+ (GLKVector3)GLKVector3Make:(NSDictionary *)dictionary;
@end
