//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Shaohan Xu on 5/25/15.
//  Copyright (c) 2015 Shaohan Xu. All rights reserved.
//

#import "OpenGLView.h"
#import "CC3GLMatrix.h"
#import "cube.h"

#define QUAD_VERTICES 				4
#define QUAD_COORDS_PER_VERTEX      3
#define QUAD_TEXCOORDS_PER_VERTEX 	2
#define QUAD_VERTEX_BUFSIZE 		(QUAD_VERTICES * QUAD_COORDS_PER_VERTEX)
#define QUAD_TEX_BUFSIZE 			(QUAD_VERTICES * QUAD_TEXCOORDS_PER_VERTEX)

#define CUBE_VERTICES 				36

// vertex data for a quad
//const GLfloat quadVertices[] = {
//    -1, -1, 0,
//    1, -1, 0,
//    -1,  1, 0,
//    1,  1, 0 };

//const GLfloat cubePositions[108] =
//{
//    1, -1, 1,
//    -1, -1, 1,
//    -1, -1, -1,
//    -1, 1, -1,
//    -1, 1, 1,
//    0.999999, 1, 1,
//    1, 1, -0.999999,
//    0.999999, 1, 1,
//    1, -1, 1,
//    0.999999, 1, 1,
//    -1, 1, 1,
//    -1, -1, 1,
//    -1, -1, 1,
//    -1, 1, 1,
//    -1, 1, -1,
//    1, -1, -1,
//    -1, -1, -1,
//    -1, 1, -1,
//    1, -1, -1,
//    1, -1, 1,
//    -1, -1, -1,
//    1, 1, -0.999999,
//    -1, 1, -1,
//    0.999999, 1, 1,
//    1, -1, -1,
//    1, 1, -0.999999,
//    1, -1, 1,
//    1, -1, 1,
//    0.999999, 1, 1, 
//    -1, -1, 1, 
//    -1, -1, -1, 
//    -1, -1, 1, 
//    -1, 1, -1, 
//    1, 1, -0.999999, 
//    1, -1, -1, 
//    -1, 1, -1, 
//};

@interface OpenGLView ()
{
    float   _rotate;
}

@property (strong, nonatomic) GLKBaseEffect* effect;

@end

@implementation OpenGLView

CADisplayLink* displayLink;

//typedef struct {
//    float Position[3];
//    float Color[4];
//    float TexCoord[2]; // New
//} Vertex;

//const Vertex Vertices[] = {
//    {{1, -1, 0}, {1, 1, 1, 1}, {1, 0}},
//    {{1, 1, 0}, {1, 1, 1, 1}, {1, 1}},
//    {{-1, 1, 0}, {1, 1, 1, 1}, {0, 1}},
//    {{-1, -1, 0}, {1, 1, 1, 1}, {0, 0}},
//    {{1, -1, -1}, {1, 1, 1, 1}, {1, 0}},
//    {{1, 1, -1}, {1, 1, 1, 1}, {1, 1}},
//    {{-1, 1, -1}, {1, 1, 1, 1}, {0, 1}},
//    {{-1, -1, -1}, {1, 1, 1, 1}, {0, 0}}
//};
//
//const GLubyte Indices[] = {
//    // Front
//    0, 1, 2,
//    2, 3, 0,
//    // Back
//    4, 6, 5,
//    4, 7, 6,
//    // Left
//    2, 7, 3,
//    7, 6, 2,
//    // Right
//    0, 4, 1,
//    4, 1, 5,
//    // Top
//    6, 2, 1,
//    1, 6, 5,
//    // Bottom
//    0, 3, 7,
//    0, 7, 4
//};

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)createEffect
{
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
    
    // Texture
    NSDictionary* options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cube.png" ofType:nil];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(texture == nil)
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    
    self.effect.texture2d0.name = texture.name;
    self.effect.texture2d0.enabled = true;
}

