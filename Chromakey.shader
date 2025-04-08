Shader "Nomo/2D Sprite Shader/Chromakey"  //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _ColorToRemove ("Color to Remove", Color) = (1, 0, 0, 1)
        _Intensity ("Removal Intensity", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _ColorToRemove;
            float _Intensity;
            float4 _MainTex_ST;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);
                
                // Calculate color difference
                float diff = distance(col.rgb, _ColorToRemove.rgb);
                
                // Adjust alpha based on intensity
                col.a *= smoothstep(0.0, _Intensity, diff);
                
                return col;
            }
            ENDCG
        }
    }
    FallBack "Sprites/Default"
}
