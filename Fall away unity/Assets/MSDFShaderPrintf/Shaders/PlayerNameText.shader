Shader "MSDFShaderUn/PlayerNameText"
{
    Properties
    {
        _UdonMSDFPrintf ("MSDF Texture", 2DArray) = "white" {}
        // generation from TextGen.cs
        _FGColor ("Colour",Color) = (0,0,0,0)
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
			#include "Assets/MSDFShaderPrintf/MSDFShaderPrintf.cginc"
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
            float _Rev;
            float4 _FGColor;
			float _VScroll;
			float _HScroll;


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
            #define PIXELFONT_ROWS 1
            #define PIXELFONT_COLS 32
            fixed4 frag (v2f i) : SV_Target
            {
                int TextW = 32;
                int TextH = 1;
				float2 inuv = i.uv ;
				inuv.y = 1.0 - inuv.y;
				float2 uv = inuv * float2( TextW, TextH );

				float2 gradval = uv;
				float4 grad = float4( ddx(gradval), ddy(gradval) );
                
				int2 dig = floor( uv );
            	int character = AudioLinkGetGlobalStringChar(uv.y, uv.x);

				float4 col = MSDFPrintChar( character, uv,  grad ).xxxy * _FGColor;
            	float VScrollThreshold = _VScroll * TextH;
					float HScrollThreshold = _HScroll * TextW;
					if (dig.y > VScrollThreshold)
					{
						col.a = 0;
					}
					if (dig.x > HScrollThreshold)
					{
						col.a =0;
					}
                return col;
            }
            ENDCG
        }
    }
}
