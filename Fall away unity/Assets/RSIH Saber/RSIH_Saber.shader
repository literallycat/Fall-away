Shader "Vivify/CustomObjects/rsih saber"
{
    Properties
    {
        _Color ("Saber Color", Color) = (1,1,1)
        _FlickerSpeed ("Flicker Speed", Range(0.1, 20)) = 8
        _FlickerIntensity ("Flicker Intensity", Range(0, 1)) = 0.2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float3, _Color)
            UNITY_INSTANCING_BUFFER_END(Props)

            float _FlickerSpeed;
            float _FlickerIntensity;

            // Pseudo-random from time
            float randomTime(float t)
            {
                return frac(sin(t * 12.9898) * 43758.5453);
            }

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                float3 baseColor = UNITY_ACCESS_INSTANCED_PROP(Props, _Color);

                // Create a time-based flicker (random-like jumps)
                float t = _Time.y * _FlickerSpeed;
                float noise = randomTime(floor(t)); // changes every frame step
                float flicker = 1.0 + (noise - 0.5) * 2.0 * _FlickerIntensity;

                return float4(baseColor * flicker, 1);
            }
            ENDCG
        }
    }
}
