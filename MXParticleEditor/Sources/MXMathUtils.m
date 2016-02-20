//
//  MXMathUtils.m
//  ProjectKyut
//
//  Created by mugx on 28/12/15.
//  Copyright © 2015 mugx. All rights reserved.
//

#import "MXMathUtils.h"

@implementation MXMathUtils

+ (GLKVector3)GLKVector3Make:(NSDictionary *)dictionary
{
  return GLKVector3Make([dictionary[@"x"] floatValue], [dictionary[@"y"] floatValue], [dictionary[@"z"] floatValue]);
}

@end
