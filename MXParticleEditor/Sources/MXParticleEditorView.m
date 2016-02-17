//
//  MXParticleEditorView.m
//  MXParticleEditor
//
//  Created by mugx on 12/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "MXParticleEditorView.h"
#import "MXHistoryPickerViewController.h"
#import "MXUtils.h"

@interface MXParticleEditorView()
@property IBOutlet NSTextView *textView;
@property IBOutlet NSButton *historyButton;
@property IBOutlet NSButton *saveButton;
@property IBOutlet NSButton *loadButton;
@property(nonatomic,strong) NSString *json;
@end

@implementation MXParticleEditorView

- (void)awakeFromNib
{
  [self refreshButtons];
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(nullable NSString *)replacementString
{
  //--- check if is a json ---//
  //  NSData *data = [textView.string dataUsingEncoding:NSASCIIStringEncoding];
  //  id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  return YES;
}

#pragma mark - Refresh

- (void)refreshButtons
{
  self.historyButton.enabled = self.glView.scene.particleManager.particleSystemsDictionary.count > 0;
  self.saveButton.enabled = NO;
  self.loadButton.enabled = YES;
}

#pragma mark - Actions

- (IBAction)newButtonTouched:(id)sender
{
  NSString *fileName = @"particleSystemConfig.json";
  NSString *file = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  NSString *jsonAsString = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:nil];
  self.textView.string = jsonAsString;
  
  NSData *data = [jsonAsString dataUsingEncoding:NSASCIIStringEncoding];
  id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  [self.glView loadParticleSystem:json];
  [self refreshButtons];
}

- (IBAction)historyButtonTouched:(id)sender
{
  MXHistoryPickerViewController *controller = [[MXHistoryPickerViewController alloc] initWithNibName:nil bundle:nil scene:self.glView.scene];
  NSPopover *popover = [[NSPopover alloc] init];
  [popover setContentSize:NSMakeSize(200.0f, 200.0f)];
  [popover setContentViewController:controller];
  [popover setAnimates:YES];
  [popover setBehavior:NSPopoverBehaviorTransient];
  [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
}

- (IBAction)saveButtonTouched:(id)sender
{
}

- (IBAction)loadButtonTouched:(id)sender
{
}

@end
