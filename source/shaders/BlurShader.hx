package shaders;

import flixel.graphics.tile.FlxGraphicsShader;

class BlurShader extends FlxGraphicsShader
{
	@:glFragmentSource('
        #pragma header

        uniform sampler2D channel0;
        uniform vec2 channelResolution0;
        uniform vec2 resolution;
        
        const int samples = 90;
        const int LOD = 2;
        const int sLOD = 1 << LOD;
        const float sigma = float(samples) * .25;
        
        float gaussian(vec2 i) 
        {
            return exp(-.5 * dot(i /= sigma, i)) / (6.28 * sigma * sigma);
        }
        
        vec4 blur(sampler2D sp, vec2 U, vec2 scale) 
        {
            vec4 O = vec4(0);  
            int s = samples/sLOD;
            
            for (int i = 0; i < s * s; i++) 
            {
                vec2 d = vec2(i % s, i / s) * float(sLOD) - float(samples) / 2.;
                O += gaussian(d) * textureLod(sp, U + scale * d, float(LOD));
            }
            
            return O / O.a;
        }
        
        void main() 
        {
            vec2 uv = gl_FragCoord.xy / resolution.xy;
            gl_FragColor = blur(channel0, uv, 1.0 / channelResolution0.xy);
        }
    ')
	public function new()
	{
		super();
	}
}
