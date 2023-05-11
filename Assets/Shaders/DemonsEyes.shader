Shader "Unlit/DemonsEyes"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PupilTex ("Pupil", 2D) = "white" {}
        _PupilOffset("Pupil Offset", Vector) = (0,0,0,0)
        _PupilSize("Pupil Size", Vector) = (0,0,0,0)
        _PupilCenterOffset("Pupil Center", Vector) = (0.5,0.5,0,0) //pupil must be in center when offset equal (0,0)
        _CloseEye("Close eye", Range(1,0)) = 0
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
                float2 centerUV : TEXCOORD1;
                float2 offset : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _PupilTex;
            float2 _PupilOffset;
            float2 _PupilSize;
            float2 _PupilCenterOffset;
            float _CloseEye;
            v2f vert (appdata v)
            {
                v2f o;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.centerUV = o.uv - 0.5f;
                o.offset = float2(_PupilOffset.x + _PupilCenterOffset.x, _PupilOffset.y + _PupilCenterOffset.y);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 back = tex2D(_MainTex, i.uv);
                float2 pupil_uv = float2(i.uv.x * _PupilSize.x - i.offset.x, 
                                         i.uv.y * _PupilSize.y - i.offset.y);
                float pupilMaskY = step(abs(pupil_uv.y - 0.5f), 0.5f);
                float pupilMaskX = step(abs(pupil_uv.x - 0.5f), 0.5f);
                fixed4 pupil = tex2D(_PupilTex, pupil_uv) * pupilMaskX * pupilMaskY;
                
                float eyeMaskY = step(abs(i.centerUV.y), _CloseEye);

                return (back * (1 - pupil.a) + pupil * pupil.a) * eyeMaskY;
            }
            ENDCG
        }
    }
}
