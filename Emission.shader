Shader "Nomo/2D Sprite Shader/Emission" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionIntensity ("Emission Intensity", Range(0, 5)) = 1
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
            #pragma vertex vertFunction
            #pragma fragment fragFunction
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _EmissionColor;
            float _EmissionIntensity;

            v2f vertFunction(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            half4 fragFunction(v2f i) : SV_Target
            {
                half4 texColor = tex2D(_MainTex, i.uv) * i.color;
                half4 emission = _EmissionColor * _EmissionIntensity;
                return texColor + emission;
            }
            ENDCG
        }
    }
}
