// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effects/Volumetric Lightning"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SourceTex("Source", 2D) = "black" {}
		_Weight("Weight", Range(0,2)) = 0.5
		_Density("Density", Range(0,1)) = 0.5
		_Exposure("Exposure", Range(0,10)) = 0.5

		_Decay("Decay", Range(0.01,1)) = 0.9
		_NUM_SAMPLES("SAMPLES", Range(1,100)) = 5

	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				
			};
			uniform float4 light_pos;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _SourceTex;
			float _Decay;
			float _NUM_SAMPLES;
			float _Density;
			
			float _Weight;
			float _Exposure;

			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 texCoord = i.uv;

				float2 sourceUV = i.uv;
//				sourceUV.y = 1 - sourceUV.y;

				fixed4 source_col = tex2D(_SourceTex, sourceUV);
				float2 real_light = light_pos.xy;
				
				half2 deltaTexCoord = (texCoord - real_light);
				deltaTexCoord *= 1.0f / _NUM_SAMPLES * _Density;
				half3 color = tex2D(_MainTex, texCoord);
				half illuminationDecay = 1.0f;
				
				for (int i = 0; i < _NUM_SAMPLES; i++)
				{
					// Step sample location along ray.
					texCoord -= deltaTexCoord;
					// Retrieve sample at new location.
					half3 sample = tex2D(_MainTex, texCoord) ;
					// Apply sample attenuation scale/decay factors.
					sample *=  illuminationDecay * _Weight;
					// Accumulate combined color.
					color += sample;
					// Update exponential decay factor.
					illuminationDecay *= _Decay;
				}
				
				color.rgb = color.rgb * _Exposure;
				return float4(color + source_col * 1.1, 1);
				//return fixed4(color,1);
			}
			ENDCG
		}
	}
}
