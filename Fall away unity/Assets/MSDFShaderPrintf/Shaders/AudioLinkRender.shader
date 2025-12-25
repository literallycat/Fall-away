Shader "Custom/AudioLinkRender"
{
    Properties
    {
        _UdonMSDFPrintf ("MSDF Texture", 2DArray) = "white" {}
        _VScroll ("Vertical Scroll", Range(0,1)) = 0
		_HScroll ("Horizontal Scroll", Range(0,1)) = 0
    }
    SubShader
    {
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}


        Pass
        {
	        Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "../MSDFShaderPrintf.cginc"
            #include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
            #include "Packages/com.llealloo.audiolink/Runtime/Shaders/SmoothPixelFont.cginc"

        

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };
			float _VScroll;
			float _HScroll;
            float _Rev;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
            	o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float value = 0;
                
                int cols = 8;
                int rows = 1;
				float2 inuv = i.uv ;
				inuv.y = 1.0 - inuv.y;
				float2 uv = inuv * float2( cols, rows );

				float2 gradval = uv;
				float4 grad = float4( ddx(gradval), ddy(gradval) );
                
				int2 dig = floor( uv );

                value = 0;
                int xoffset = 5;
                bool leadingzero = false;
                int points_after_decimal = 0; 
                int max_decimals = 6;

                value = AudioLinkDecodeDataAsSeconds( ALPASS_GENERALVU_INSTANCE_TIME );
                    float seconds = glsl_mod(value, 60);
                    int minutes = (value/60) % 60;
                    int hours = (value/3600);
                    value = hours * 10000 + minutes * 100 + seconds;
                    
                    if( dig.x < 3 )
                    {
                        value = hours;
                        xoffset = 2;
                        leadingzero = 1;
                    }
                    else if( dig.x < 5 )
                    {
                        value = minutes;
                        xoffset = 5;
                        leadingzero = 1;
                    }
                    else if( dig.x > 5)
                    {
                        value = seconds;
                        xoffset = 8;
                        leadingzero = 1;
                    }
                float4 col = MSDFPrintNum(value,uv,grad,dig.x-xoffset, points_after_decimal, leadingzero, 0).xxxy;
                return col;
                //return PrintNumberOnLine( value, fmxy, softness, dig.x - xoffset, points_after_decimal, max_decimals, leadingzero, 0 );
            }
            ENDCG
        }
    }
}
