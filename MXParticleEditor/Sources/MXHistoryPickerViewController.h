//
//  MXHistoryPickerViewController.h
//  MXParticleEditor
//
//  Created by mugx on 17/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXSceneManager.h"

@interface MXHistoryPickerViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scene:(MXSceneManager *)scene;
@end
