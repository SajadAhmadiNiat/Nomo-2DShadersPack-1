Shader "Nomo/2D Sprite Shader/Shadow" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _Texture ("Sprite Texture", 2D) = "white" {}
        _ShadowTint ("Shadow Tint", Color) = (0,0,0,0.5)
        _Offset ("Shadow Offset", Vector) = (0.1, -0.1, 0, 0)
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _ShadowAlpha ("Shadow Alpha", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }
        LOD 100

        Pass
        {
            Name "ShadowPass"
            Tags
            {
                "LightMode" = "Always"
            }

            ZWrite Off
            Cull Off
            Lighting Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vertFunction
            #pragma fragment fragFunction
            #include "UnityCG.cginc"

            struct inputData
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float4 col : COLOR;
            };

            struct outputData
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 col : COLOR;
            };

            sampler2D _Texture;
            float4 _Texture_ST;
            float4 _ShadowTint;
            float4 _Offset;
            float _ShadowAlpha;

            outputData vertFunction(inputData v)
            {
                outputData o;
                float4 shadowPosition = v.pos;
                shadowPosition.xy += _Offset.xy;
                o.pos = UnityObjectToClipPos(shadowPosition);
                o.uv = TRANSFORM_TEX(v.uv, _Texture);
                o.col = v.col;
                return o;
            }

            half4 fragFunction(outputData i) : SV_Target
            {
                half4 textureColor = tex2D(_Texture, i.uv);
                return half4(_ShadowTint.rgb, _ShadowTint.a * textureColor.a * _ShadowAlpha);
            }
            ENDCG
        }

        Pass
        {
            Name "SpritePass"
            Tags
            {
                "LightMode" = "Always"
            }

            ZWrite Off
            Cull Off
            Lighting Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vertFunctionSprite
            #pragma fragment fragFunctionSprite
            #include "UnityCG.cginc"

            struct inputDataSprite
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float4 col : COLOR;
            };

            struct outputDataSprite
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 col : COLOR;
            };

            sampler2D _Texture;
            float4 _Texture_ST;
            float4 _BaseColor;

            outputDataSprite vertFunctionSprite(inputDataSprite v)
            {
                outputDataSprite o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _Texture);
                o.col = v.col * _BaseColor;
                return o;
            }

            half4 fragFunctionSprite(outputDataSprite i) : SV_Target
            {
                half4 textureColor = tex2D(_Texture, i.uv);
                return textureColor * i.col;
            }
            ENDCG
        }
    }
}
