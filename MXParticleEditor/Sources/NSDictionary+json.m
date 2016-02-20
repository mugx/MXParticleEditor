//
//  NSDictionary+json.m
//  MXParticleEditor
//
//  Created by mugx on 20/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "NSDictionary+json.h"

@implementation NSDictionary (json)

- (NSString*)prettyJson
{
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions) NSJSONWritingPrettyPrinted error:&error];
  
  if (jsonData)
  {
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }
  else
  {
    NSLog(@"prettyJson: error %@", error.localizedDescription);
    return @"{}";
  }
}

@end
