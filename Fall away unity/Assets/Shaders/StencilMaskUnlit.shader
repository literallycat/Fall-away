Shader "Unlit/StencilMaskUnlit"
{
    Properties
    {
        _SRef("Stencil Ref", Int) = 1
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Comp", Int) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Op", Int) = 2
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue" = "Geometry-1"
        }
        
        Cull [_Cull]
        ZWrite Off
        ColorMask 0
        
        Stencil
        {
            Ref [_SRef]
            Comp [_SComp]
            Pass [_SOp]
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
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
                return o;
            }

            fixed4 frag () : SV_Target
            {
                return 0;
            }
            ENDCG
        }
    }
}
