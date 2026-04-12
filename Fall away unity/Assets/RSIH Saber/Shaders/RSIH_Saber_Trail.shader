Shader "Custom/rsih saber trail"
{
    Properties
    {
        _Brightness ("Brightness", Range(0,2)) = 1
        _Alpha ("Alpha", Range(0,1)) = 1

        _MainTex ("Main Texture", 2D) = "white" {}
        _MaskTex ("Mask (Alpha or R)", 2D) = "white" {}

        _UseMaskAlpha ("Use Mask Alpha (0=R,1=A)", Range(0,1)) = 1
        _InvertMask ("Invert Mask", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #pragma multi_compile _ UNITY_SINGLE_PASS_STEREO

            #include "UnityCG.cginc"

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

            // Properties
            uniform float _Brightness;
            uniform float _Alpha;

            sampler2D _MainTex;
            sampler2D _MaskTex;

            uniform float _UseMaskAlpha;
            uniform float _InvertMask;

            // HSV → RGB function (always full saturation = 1)
            float3 HSVtoRGB(float3 hsv)
            {
                float4 K = float4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
                float3 p = abs(frac(hsv.xxx + K.xyz) * 6.0 - K.www);
                return hsv.z * lerp(K.xxx, saturate(p - K.xxx), hsv.y);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                // Hue varies along Y, saturation = 1, value = 1
                float hue = frac(i.uv.y * 2.0);
                float3 rgb = HSVtoRGB(float3(hue, 1.0, 1.0));

                // Apply brightness
                rgb *= _Brightness;

                // Simple linear fade (top to bottom)
                float fade = 1.0 - saturate(i.uv.y);

                // Sample texture
                float3 texColor = tex2D(_MainTex, i.uv).rgb;

                // Sample mask (choose R or A)
                float4 maskSample = tex2D(_MaskTex, i.uv);
                float mask = lerp(maskSample.r, maskSample.a, _UseMaskAlpha);

                if (_InvertMask > 0.5)
                    mask = 1.0 - mask;

                // Final color
                float3 finalColor = rgb * texColor * fade;
                float finalAlpha = fade * mask * _Alpha;

                return float4(finalColor, finalAlpha);
            }
            ENDCG
        }
    }
}
