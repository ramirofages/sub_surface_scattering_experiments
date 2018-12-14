Shader "Unlit/Select objects"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		
		ZWrite On
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			
			#include "UnityCG.cginc"

			float4 frag(v2f_img i) : COLOR
			{

				return fixed4(1,1,1,1);
			}
			ENDCG
		}
	}
	SubShader
	{
		Tags{ "RenderType" = "TreeBark" }

		ZWrite On

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag


			#include "UnityCG.cginc"

			float4 frag(v2f_img i) : COLOR
			{

				return fixed4(1,1,1,1);
			}
			ENDCG
		}
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeLeaf" }

		ZWrite On

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag


			#include "UnityCG.cginc"

			float4 frag(v2f_img i) : COLOR
			{

				return fixed4(1,1,1,1);
			}
		ENDCG
		}
	}

	
}
