//
//  ViewController.h
//  HelloOpenGL
//
//  Created by Shaohan Xu on 5/25/15.
//  Copyright (c) 2015 Shaohan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface ViewController : UIViewController {
    OpenGLView* _glView;
}

@property (nonatomic, retain) IBOutlet OpenGLView *glView;


@end

