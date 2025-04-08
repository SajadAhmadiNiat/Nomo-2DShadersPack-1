Shader "Nomo/2D Sprite Shader/Halftone" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _PrimaryColor("Primary Color", Color) = (0.3, 1, 1, 1)
        _SecondaryColor("Secondary Color", Color) = (1, 0.3, 1, 1)
        _BackgroundColor("Background Color", Color) = (0, 0, 0, 1)
        _Threshold("Threshold", Range(0, 1)) = 0.5
        _Brightness("Brightness", Color) = (0.3, 0.59, 0.11)
        _BlockSize("Block Size", Range(0, 64)) = 8
        _Spacing("Spacing", Range(1, 3)) = 1.2
        _Gamma("Gamma", Range(0.1, 3)) = 1.0
        _Intensity("Intensity", Range(0, 1)) = 0.5
        _Contrast("Contrast", Range(0, 2)) = 1.0
        _Saturation("Saturation", Range(0, 2)) = 1.0
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
        
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;

            float _Threshold;
            fixed4 _PrimaryColor;
            fixed4 _SecondaryColor;
            fixed4 _Brightness;
            fixed4 _BackgroundColor;
            float _BlockSize;
            float _Spacing;
            float _Gamma;
            float _Intensity;
            float _Contrast;
            float _Saturation;

            float3 ApplyGamma(float3 color, float gamma)
            {
                return pow(color, float3(1.0 / gamma, 1.0 / gamma, 1.0 / gamma));
            }

            float3 ApplyContrast(float3 color, float contrast)
            {
                return saturate(lerp(float3(0.5, 0.5, 0.5), color, contrast));
            }

            float3 ApplySaturation(float3 color, float saturation)
            {
                float luminance = dot(color, float3(0.3, 0.59, 0.11));
                return lerp(float3(luminance, luminance, luminance), color, saturation);
            }

            float4 frag(v2f_img i) : COLOR
            {
                float4 c = tex2D(_MainTex, i.uv);
                c.rgb = ApplyGamma(c.rgb, _Gamma);
                c.rgb = ApplyContrast(c.rgb, _Contrast);
                c.rgb = ApplySaturation(c.rgb, _Saturation);
                float lum = c.r * _Brightness.r + c.g * _Brightness.g + c.b * _Brightness.b;
                lum = lerp(lum, lum * _Intensity, _Intensity);
                float4 output_color = _PrimaryColor;
                if (lum < _Threshold)
                {
                    output_color = _SecondaryColor;
                }

                float x = i.pos.x;
                float y = i.pos.y;
                float rad = (_Spacing * _BlockSize) / 2;
                float cx = (x - (x % _BlockSize)) + rad;
                float cy = (y - (y % _BlockSize)) + rad;
                float dx = x - cx;
                float dy = y - cy;
                float r = sqrt((dx * dx) + (dy * dy));
                float cr = (_BlockSize * lum) / 2;

                if (r > cr)
                {
                    output_color = _BackgroundColor;
                }

                return output_color;
            }

            ENDCG
        }
    }
}