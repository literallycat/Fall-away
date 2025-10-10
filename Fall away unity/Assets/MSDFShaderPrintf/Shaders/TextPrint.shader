Shader "Custom/TextPrint"
{
    Properties
    {
        _UdonMSDFPrintf ("MSDF Texture", 2D) = "white" {}
        // generation from TextGen.cs
        _TextTex ("Text Texture", 2D) = "white" {}
		_Rev ("Horizontal Scroll", Range(0,1)) = 0

    }
    SubShader
    {
        Tags {
            "RenderType"="Opaque"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            // thanks cnolr sm for making this
			#include "../MSDFShaderPrintf.cginc"

            // VivifyTemplate Libraries
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Noise.cginc"
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Colors.cginc"
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Math.cginc"
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Easings.cginc"

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
            sampler2D _TextTex;
            float4 _TextTex_TexelSize;

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
				float4 col = 0.0;
                int lines = _TextTex_TexelSize.x;
                int columns = _TextTex_TexelSize.y;
                return col;
            }
            ENDCG
        }
    }
}
