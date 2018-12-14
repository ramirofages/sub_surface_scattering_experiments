Shader "Hidden/Blur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Padding("Padding ", Range(0.5,3)) = 1
        _Lerp("Lerp", Range(0,1)) = 1
        
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
            float _Padding;
            float _Lerp;

			fixed4 frag (v2f i) : SV_Target
			{
                float3 col = tex2D(_MainTex, i.uv).rgb;
            
				float2 step_size = _Padding/_ScreenParams.xy;
                fixed accum = tex2D(_MainTex, i.uv).a * 4.0/16;
                accum += tex2D(_MainTex, i.uv + float2(0, step_size.y)).a * 2.0/16;
                accum += tex2D(_MainTex, i.uv - float2(0, step_size.y)).a * 2.0/16;
                accum += tex2D(_MainTex, i.uv + float2(step_size.x, 0)).a * 2.0/16;
                accum += tex2D(_MainTex, i.uv - float2(step_size.x, 0)).a * 2.0/16;

                accum += tex2D(_MainTex, i.uv + step_size).a * 1.0/16 ;
                accum += tex2D(_MainTex, i.uv - step_size).a * 1.0/16 ;
                accum += tex2D(_MainTex, i.uv + float2(-step_size.x , step_size.y)).a * 1.0/16 ;
                accum += tex2D(_MainTex, i.uv + float2(step_size.x , -step_size.y)).a * 1.0/16 ;

                //col += accum;
                float3 ac = accum;
                return fixed4(lerp(col, ac, _Lerp), 0);
			}
			ENDCG
		}
	}
}
