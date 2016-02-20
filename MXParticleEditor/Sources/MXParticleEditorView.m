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
#import "NSDictionary+json.h"

@interface MXParticleEditorView()
@property IBOutlet NSTextView *textView;
@property IBOutlet NSButton *historyButton;
@property IBOutlet NSButton *saveButton;
@property IBOutlet NSButton *loadButton;

//@property IBOutlet NSButton *loadButton;
@property IBOutlet NSTextField *particleSystemName;
@property IBOutlet NSTextField *count;
@property IBOutlet NSButton *textureButton;
@property IBOutlet NSPopUpButton *modelPopupButton;

@property IBOutlet NSColorWell *colorButton;
@property IBOutlet NSTextField *fade_min;
@property IBOutlet NSTextField *fade_max;
@property IBOutlet NSTextField *scale_x;
@property IBOutlet NSTextField *scale_y;
@property IBOutlet NSTextField *scale_z;
@property IBOutlet NSTextField *velocity_x;
@property IBOutlet NSTextField *velocity_y;
@property IBOutlet NSTextField *velocity_z;
@property IBOutlet NSTextField *acceleration_x;
@property IBOutlet NSTextField *acceleration_y;
@property IBOutlet NSTextField *acceleration_z;
@property(nonatomic,strong) NSMutableDictionary *json;
@end

@implementation MXParticleEditorView

- (void)awakeFromNib
{
  [self refreshButtons];
  self.json = [@{} mutableCopy];
  self.textView.delegate = self;
  [self.colorButton addObserver:self forKeyPath:@"color" options:0 context:NULL];
  
  NSString *fileName = @"particleSystemTemplate.json";
  NSString *file = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  NSString *jsonAsString = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:nil];
  NSData *data = [jsonAsString dataUsingEncoding:NSASCIIStringEncoding];
  self.json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  self.json = [NSMutableDictionary dictionaryWithDictionary:self.json];
  [self refreshButtons];
}

- (void)dealloc
{
  [self.colorButton removeObserver:self forKeyPath:@"color"];
}

#pragma mark - Refresh

- (void)feedModelPopup
{
  [self.modelPopupButton removeAllItems];
  [self.modelPopupButton addItemWithTitle:@"sphere.3ds"];
}

- (void)refreshButtons
{
  //--- refreshing top bar buttons ---//
  self.historyButton.enabled = self.glView.scene.particleManager.particleSystemsDictionary.count > 0;
  self.saveButton.enabled = NO;
  self.loadButton.enabled = YES;
  
  //--- refreshing particle system controls ---//
  [self feedModelPopup];
  
  if (self.json != nil)
  {
    //--- name ---//
    self.particleSystemName.stringValue = self.json[@"particleSystem"];
    
    //--- count ---//
    self.count.stringValue = [NSString stringWithFormat:@"%d", [self.json[@"count"] intValue]];
    
    //--- texture ---//
    [self.textureButton setImage:[NSImage imageNamed:self.json[@"texture"]]];
    
    //--- model ---//
    [self.modelPopupButton selectItemAtIndex:0];
    
    //--- color ---//
    GLKVector3 color = GLKVectorRGB(self.json[@"color"]);
    [self.colorButton setColor:[NSColor colorWithRed:color.r green:color.g blue:color.b alpha:1.0]];
    
    //--- fade ---//
    float fade_min = [self.json[@"fade"][@"min"] floatValue];
    float fade_max = [self.json[@"fade"][@"max"] floatValue];
    self.fade_min.stringValue = [NSString stringWithFormat:@"%.2f", fade_min];
    self.fade_max.stringValue = [NSString stringWithFormat:@"%.2f", fade_max];
    
    //--- scale ---//
    GLKVector3 scale = GLKVector3(self.json[@"scale"]);
    self.scale_x.stringValue = [NSString stringWithFormat:@"%.2f", scale.x];
    self.scale_y.stringValue = [NSString stringWithFormat:@"%.2f", scale.y];
    self.scale_z.stringValue = [NSString stringWithFormat:@"%.2f", scale.z];
    
    //--- velocity ---//
    GLKVector3 velocity = GLKVector3(self.json[@"velocity"]);
    self.velocity_x.stringValue = [NSString stringWithFormat:@"%.2f", velocity.x];
    self.velocity_y.stringValue = [NSString stringWithFormat:@"%.2f", velocity.y];
    self.velocity_z.stringValue = [NSString stringWithFormat:@"%.2f", velocity.z];
    
    //--- acceleration ---//
    GLKVector3 acceleration = GLKVector3(self.json[@"acceleration"]);
    self.acceleration_x.stringValue = [NSString stringWithFormat:@"%.2f", acceleration.x];
    self.acceleration_y.stringValue = [NSString stringWithFormat:@"%.2f", acceleration.y];
    self.acceleration_z.stringValue = [NSString stringWithFormat:@"%.2f", acceleration.z];
  }
}

