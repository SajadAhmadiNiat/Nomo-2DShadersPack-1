Shader "Nomo/2D Sprite Shader/Glitch" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _ColorIntensity ("Color Intensity", Range(0, 1)) = 0.5
        _DispIntensity ("Displacement Intensity", Range(0, 1)) = 0.5
        _DispProbability ("Displacement Probability", Range(0, 1)) = 0.5
        _ColorProbability ("Color Probability", Range(0, 1)) = 0.5
        _DispGlitchOn ("Enable Displacement Glitch", Float) = 1
        _ColorGlitchOn ("Enable Color Glitch", Float) = 1
        _WrapDispCoords ("Wrap Displacement Coords", Float) = 1
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

        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
            };

            sampler2D _MainTex;
            float _ColorIntensity;
            float _DispIntensity;
            float _DispProbability;
            float _ColorProbability;
            float _DispGlitchOn;
            float _ColorGlitchOn;
            float _WrapDispCoords;

            float rand(float seed)
            {
                return frac(sin(seed) * 43758.5453);
            }

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;

                OUT.color = IN.color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                float timePositionVal = _Time.y;
                float dispGlitchRandom = rand(timePositionVal);
                float colorGlitchRandom = rand(timePositionVal + 1);
                float rShiftRandom = (rand(timePositionVal) - 0.5) * _ColorIntensity;
                float gShiftRandom = (rand(timePositionVal + 1) - 0.5) * _ColorIntensity;
                float bShiftRandom = (rand(timePositionVal + 2) - 0.5) * _ColorIntensity;
                if(dispGlitchRandom < _DispProbability && _DispGlitchOn == 1)
                {
                    IN.texcoord.x += (rand(floor(IN.texcoord.y * 5.0)) - 0.5) * _DispIntensity;
                    if(_WrapDispCoords == 1)
                    {
                        IN.texcoord.x = fmod(IN.texcoord.x, 1);
                    }
                    else
                    {
                        IN.texcoord.x = clamp(IN.texcoord.x, 0, 1);
                    }
                }

                fixed4 normalC = tex2D(_MainTex, IN.texcoord);
                fixed4 rShifted = tex2D(_MainTex, IN.texcoord + float2(rShiftRandom, 0));
                fixed4 gShifted = tex2D(_MainTex, IN.texcoord + float2(gShiftRandom, 0));
                fixed4 bShifted = tex2D(_MainTex, IN.texcoord + float2(bShiftRandom, 0));
                fixed4 c;

                if(colorGlitchRandom < _ColorProbability && _ColorGlitchOn == 1)
                {
                    c.r = rShifted.r;
                    c.g = gShifted.g;
                    c.b = bShifted.b;
                    c.a = (rShifted.a + gShifted.a + bShifted.a) / 3;
                }
                else
                {
                    c = normalC;
                }

                c.rgb *= IN.color.rgb;
                c.a *= IN.color.a;

                return c;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
