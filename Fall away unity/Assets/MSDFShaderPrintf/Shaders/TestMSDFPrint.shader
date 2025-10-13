Shader "Unlit/TestMSDFPrint"
{
	Properties
	{
				_UdonMSDFPrintf ("MSDF Texture", 2DArray) = "white" {}
		_VScroll ("Vertical Scroll", Range(0,1)) = 0
		_HScroll ("Horizontal Scroll", Range(0,1)) = 0

	}
	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}

		Pass
		{
			//ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			#include "../MSDFShaderPrintf.cginc"
			#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
			float _VScroll;
			float _HScroll;
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

	
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = 0.0;
				
				int lines = 21;
				int columns = 21;
				float2 inuv = i.uv;
				inuv.y = 1.0 - inuv.y;
				float2 uv = inuv * float2( columns, lines );
				int2 dig = floor( uv );

				float2 gradval = uv;
				float4 grad = float4( ddx(gradval), ddy(gradval) );

				if( uv.x < 10 && uv.y <= 13 )
				{
					const uint sendarr[130] = { 
						'I', 'n', 's', 't', 'a', 'n', 'c', 'e', ' ', ' ',
						'W', 'a', 'l', 'l', 'c', 'l', 'o', 'c', 'k', ' ',
						'N', 'e', 't', 'w', 'o', 'r', 'k', ' ', ' ', ' ',
						'U', 'T', 'C', ' ', 'D', 'a', 'y', 's', ' ', ' ',
						'U', 'T', 'C', ' ', 'S', 'e', 'c', 'o', 'n', 'd',
						'A', 'u', 't', 'o', ' ', 'g', 'a', 'i', 'n', ' ',
						'P', 'e', 'a', 'k', ' ', 'v', 'a', 'l', 'u', 'e',
						'R', 'M', 'S', ' ', 'v', 'a', 'l', 'u', 'e', ' ',
						'F', 'P', 'S', ' ', 'T', '/', 'A', 'L', ' ', ' ',
						'P', 'l', 'a', 'y', 'e', 'r', 'I', 'n', 'f', 'o',
						'D', 'e', 'b', 'u', 'g', ' ', '1', ' ', ' ', ' ',
						'D', 'e', 'b', 'u', 'g', ' ', '2', ' ', ' ', ' ',
						'D', 'e', 'b', 'u', 'g', ' ', '3', ' ', ' ', ' ',
					};
					const int newArr[12] = {
						98,97,108,108,115,115,115,115,115,115,115,32
					};
					dig = floor( uv );
					int val = sendarr[dig.x + dig.y * 10];
					col = MSDFPrintChar( val, uv,  grad ).xxxy;
					float VScrollThreshold = _VScroll * 14.0;
					float HScrollThreshold = _HScroll * 14.0;
					if (dig.y > VScrollThreshold)
					{
						col.a = 0;
					}
					if (dig.x > HScrollThreshold)
					{
						col.a =0;
					}

					
				}
				
		
				float4 amplitudemon = AudioLinkData( ALPASS_WAVEFORM + int2( inuv.x*128, 0 ) );
				float2 uvin = ( inuv.xy*float2(1., 11./3.)-float2( 0., 8./3.) );
				float r = amplitudemon.r + amplitudemon.a;
				float l = amplitudemon.r - amplitudemon.a;
				float comp = uvin.y * 2. - 1.;
				float ramp = saturate( (.05 - abs( r - comp )) * 40. );
				float lamp = saturate( (.05 - abs( l - comp )) * 40. );
				col.xyz += float3( 1., 0.2, 0.2 ) * ramp + float3( .2, .2, 1. ) * lamp * (1.0 - col.a);
				col.a += saturate(ramp + lamp);
						
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
