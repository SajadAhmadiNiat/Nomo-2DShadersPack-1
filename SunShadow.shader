Shader "Nomo/2D Sprite Shader/Sun Shadow" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        [PerRendererData] _MainTex("Texture", 2D) = "white" {}
        _ShadowColor("Shadow Color", Color) = (0,0,0,1)
        _ShadowOffset("Shadow Offset", Vector) = (0.1, -0.1, 0, 0)
        _ShadowSoftness("Shadow Softness", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off
        Lighting Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
                float4 shadowOffset : TEXCOORD1;
            };

            sampler2D _MainTex;
            fixed4 _ShadowColor;
            float4 _ShadowOffset;
            float _ShadowSoftness;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                o.shadowOffset = float4(v.vertex.xyz + _ShadowOffset.xyz, 0);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv) * i.color;
                fixed4 shadowColor = _ShadowColor * _ShadowSoftness;
                shadowColor.a *= texColor.a;
                return texColor + shadowColor;
            }
            ENDCG
        }
    }
}