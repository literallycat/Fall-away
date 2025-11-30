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
	            int xoffset = 5;
            	float2 inuv = i.uv;
				inuv.y = 1.0 - inuv.y;
				float2 uv = inuv*float2( 11, 1 );;
				int2 dig = floor( uv );

				float2 gradval = uv;
				float4 grad = float4( ddx(gradval), ddy(gradval) );
            	// 2: Time since level start in milliseconds.

				float value = AudioLinkDecodeDataAsSeconds(ALPASS_GENERALVU_INSTANCE_TIME);
				float seconds = glsl_mod(value, 60);
				int minutes = (value/60) % 60;
				int hours = (value/3600);
				value = hours * 10000 + minutes * 100 + seconds;
				
				if( dig.x < 3 )
				{
					value = hours;
					xoffset = 2;
				}
				else if( dig.x < 6 )
				{
					value = minutes;
					xoffset = 5;
				}
				else if( dig.x > 5)
				{
					value = seconds;
					xoffset = 8;
				}
            	float2 fielduv = ( uv + float2(-10., 0.0 ) ) * float2( 1.0/11.0, 1.0 );
            	
				fixed4 col = MSDFPrintNum( value, fielduv, grad, 11.0, 10, true, -xoffset ).xxxy;

                return col;
            }
            ENDCG
        }
    }
}