//- (GLuint)setupTexture:(NSString *)fileName {
//    // 1
//    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
//    if (!spriteImage) {
//        NSLog(@"Failed to load image %@", fileName);
//        exit(1);
//    }
//
//    // 2
//    size_t width = CGImageGetWidth(spriteImage);
//    size_t height = CGImageGetHeight(spriteImage);
//
//    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
//
//    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
//                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
//
//    // 3
//    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
//
//    CGContextRelease(spriteContext);
//
//    // 4
//    GLuint texName;
//    glGenTextures(1, &texName);
//    glBindTexture(GL_TEXTURE_2D, texName);
//
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
//
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
//
//    free(spriteData);
//    return texName;
//}

- (void)render:(CADisplayLink *)displayLink {
    [self display];
}

//- (void)setMatrices {
//    CC3GLMatrix *projection = [CC3GLMatrix matrix];
//    float h = 4.0f * self.frame.size.height / self.frame.size.width;
//    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
//    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
//    
//    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
//    [modelView populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7+sin(2*CACurrentMediaTime()))];
//    _currentRotation += displayLink.duration * 90;
//    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
//    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
//}

- (void)setMatrices
{
    // Projection Matrix
    const GLfloat aspectRatio = (GLfloat)(self.frame.size.width) / (GLfloat)(self.frame.size.height);
    const GLfloat fieldView = GLKMathDegreesToRadians(90.0f);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45.0f));
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(_rotate));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(_rotate));
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    
}

- (void)drawRect:(CGRect)rect {
    
//    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
//    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width*2, self.frame.size.height*2);
    
    //    printf("%f  %f\n", self.frame.size.width, self.frame.size.height);
    
    [self.effect prepareToDraw];
    [self setMatrices];
    
//    float markerColor[] = { 1, 1, 1, 0.75f };
//    glUniform4fv(_colorSlot, 1, markerColor);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, cubePositions);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, cubeTexels);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, cubeVertices);
    
    //    // 2
    //    glEnableVertexAttribArray(_positionSlot);
    //    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
    //                          sizeof(Vertex), 0);
    
    //    glEnableVertexAttribArray(_colorSlot);
    //    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
    //                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    //    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE,
    //                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    //    glActiveTexture(GL_TEXTURE0);
    //    glBindTexture(GL_TEXTURE_2D, _floorTexture);
    //    glUniform1i(_textureUniform, 0);
    
    // 3
    //    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    //    glDrawArrays(GL_TRIANGLES, 0, sizeof(Indices)/sizeof(Indices[0]));
    
    //    [_context presentRenderbuffer:GL_RENDERBUFFER];
    glDisableVertexAttribArray(_positionSlot);
}

- (void)setupDisplayLink {
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (id)initWithFrame:(CGRect)frame
{
    EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    self = [super initWithFrame:frame context:context];
    
    if (self) {
        
        printf("init finished..........\n");
        [self setNeedsDisplay];
        glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
        _rotate = 0.0f;
        
//        glDisable(GL_CULL_FACE);
        [self setupDisplayLink];
        
        //        _floorTexture = [self setupTexture:@"tile_floor.png"];
        //        _fishTexture = [self setupTexture:@"item_powerup_fish.png"];
        
        // configure
        [self setEnableSetNeedsDisplay:NO]; // important to render every frame periodically and not on demand!
        [self setOpaque:NO];                // we have a transparent overlay
        
        [self setDrawableColorFormat:GLKViewDrawableColorFormatRGBA8888];
        [self setDrawableDepthFormat:GLKViewDrawableDepthFormat24];
        [self setDrawableStencilFormat:GLKViewDrawableStencilFormat8];
        
//        glEnable(GL_CULL_FACE);
        [self createEffect];
    }
    return self;
}

- (void)update
{
    _rotate += 1.0f;
}


// Replace dealloc method with this
- (void)dealloc
{
    [_context release];
    _context = nil;
    [super dealloc];
}
@end
