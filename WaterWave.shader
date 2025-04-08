Shader "Nomo/2D Sprite Shader/Water Wave" //Maquia Studio | Sajad Ahmadi Niat
{
    Properties
    {
        [PerRendererData] _MainColor("Tint", Color) = (1,1,1,1)
        [NoScaleOffset] _DistortionMap("Distortion Texture", 2D) = "white" {}

        _RefractionAmountX("X Refraction", Range(-0.1,0.1)) = 0.01
        _RefractionAmountY("Y Refraction", Range(-0.1,0.1)) = 0.01

        _DistortionSpeedX("X Scroll Speed", Range(-0.1,0.1)) = -0.1
        _DistortionSpeedY("Y Scroll Speed", Range(-0.1,0.1)) = 0.1
        
        _DistortionScaleX("X Scale", float) = 1.0
        _DistortionScaleY("Y Scale", float) = 1.0

        _Duration("Duration", float) = 10
    }

    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSrpiteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha

        GrabPass { }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                half2 uv : TEXCOORD0;
                half2 grabUv : TEXCOORD1;
            };

            fixed4 _MainColor;
            sampler2D _GrabTexture;
            float _DistortionSpeedX;
            float _DistortionSpeedY;
            float _RefractionAmountX;
            float _RefractionAmountY;
            float _DistortionScaleX;
            float _DistortionScaleY;
            float _Duration;
			sampler2D _DistortionMap;


            v2f vert (appdata IN)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);

                #if UNITY_UV_STARTS_AT_TOP
                    float uvScale = -1.0;
                #else
                    float uvScale = 1.0;
                #endif
                
                float time = _Time.y * (1.0 / _Duration);
                OUT.grabUv = (float2(OUT.vertex.x, OUT.vertex.y * uvScale) + OUT.vertex.w) * 0.5;


                OUT.uv = IN.uv.xy;
                OUT.uv += time * float2(_DistortionSpeedX, _DistortionSpeedY);

                OUT.grabUv.x -= _RefractionAmountX / 2;
                OUT.grabUv.y -= _RefractionAmountY / 2;

                OUT.color = IN.color * _MainColor;


                return OUT;
            }
            
            fixed4 frag(v2f IN) : SV_Target
            {
                float2 distortionScale = float2(_DistortionScaleX, _DistortionScaleY);
                float2 refraction = float2(_RefractionAmountX, _RefractionAmountY);

                float2 distortionSample = tex2D(_DistortionMap, distortionScale * IN.uv).xy;

				fixed4 grabbedColor = tex2D(_GrabTexture, IN.grabUv + (refraction * distortionSample));
                fixed4 finalColor = grabbedColor * IN.color;
                return finalColor;
            }
            ENDCG
        }
    }
}