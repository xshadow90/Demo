precision mediump float;
//varying lowp vec4 DestinationColor;
uniform vec4 Color;

varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) {
    gl_FragColor = Color;// * texture2D(Texture, TexCoordOut); // New
}