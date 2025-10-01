// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "BeatSaber/Good"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,0)
		_Tex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// Tags { "Queue"="CutOut" "RenderType"="CutOut" }
		// LOD 100
        // Cull Off

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB
        // Cull Off Lighting Off ZWrite Off
        Cull Off Lighting Off ZWrite Off
        // LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;

                UNITY_VERTEX_INPUT_INSTANCE_ID //Insert
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;

                UNITY_VERTEX_OUTPUT_STEREO //Insert
			};

			float4 _Color;

			sampler2D _Tex;
			float4 _Tex_ST;
			
            v2f vert (appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v); //Insert
                UNITY_INITIALIZE_OUTPUT(v2f, o); //Insert
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o); //Insert

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }
			
			fixed4 frag (v2f i) : SV_Target
			{

                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i); //Insert

				// float3 lightDir = normalize(_LightDir.xyz) * -1.0;
				// float shadow = max(dot(lightDir,i.normal),0);
				// sample the texture
				fixed4 col = _Color * tex2D(_Tex, i.uv);

				// col = col * clamp(col * _Ambient + shadow,0.0,1.0);
                // col.a = ceil(col.a); 
                // col.a = step(0.99, col.a);

				return col;
			}
			ENDCG
		}
	}
}
