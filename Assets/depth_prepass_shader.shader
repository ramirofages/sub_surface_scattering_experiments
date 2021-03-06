﻿Shader "depth_prepass_shader"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
            //Cull front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
                float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float depth : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            float4x4 _ToLight;
            float _NormalScale;
			
			v2f vert (appdata v)
			{
				v2f o;
                float3 scaled_pos = v.vertex.xyz + normalize(v.normal) * _NormalScale ;

                o.vertex = mul(_ToLight, mul(unity_ObjectToWorld, float4(scaled_pos, 1)));
                o.depth = o.vertex.z;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                return i.depth;
//                return i.vertex.zzzz;
			}
			ENDCG
		}
	}
}