#pragma mark - Actions

- (IBAction)newButtonTouched:(id)sender
{
  NSString *fileName = @"particleSystemConfig.json";
  NSString *file = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
  NSString *jsonAsString = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:nil];
  NSData *data = [jsonAsString dataUsingEncoding:NSASCIIStringEncoding];
  self.json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  self.json = [NSMutableDictionary dictionaryWithDictionary:self.json];
  [self.glView loadParticleSystem:self.json];
  self.textView.string = [self.json prettyJson];
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

- (IBAction)decrCountTouched:(id)sender
{
  int count = [self.count.stringValue intValue];
  count = count - 1 > 0 ? count - 1 : count;
  self.count.stringValue = [NSString stringWithFormat:@"%d", count];
  self.textView.string = [self.json prettyJson];
}

- (IBAction)incrCountTouched:(id)sender
{
  int count = [self.count.stringValue intValue];
  count = count + 1 > 0 ? count + 1 : count;
  self.count.stringValue = [NSString stringWithFormat:@"%d", count];
  self.json[@"count"] = self.count.stringValue;
  self.textView.string = [self.json prettyJson];
}

- (IBAction)modelPopupTouched:(id)sender
{
  //  NSLog(@"My NSPopupButton selected value is: %@", [(NSPopUpButton *) sender titleOfSelectedItem]);
}

#pragma mark - Observer Stuff

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  //--- update color ---//
  self.json[@"color"][@"r"] = [NSString stringWithFormat:@"%.2f", self.colorButton.color.redComponent];
  self.json[@"color"][@"g"] = [NSString stringWithFormat:@"%.2f", self.colorButton.color.greenComponent];
  self.json[@"color"][@"b"] = [NSString stringWithFormat:@"%.2f", self.colorButton.color.blueComponent];
  
  self.textView.string = [self.json prettyJson];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
  //--- update name ----//
  self.json[@"particleSystem"] = self.particleSystemName.stringValue;
  
  //--- update velocity ---//
  self.json[@"velocity"][@"x"] = [NSString stringWithFormat:@"%.5f", [[self.velocity_x.stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
  self.json[@"velocity"][@"y"] = [NSString stringWithFormat:@"%.5f", [[self.velocity_y.stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
  self.json[@"velocity"][@"z"] = [NSString stringWithFormat:@"%.5f", [[self.velocity_z.stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
  
  //--- update acceleration ---//
  self.json[@"acceleration"][@"x"] = [NSString stringWithFormat:@"%.5f", [[self.acceleration_x.stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
  self.json[@"acceleration"][@"y"] = [NSString stringWithFormat:@"%.5f", [[self.acceleration_y.stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
  self.json[@"acceleration"][@"z"] = [NSString stringWithFormat:@"%.5f", [[self.acceleration_z.stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue]];
  
  
  self.textView.string = [self.json prettyJson];

  return YES;
}

@end