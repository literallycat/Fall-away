// Vivify cubemap shader
Shader"Custom/CubeMap"
{
    Properties
    {
       [NoScaleOffset] _CubeMap ("cubemap",Cube) = "grey" {}
       _Tint ("Tint",Color) = (.5, .5, .5, .5)
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"}
        // Colour Masks are broken with the post processor
        //ColorMask RGB

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            samplerCUBE _CubeMap;
            half4 _CubeMap_HDR;
            half4 _Tint;
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 localPosition : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, v2f o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.localPosition = v.vertex.xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 tex = texCUBE(_CubeMap,i.localPosition);
                half3 c = DecodeHDR(tex,_CubeMap_HDR);
                c = c * _Tint.rgb * unity_ColorSpaceDouble.rgb;
                c *= 1.0;
                return float4(c,0);
                
            }
            ENDCG
        }
    }
}