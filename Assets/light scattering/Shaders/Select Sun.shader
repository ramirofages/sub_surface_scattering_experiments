Shader "Unlit/Select Sun"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
	}

	SubShader
	{
		Tags{  "Render" = "Sun" "Queue"="Transparent"}
		
		ZWrite Off
			
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			sampler _MainTex;
			fixed4 _Color;
			#include "UnityCG.cginc"

			float4 frag(v2f_img i) : COLOR
			{
				return _Color * tex2D(_MainTex,i.uv*4+fixed2(_Time.x*3,_Time.x*3*0));
			}
			ENDCG
		}
	}
}
