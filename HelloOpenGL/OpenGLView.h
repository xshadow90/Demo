//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Shaohan Xu on 5/25/15.
//  Copyright (c) 2015 Shaohan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface OpenGLView : GLKView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    float _currentRotation;
    GLuint _depthRenderBuffer;
    GLuint _floorTexture;
    GLuint _fishTexture;
    GLuint _texCoordSlot;
    GLuint _textureUniform;
}

@end
