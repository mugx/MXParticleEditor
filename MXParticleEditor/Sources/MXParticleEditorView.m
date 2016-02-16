//
//  MXParticleEditorView.m
//  MXParticleEditor
//
//  Created by mugx on 12/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "MXParticleEditorView.h"
#import "MXUtils.h"

@interface MXParticleEditorView()
@property IBOutlet NSTextView *textView;
@property(nonatomic,strong) NSString *json;
@end

@implementation MXParticleEditorView

- (void)awakeFromNib
{
  //  self.delegate = self;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(nullable NSString *)replacementString
{
  //--- check if is a json ---//
  //  NSData *data = [textView.string dataUsingEncoding:NSASCIIStringEncoding];
  //  id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  return YES;
}

- (IBAction)newParticleSystemTouched:(id)sender
{
  NSString *fileName = @"particleSystemConfig.json";
  NSString *file = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  NSString *jsonAsString = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:nil];
  self.textView.string = jsonAsString;
  
  NSData *data = [jsonAsString dataUsingEncoding:NSASCIIStringEncoding];
  id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  [self.glView loadParticleSystem:json];
}

@end
