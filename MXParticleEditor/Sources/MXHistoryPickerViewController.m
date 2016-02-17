//
//  MXHistoryPickerViewController.m
//  MXParticleEditor
//
//  Created by mugx on 17/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import "MXHistoryPickerViewController.h"

@interface MXHistoryPickerViewController ()
@property(nonatomic,weak) MXSceneManager *scene;
@end

@implementation MXHistoryPickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scene:(MXSceneManager *)scene
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  _scene = scene;
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
  return self.scene.particleManager.particleSystemsDictionary.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  return  self.scene.particleManager.particleSystemsDictionary.allKeys[row];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  
  NSTableView *tableView = notification.object;
  NSLog(@"User has selected row %ld", (long)tableView.selectedRow);
}

@end
