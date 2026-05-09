Shader "Aeroluna/OverlayUITex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _OverlayTex ("Overlay Tex", 2D) = "black" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma shader_feature_fragment MULTIPASS_ENABLED

            #include "UnityCG.cginc"

            UNITY_DECLARE_SCREENSPACE_TEXTURE(_MainTex);
            UNITY_DECLARE_SCREENSPACE_TEXTURE(_OverlayTex);
            float4 _MainTex_TexelSize;
            float4 _OverlayTex_TexelSize;

            fixed4 frag (v2f_img i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                fixed4 col = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, UnityStereoTransformScreenSpaceTex(i.uv));
                #if defined(USING_STEREO_MATRICES) || MULTIPASS_ENABLED
                    return col;
                #endif

                float2 overUv = i.uv;
                float mainWidth = _MainTex_TexelSize.z;
                float overlayWidth = _OverlayTex_TexelSize.z;

                #if defined(UNITY_SINGLE_PASS_STEREO)
                mainWidth *= 0.5;
                overlayWidth *= 0.5;
                #endif

                float mainAspect = mainWidth * _MainTex_TexelSize.y;
                float overAspect = overlayWidth * _OverlayTex_TexelSize.y;

                if (overAspect > mainAspect)
                {
                    overUv.y -= 0.5;
                    overUv.y *= overAspect / mainAspect;
                    overUv.y += 0.5;
                }
                else
                {
                    overUv.x -= 0.5;
                    overUv.x *= mainAspect / overAspect;
                    overUv.x += 0.5;
                }

                overUv = saturate(overUv);

                fixed4 overlay = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_OverlayTex, UnityStereoTransformScreenSpaceTex(overUv));
                return col + overlay;
            }
            ENDCG
        }
    }
}
