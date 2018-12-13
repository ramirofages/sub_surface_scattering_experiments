Shader "Unlit/skin"
{
	Properties
	{
        _MainTex ("Texture", 2D) = "white" {}
		_ColorRamp ("Color ramp", 2D) = "white" {}
        _MaxDepth("Max depth", Range(0,0.01)) = 0.01
        _NormalScale("Normal scale", Range(0,0.1)) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float4 proj_pos : TEXCOORD1;
                float3 normal : NORMAL;
                
			};

            sampler2D _MainTex;
            sampler2D _DepthDifference;
			sampler2D _ColorRamp;
			float4 _MainTex_ST;
			float4x4 _ToLight;
            float _MaxDepth;
            float _NormalScale;

			v2f vert (appdata v)
			{
				v2f o;
                o.normal = mul(unity_ObjectToWorld, float4(v.normal.xyz,0));
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.proj_pos = mul(_ToLight, mul(unity_ObjectToWorld, v.vertex));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float2 uv = (i.proj_pos.xy/ i.proj_pos.w)*0.5+0.5;
                float depth = i.proj_pos.z/i.proj_pos.w;
                uv.y = 1 - uv.y;
                float3 normal = normalize(i.normal);



                float depth_difference = abs(tex2D(_DepthDifference, uv).r - depth);
                float normalized_depth = saturate(depth_difference/_MaxDepth);
				fixed3 col = tex2D(_MainTex, i.uv).rgb;
                float3 ramp = tex2D(_ColorRamp, float2(normalized_depth, 0)).rgb;
                return float4(lerp(col, col*ramp, 1-normalized_depth),1);
			}
			ENDCG
		}
	}
}
