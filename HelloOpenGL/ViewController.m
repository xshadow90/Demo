//
//  ViewController.m
//  HelloOpenGL
//
//  Created by Shaohan Xu on 5/25/15.
//  Copyright (c) 2015 Shaohan Xu. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"



@interface ViewController () 

@end

@implementation ViewController

@synthesize glView=_glView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glView = [[[OpenGLView alloc] initWithFrame:screenBounds] autorelease];
    [self.view addSubview:_glView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_glView release];
    [super dealloc];
}

@end
