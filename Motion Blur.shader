Shader "Nomo/2D Sprite Shader/Motion Blur" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurAmount ("Blur Amount", Float) = 0.5
        _BlurDirection ("Blur Direction", Vector) = (1, 0, 0, 0)
        _BlurSamples ("Blur Samples", Int) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _BlurAmount;
            float4 _BlurDirection;
            int _BlurSamples;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                float2 direction = normalize(_BlurDirection.xy) * _BlurAmount;
                for (int j = 1; j < _BlurSamples; ++j)
                {
                    float weight = float(j) / float(_BlurSamples);
                    color += tex2D(_MainTex, i.uv + direction * weight);
                    color += tex2D(_MainTex, i.uv - direction * weight);
                }
                color /= (2 * _BlurSamples - 1);
                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
