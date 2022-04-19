	   wayne_ink   	   MatrixPVW                                                                                SAMPLER    +         IMAGE_PARAMS                                sin_y_distortion.vse  uniform mat4 MatrixPVW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;
attribute vec4 DIFFUSE;

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0.xy;
	PS_COLOUR.rgba = vec4( DIFFUSE.rgb * DIFFUSE.a, DIFFUSE.a ); // premultiply the alpha
}
    sin_y_distortion.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[1];
varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

uniform vec2 ALPHA_RANGE;
uniform vec4 IMAGE_PARAMS;

// #define ALPHA_MIN   ALPHA_RANGE.x
// #define ALPHA_MAX   ALPHA_RANGE.y
#define TIME		IMAGE_PARAMS.x  

// wave tuning params
#define AMPLITUDE	IMAGE_PARAMS.y  
#define FREQUENCY   IMAGE_PARAMS.z
#define VELOCITY    IMAGE_PARAMS.w
 
void main()
{
    float deltaY = (sin(FREQUENCY*PS_TEXCOORD.y - TIME*VELOCITY)) * AMPLITUDE;
    vec2 newCoord = vec2(PS_TEXCOORD.x, PS_TEXCOORD.y + deltaY);
    vec4 colour = texture2D( SAMPLER[0], newCoord );
    colour.rgba *= PS_COLOUR.rgba;

    //float alpha = clamp( ( colour.a - ALPHA_MIN ) / ( ALPHA_MAX - ALPHA_MIN ), -1.0, 1.0 );
	//gl_FragColor = vec4( colour.rgb * alpha, alpha ) * PS_COLOUR.rgba;
    
    //float alpha = colour.a - ALPHA_MIN;
	gl_FragColor = colour; //vec4( colour.rgb * alpha, alpha );
}
                 