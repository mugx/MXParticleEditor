//
//  MXTextView.m
//  MXParticleEditor
//
//  Created by mugx on 12/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "MXTextView.h"

@interface MXTextView()
@property(nonatomic,strong) NSString *json;
@end

@implementation MXTextView

- (void)awakeFromNib
{
  self.delegate = self;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(nullable NSString *)replacementString
{
  //--- check if is a json ---//
//  NSData *data = [textView.string dataUsingEncoding:NSASCIIStringEncoding];
//  id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  return YES;
}

@end
