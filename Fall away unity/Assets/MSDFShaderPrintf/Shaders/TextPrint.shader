Shader "Custom/TextPrint"
{
    Properties
    {
        _UdonMSDFPrintf ("MSDF Texture", 2DArray) = "white" {}
        // generation from TextGen.cs
        _TextTex ("Text Texture", 2D) = "white" {}
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
			#include "../MSDFShaderPrintf.cginc"


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
            uniform Texture2D<float4> _TextTex;
            #define texGrab(xycoord) (_TextTex[xycoord].r*255)
            float4 _FGColor;
            uniform half4 _TextTex_TexelSize;
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

            fixed4 frag (v2f i) : SV_Target
            {
                int TextW = texGrab(uint2(0,0));
                int TextH = texGrab(uint2(1,0));
				float2 inuv = i.uv ;
				inuv.y = 1.0 - inuv.y;
				float2 uv = inuv * float2( TextW, TextH );

				float2 gradval = uv;
				float4 grad = float4( ddx(gradval), ddy(gradval) );
                
				int2 dig = floor( uv );
				int val = texGrab(uint2((dig.x + dig.y * TextW) +2,0));
				float4 col = MSDFPrintChar( val, uv,  grad ).xxxy * _FGColor;
            	float VScrollThreshold = _VScroll * TextW;
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
