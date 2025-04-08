Shader "Nomo/2D Sprite Shader/Outline" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTexture ("Sprite Texture", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineThickness ("Outline Thickness", Range(1, 10)) = 2
        [MaterialToggle] _UseGradient ("Use Gradient Outline", Float) = 0
        _GradientColor1 ("Gradient Color 1", Color) = (1, 0, 0, 1)
        _GradientColor2 ("Gradient Color 2", Color) = (0, 0, 1, 1)
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _OutlineColor;
            float4 _MainTexture_TexelSize;
            float _OutlineThickness;
            float _UseGradient;
            float4 _GradientColor1;
            float4 _GradientColor2;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
                fixed4 spriteColor = tex2D(_MainTexture, i.uv);
                float2 thickness = _OutlineThickness * _MainTexture_TexelSize.xy;
                fixed leftPixel = tex2D(_MainTexture, i.uv + float2(-thickness.x, 0)).a;
                fixed upPixel = tex2D(_MainTexture, i.uv + float2(0, thickness.y)).a;
                fixed rightPixel = tex2D(_MainTexture, i.uv + float2(thickness.x, 0)).a;
                fixed bottomPixel = tex2D(_MainTexture, i.uv + float2(0, -thickness.y)).a;
                fixed outline = max(max(leftPixel, upPixel), max(rightPixel, bottomPixel)) - spriteColor.a;
                float4 outlineColor = _OutlineColor;
                if (_UseGradient)
                {
                    float gradientFactor = i.uv.x;
                    outlineColor = lerp(_GradientColor1, _GradientColor2, gradientFactor);
                }
                return lerp(spriteColor, outlineColor, outline);
            }
            ENDCG
        }
    }
    Fallback "Sprites/Default"
}