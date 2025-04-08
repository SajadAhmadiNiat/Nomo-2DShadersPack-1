Shader "Nomo/2D Sprite Shader/BlendGradient" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        [PerRendererData] _MainTex("Texture", 2D) = "white" {}
        _Top_Color("Top Color",Color) = (1,1,1,1)
        _Mid_Color("Mid Color",Color) = (1,1,1,1)
        _Bot_Color("Bot Color",Color) = (1,1,1,1)
        _Scale("Middle", Range(0, 1)) = 1
        [MaterialToggle] PixelSnap("Pixel snap", Float) = 0

    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos: SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Top_Color;
            fixed4 _Mid_Color;
            fixed4 _Bot_Color;
            float _Scale;
            
            
            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            fixed4 SampleSpriteTexture(float2 uv)
            {
                fixed4 color = tex2D(_MainTex, uv);

#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
                if (_AlphaSplitEnabled)
                    color.a = tex2D(_AlphaTex, uv).r;
#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED

                return color;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                 fixed4 texColor = SampleSpriteTexture(i.texcoord);
                 fixed4 c = lerp(_Bot_Color, _Mid_Color, i.texcoord.y / _Scale) * step(i.texcoord.y, _Scale);
                 c += lerp(_Mid_Color, _Top_Color, (i.texcoord.y - _Scale) / (1 - _Scale)) * step(_Scale, i.texcoord.y);
                 
                 c.rgb *= texColor.a;
                 return fixed4(c.rgb*texColor.rgb,texColor.a);
            }
            ENDCG
        }
    }
}