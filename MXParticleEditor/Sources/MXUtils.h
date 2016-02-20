//
//  MXUtils.h
//  ProjectKyut
//
//  Created by mugx on 15/11/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define RAND(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)
#define GLKVectorRGB(dictionary) GLKVector3Make([dictionary[@"r"] floatValue], [dictionary[@"g"] floatValue], [dictionary[@"b"] floatValue])
#define GLKVector3(dictionary) GLKVector3Make([dictionary[@"x"] floatValue], [dictionary[@"y"] floatValue], [dictionary[@"z"] floatValue])

@interface MXUtils : NSObject
+ (id)jsonFromFile:(NSString *)fileName;
@end
