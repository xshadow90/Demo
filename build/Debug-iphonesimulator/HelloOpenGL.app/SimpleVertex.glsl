attribute vec4 Position;
uniform vec4 SourceColor;

varying vec4 DestinationColor;


uniform mat4 Modelview;
uniform mat4 Projection;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Projection * Modelview * Position;
    TexCoordOut = TexCoordIn; // New
}

//attribute vec4 Position; // 1
//uniform vec4 SourceColor; // 2
//
//varying vec4 DestinationColor; // 3
//
//void main(void) { // 4
//    DestinationColor = SourceColor; // 5
//    gl_Position = Position; // 6
//}