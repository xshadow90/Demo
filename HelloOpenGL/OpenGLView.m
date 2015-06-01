//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"
#import "CC3GLMatrix.h"
#import "cube.h"

@implementation OpenGLView

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2]; // New
} Vertex;

//const Vertex Vertices[] = {
// {{1, -1, 0}, {1, 0, 0, 1}},
// {{1, 1, 0}, {0, 1, 0, 1}},
// {{-1, 1, 0}, {0, 0, 1, 1}},
// {{-1, -1, 0}, {0, 0, 0, 1}}
// };

// const GLubyte Indices[] = {
// 0, 1, 2,
// 2, 3, 0
// };

#define TEX_COORD_MAX   4

//const float cubeColors[144] =
//{
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    0.999999, 1, 1, 1,
//    1, 1, 0.999999, 1,
//    0.999999, 1, 1, 1,
//    1, 1, 1, 1,
//    0.999999, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 0.999999, 1,
//    1, 1, 1, 1,
//    0.999999, 1, 1,
//    1, 1, 1,
//    1, 1, 0.999999, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    0.999999, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//    1, 1, 0.999999, 1,
//    1, 1, 1, 1,
//    1, 1, 1, 1,
//};

const Vertex Vertices[] = {
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}},
    {{1, 1, 1}, {1, 0, 0, 1}, {1, 1}},
    {{-1, 1, 1}, {0, 1, 0, 1}, {0, 1}},
    {{-1, -1, 1}, {0, 1, 0, 1}, {0, 0}},
    {{1, -1, -1}, {1, 0, 0, 1}, {1, 0}},
    {{1, 1, -1}, {1, 0, 0, 1}, {1, 1}},
    {{-1, 1, -1}, {0, 1, 0, 1}, {0, 1}},
    {{-1, -1, -1}, {0, 1, 0, 1}, {0, 0}}
};
//const Vertex Vertices[] = {
//    {{1, -1, -5}, {1, 0, 0, 1}},
//    {{1, 1, -5}, {0, 1, 0, 1}},
//    {{-1, 1, -2}, {0, 0, 1, 1}},
//    {{-1, -1, -2}, {0, 0, 0, 1}}
//};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1,
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4
};

//const GLubyte Indices[] = {
//    0, 1, 2,
//    2, 3, 0
//};

//const Vertex Vertices2[] = {
//    {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
//    {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
//    {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
//    {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
//};
//
//const GLubyte Indices2[] = {
//    1, 0, 2, 3
//};

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = NO;
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetUniformLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
//    glEnableVertexAttribArray(_colorSlot);
    
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
//    _colorSlot = glGetUniformLocation(programHandle, "Color");

    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
    
    printf("%d  %d  %d  %d\n", _positionSlot, _colorSlot, _projectionUniform, _modelViewUniform);
    
    
}

- (void)setupVBOs {
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
}

//- (void)render:(CADisplayLink*)displayLink {
//    [self display];
//}

//- (void)drawRect:(CGRect)rect {
- (void)render:(CADisplayLink*)displayLink {
//    glClearColor(0, 0.5, 0.5, 0.0);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromTranslation:CC3VectorMake(0, 0, -7)];
    _currentRotation += displayLink.duration * 180;
    [modelView rotateBy:CC3VectorMake(_currentRotation, 2 * _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    // 1
    
    
    // 2
    
    float markerColor[] = { 1, 1, 1, 1 };
    glUniform4fv(_colorSlot, 1, markerColor);
    
//    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
//                          sizeof(Vertex), 0);
//    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
//                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    // Positions
    glEnableVertexAttribArray(_positionSlot);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, cubePositions);
    
    // Texture
    glEnableVertexAttribArray(_texCoordSlot);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, cubeTexels);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _cubeTexture);
    glUniform1i(_textureUniform, 0);
    
    
    // 3
//    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
//                   GL_UNSIGNED_BYTE, 0);
    glDrawArrays(GL_TRIANGLES, 0, cubeVertices);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
//    glDisableVertexAttribArray(_positionSlot);
}

- (void)setupDisplayLink {
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"GLView: init with frame");
    self = [super initWithFrame:frame];
    
//    _context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];
//    [EAGLContext setCurrentContext:_context];
//    self = [super initWithFrame:frame context:_context];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        
//        [self setupVBOs];
        [self setupDisplayLink];
        
        _cubeTexture = [self setupTexture:@"cube.png"];
        
        // configure
//        [self setEnableSetNeedsDisplay:NO]; // important to render every frame periodically and not on demand!
//        [self setOpaque:NO];                // we have a transparent overlay
//        [self setDrawableColorFormat:GLKViewDrawableColorFormatRGBA8888];
//        [self setDrawableDepthFormat:GLKViewDrawableDepthFormat24];
//        [self setDrawableStencilFormat:GLKViewDrawableStencilFormat8];
        
        [self compileShaders];
//        glDisable(GL_CULL_FACE);
//        [self setNeedsDisplay];
        [self setNeedsDisplay];
        
    }
    return self;
}

- (void)dealloc
{
    [_context release];
    _context = nil;
    [super dealloc];
}

@end
