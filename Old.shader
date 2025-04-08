Shader "Nomo/2D Sprite Shader/Old" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex("Sprite Texture", 2D) = "white" {}
        _Intensity("Intensity", Range(0.0, 1.0)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

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
            };

            sampler2D _MainTex;
            float _Intensity;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);
                float3 sepiaColor;
                sepiaColor.r = dot(texColor.rgb, fixed3(0.393, 0.769, 0.189));
                sepiaColor.g = dot(texColor.rgb, fixed3(0.349, 0.686, 0.168));
                sepiaColor.b = dot(texColor.rgb, fixed3(0.272, 0.534, 0.131));
                texColor.rgb = lerp(texColor.rgb, sepiaColor, _Intensity);

                return texColor;
            }
            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}