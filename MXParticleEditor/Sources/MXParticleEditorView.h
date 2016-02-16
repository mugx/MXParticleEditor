//
//  MXTextView.h
//  MXParticleEditor
//
//  Created by mugx on 12/02/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXParticleOpenGLView.h"

@interface MXParticleEditorView : NSView
@property(nonatomic,weak) MXParticleOpenGLView *glView;
@end
