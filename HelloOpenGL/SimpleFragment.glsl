varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) {
    gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New
}



//precision mediump float;
//uniform vec4 DestinationColor; // 1
//
//void main(void) { // 2
//    gl_FragColor = Color; // 3
//}