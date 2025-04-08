Shader "Nomo/2D Sprite Shader/GrayScale" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex("Sprite Texture", 2D) = "white" {}
        _GrayscaleAmount("Grayscale Amount", Range(0.0, 1.0)) = 1.0
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
            float _GrayscaleAmount;

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
                float gray = dot(texColor.rgb, fixed3(0.2989, 0.5870, 0.1140));
                texColor.rgb = lerp(texColor.rgb, fixed3(gray, gray, gray), _GrayscaleAmount);

                return texColor;
            }
            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}