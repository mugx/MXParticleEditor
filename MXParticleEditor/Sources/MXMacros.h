//
//  MXMacros.h
//  ProjectKyut
//
//  Created by mugx on 12/05/15.
//  Copyright (c) 2015 mugx. All rights reserved.
//

#import "MXGameEngine.h"

#define UI_PHONE_IDIOM UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define UI_PAD_IDIOM UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE_4 (UI_PHONE_IDIOM && [[UIScreen mainScreen] bounds].size.height < 568)
#define IS_IPHONE_6 (UI_PHONE_IDIOM && [[UIScreen mainScreen] bounds].size.height > 700)
#define FORMAT(f,s) [NSString stringWithFormat:f,s]
#define SOUND_ENABLED true
#define DEBUG_ENABLED false
#define DEBUG_PARTICLES false
#define FONT_FAMILY @"ROBOTECH GP"

