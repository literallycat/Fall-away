Shader "Custom/StaticMine"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (0,0,0,0)
       
        _ResX ("X Resolution", Float) = 100
        _ResY ("Y Resolution", Float) = 200
       
        _ScaleWithZoom("Scale With Cam Distance", Range(0,1)) = 1.0
    }
    SubShader
    {
        Tags {
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // VivifyTemplate Libraries
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Noise.cginc"
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Colors.cginc"
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Math.cginc"
            // #include "Assets/VivifyTemplate/Utilities/Shader Functions/Easings.cginc"
            float rand(float2 co)
             {
                     return frac((sin( dot(co.xy , float2(12.345 * _Time.w, 67.890 * _Time.w) )) * 12345.67890+_Time.w));
             }
           
            fixed4 _ColorA;
            fixed4 _ColorB;
           
            float _ResX;
            float _ResY;
            float _ScaleWithZoom;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 camDist : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                float4 modelOrigin = mul(unity_ObjectToWorld, float4(0.0, 0.0, 0.0, 1.0));
                o.camDist.x = distance(_WorldSpaceCameraPos.xyz, modelOrigin.xyz);
                o.camDist.x = lerp(1.0, o.camDist.x, _ScaleWithZoom);
                return o;
            }

            fixed4 frag (float4 screenPos : SV_POSITION, v2f i) : SV_Target
            {
                fixed4 sc = fixed4((screenPos.xy),0.0,1.0);
                sc *= 0.001;
               
                sc.xy -= 0.5;
                sc.xy *= i.camDist.xx;
                sc.xy += 0.5;

               //round the screen coordinates to give it a blocky appearance
                sc.x = round(sc.x*_ResX)/_ResX;
                sc.y = round(sc.y*_ResY)/_ResY;
               
               
               
                float noise = rand(sc.xy);
               
                float4 stat = lerp(_ColorA, _ColorB, noise.x);
               
               
                return fixed4(stat.xyz, 0.0);
            }
            ENDCG
        }
    }
}
