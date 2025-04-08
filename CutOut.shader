Shader "Nomo/2D Sprite Shader/Cutout"  //Maquia Studio | Sajad Ahmadi Niat
{
	Properties
	{
		_BaseTexture ("Texture", 2D) = "white" {}
		[MaterialToggle] _InvertEffect("Invert Effect", float) = 0
		[MaterialToggle] _SnapToPixel ("Pixel Snap", Float) = 0
		[MaterialToggle] _FlipEffect ("AntiAliasing?(D3D)", Float) = 0
		[MaterialToggle] _FadeOutEffect ("Fade Out Effect", Float) = 0
		[MaterialToggle] _FadeInEffect ("Fade In Effect", Float) = 0
	}
	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vertexShader
			#pragma fragment fragmentShader
			#pragma multi_compile _ _INVERTEFFECT_ON
			#pragma multi_compile _ _SNAPTOPIXEL_ON
			#pragma multi_compile _ _FLIPEFFECT_ON
			#pragma multi_compile _ _FADEOUTEFFECT_ON
			#pragma multi_compile _ _FADEINEFFECT_ON

			#include "UnityCG.cginc"

			struct VertexInput
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
				half4 color : COLOR;
			};

			struct VertexOutput
			{
				float2 uv : TEXCOORD0;
				float2 screenPos : TEXCOORD1;
				float4 position : SV_POSITION;
				half4 color : COLOR;
			};

			VertexOutput vertexShader (VertexInput v)
			{
				VertexOutput o;
				o.position = UnityObjectToClipPos(v.position);

				#if defined(_SNAPTOPIXEL_ON)
				o.position = UnityPixelSnap (o.position);
				#endif

				o.uv = v.uv;
				o.screenPos = ((o.position.xy / o.position.w) + 1) * 0.5;
				o.color = v.color;
				
				return o;
			}
			
			sampler2D _BaseTexture;
			uniform sampler2D _CutoutMaskTexture;

			fixed4 fragmentShader (VertexOutput i) : SV_Target
			{
				fixed4 texColor = tex2D(_BaseTexture, i.uv) * i.color;

				#if defined(_FLIPEFFECT_ON)
        				i.screenPos.y = 1 - i.screenPos.y;
				#endif

				#if defined(_INVERTEFFECT_ON)
					texColor.a = texColor.a * tex2D(_CutoutMaskTexture, i.screenPos).a;
				#else
					texColor.a = texColor.a * (1 - tex2D(_CutoutMaskTexture, i.screenPos).a);
				#endif

				#if defined(_FADEOUTEFFECT_ON)
					texColor.a *= 1 - i.screenPos.y;
				#endif

				#if defined(_FADEINEFFECT_ON)
					texColor.a *= i.screenPos.y;
				#endif

				return texColor;
			}
			ENDCG
		}
	}
	Fallback "Transparent/VertexLit"
}