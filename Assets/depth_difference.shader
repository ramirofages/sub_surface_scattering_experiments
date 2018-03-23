Shader "depth_difference"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
            Cull back
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
                float4 proj_pos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

            sampler2D _DepthPrepass;
			float4x4 _ToLight;

			v2f vert (appdata v)
			{
				v2f o;
                o.vertex = mul(_ToLight, mul(unity_ObjectToWorld, v.vertex));
                o.proj_pos = mul(_ToLight, mul(unity_ObjectToWorld, v.vertex));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float2 uv = (i.proj_pos.xy/ i.proj_pos.w) * 0.5 + 0.5;
                uv.y = 1-uv.y;
                return (i.vertex.z - tex2D(_DepthPrepass, uv).r);
			}
			ENDCG
		}
	}
}
