Shader "Unlit/skin"
{
	Properties
	{
        _MainTex ("Texture", 2D) = "white" {}
		_ColorRamp ("Color ramp", 2D) = "white" {}
        _MaxDepth("Max depth", Range(0,1)) = 0.01
        _NormalScale("Normal scale", Range(0,0.1)) = 0.01
        _LightAttenuationDistance("LightAttenuationDistance", Range(0,10)) = 1
        _LightPower("_LightPower", Range(0.1,10)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
            Tags { "RenderType"="Opaque" }
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
				float2 uv           : TEXCOORD0;
                float4 proj_pos     : TEXCOORD1;
                float depth         : TEXCOORD2;
                float3 w_pos        : TEXCOORD3;
                
				float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                
			};

            sampler2D _MainTex;
            sampler2D _DepthDifference;
			sampler2D _ColorRamp;
			float4 _MainTex_ST;
			float4x4 _ToLight;
            float _MaxDepth;
            float _NormalScale;
            float _LightAttenuationDistance;
            float _LightPower;
            float2 _DepthDifferenceSize;
            float3 _LightPosition;

			v2f vert (appdata v)
			{
				v2f o;
                o.normal = mul(unity_ObjectToWorld, float4(v.normal.xyz,0));
                o.vertex = UnityObjectToClipPos(v.vertex + float4(v.normal * _NormalScale*0,0) );
                o.proj_pos = mul(_ToLight, mul(unity_ObjectToWorld, v.vertex));

                o.depth = o.proj_pos.z;
                o.w_pos = mul(unity_ObjectToWorld, v.vertex).xyz;
                
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

            float sample_depth(float2 uv)
            {
                float2 pixel_size = float2(0.5/_DepthDifferenceSize.x, 0.5/_DepthDifferenceSize.y);

                float s1 = tex2D(_DepthDifference, uv+float2(-pixel_size.x, pixel_size.y)).r* (1/ 16);
                float s2 = tex2D(_DepthDifference, uv+float2(0, pixel_size.y)).r* (2/ 16);
                float s3 = tex2D(_DepthDifference, uv+float2(pixel_size.x, pixel_size.y)).r* (1/ 16);

                float s4 = tex2D(_DepthDifference, uv+float2(-pixel_size.y, 0)).r* (2/ 16);
                float s5 = tex2D(_DepthDifference, uv+float2(0,0)).r* (4/ 16);
                float s6 = tex2D(_DepthDifference, uv+float2(pixel_size.x, 0)).r* (2/ 16);

                float s7 = tex2D(_DepthDifference, uv+float2(-pixel_size.x, -pixel_size.y)).r* (1/ 16);
                float s8 = tex2D(_DepthDifference, uv+float2(0, -pixel_size.y)).r* (2/ 16);
                float s9 = tex2D(_DepthDifference, uv+float2(pixel_size.x, -pixel_size.y)).r* (1/ 16);
                return (s1+s2+s3+s4+s5+s6+s7+s8+s9);
            }

//            float3 translucency()
//            {
//                float3 L = gi.light.dir;
//                 float3 V = viewDir;
//                 float3 N = s.Normal;
//                 
//                 float3 H = normalize(L + N * _Distortion);
//                 float I = pow(saturate(dot(V, -H)), _Power) * _Scale;
//            }
			
			fixed4 frag (v2f i) : SV_Target
			{
                float2 uv = (i.proj_pos.xy/ i.proj_pos.w)*0.5+0.5;
                float depth = i.depth;
                uv.y = 1 - uv.y;

                float depth_difference = abs(tex2D(_DepthDifference, uv).r - depth);
                //float depth_difference = abs(sample_depth(uv) - depth);


                float light_strength = 1-pow(saturate((length(_LightPosition - i.w_pos)-1)/_LightAttenuationDistance),_LightPower);

                float normalized_depth = saturate(depth_difference/_MaxDepth);
                float3 ramp = tex2D(_ColorRamp, float2(normalized_depth, 0)).rgb;
                
                return float4(ramp *light_strength,1);


                fixed3 col = tex2D(_MainTex, i.uv).rgb;
                return float4(lerp(col,ramp *light_strength, light_strength),1);
			}
			ENDCG
		}
	}
}
