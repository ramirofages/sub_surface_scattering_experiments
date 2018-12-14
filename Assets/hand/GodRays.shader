Shader "Hidden/GodRays"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("Mask Tex", 2D) = "white" {}
        
        _LightDistance("light distance", Range(0,1)) = 1
        _Exposure("exposure", Range(0.1,10)) = 1
        _Weight("weight", Range(0.1,10)) = 1
        _Decay("decay ", Range(0,1)) = 1
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
            sampler2D _MaskTex;
            

            float _LightDistance;

            float _Exposure;
            float _Weight;
            float _Decay;
            #define NUM_STEP 80
			fixed4 frag (v2f i) : SV_Target
			{
                float mask = tex2D(_MaskTex, i.uv).r;
                float3 col = tex2D(_MainTex, i.uv).rgb;
                float accum = 0;
                float2 delta_coord = i.uv - float2(i.uv.x, i.uv.y);

                delta_coord/= NUM_STEP;

                float2 pos = i.uv;

                for(int i=0; i< NUM_STEP; i++)
                {
                    accum += tex2D(_MainTex, pos).a * _Decay * _Weight ;
                    
                    pos-= delta_coord;
                }
                accum *= _Exposure;
                //accum = min(accum,0.5);

                
				return fixed4(lerp(col, col + accum, accum * mask), 0);
			}
			ENDCG
		}
	}
}
