Shader "Nomo/2D Sprite Shader/Hypnosis wave" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTexture ("Texture", 2D) = "white" {}
        _WaveDuration ("Wave Duration", float) = 6.0
        _WaveFrequency ("Wave Frequency", float) = 12.0
        _WaveColor ("Wave Color", Color) = (1, 1, 1, 1)
        _BackgroundColor ("Pattern Color", Color) = (0, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            
            #include "UnityCG.cginc"

            struct VertexOutput
            {
                float4 worldPosition: TEXCOORD1;
                float2 uv : TEXCOORD0;
                float4 clipPosition : SV_POSITION;
            };

            sampler2D _MainTexture;
            float _WaveDuration;
            float _WaveFrequency;
            float4 _WaveColor;
            float4 _BackgroundColor;

            VertexOutput vertexShader (appdata_base v)
            {
                VertexOutput o;
                o.clipPosition = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.worldPosition = v.vertex;
                return o;
            }

            fixed4 fragmentShader(VertexOutput i) : SV_Target
            {
                float2 wavePosition = i.worldPosition.xy * 2.0;
                float waveLength = length(wavePosition);
                float2 rippleUV = i.uv + wavePosition / waveLength * 3.0 * cos(waveLength * _WaveFrequency - _Time.y * 4.0);
                float waveAngle = fmod(_Time.y, _WaveDuration) * (UNITY_TWO_PI / _WaveDuration);
                float waveDelta = (sin(waveAngle) * 1.0) / 2.0;
                float2 finalUV = lerp(rippleUV, i.uv, waveDelta);
                fixed3 textureColor = tex2D(_MainTexture, finalUV);
                fixed3 waveEffect = lerp(_BackgroundColor.rgb, _WaveColor.rgb, waveDelta);
                fixed3 finalColor = lerp(textureColor, waveEffect, waveDelta);
                
                return fixed4(finalColor, 1.0);
            }
            ENDCG
        }
    }
}