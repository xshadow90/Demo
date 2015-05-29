attribute vec4 Position;
//attribute vec4 SourceColor;

//varying vec4 DestinationColor;

uniform mat4 testProjection;
uniform mat4 testModelview;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void) {
//    DestinationColor = SourceColor;
    gl_Position = testProjection * testModelview * Position;
//    TexCoordOut = TexCoordIn; // New
}