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
#import "MXMathUtils.h"

@interface MXParticleEditorView()
@property IBOutlet NSTextView *textView;
@property IBOutlet NSButton *historyButton;
@property IBOutlet NSButton *saveButton;
@property IBOutlet NSButton *loadButton;

//@property IBOutlet NSButton *loadButton;
@property IBOutlet NSButton *textureButton;
@property IBOutlet NSColorWell *colorButton;

@property(nonatomic,weak) id json;
@end

@implementation MXParticleEditorView

- (void)awakeFromNib
{
  [self refreshButtons];
  self.textView.delegate = self;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(nullable NSString *)replacementString
{
  //--- check if is a json ---//
  //  NSData *data = [textView.string dataUsingEncoding:NSASCIIStringEncoding];
  //  id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  //  [self.glView.scene.particleManager loadParticleSystem:result];
  return YES;
}

#pragma mark - Refresh

- (void)refreshButtons
{
  //--- refreshing top bar buttons ---//
  self.historyButton.enabled = self.glView.scene.particleManager.particleSystemsDictionary.count > 0;
  self.saveButton.enabled = NO;
  self.loadButton.enabled = YES;
  
  //--- refreshing particle system controls ---//
  [self.textureButton setImage:[NSImage imageNamed:self.json[@"texture"]]];
  GLKVector3 color = GLKVectorRGBMake(self.json[@"color"]);
  [self.colorButton setColor:[NSColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0]];
}

#pragma mark - Actions

- (IBAction)newButtonTouched:(id)sender
{
  NSString *fileName = @"particleSystemConfig.json";
  NSString *file = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  NSString *jsonAsString = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:nil];
  self.textView.string = jsonAsString;
  
  NSData *data = [jsonAsString dataUsingEncoding:NSASCIIStringEncoding];
  self.json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  [self.glView loadParticleSystem:self.json];
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

- (IBAction)cameraButtonTouched:(id)sender
{
}

#pragma mark - Particle System Controls


@end
