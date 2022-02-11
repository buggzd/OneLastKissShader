Shader "Custom/OneLastKissEye"
{
    Properties
    {
        _MainTex("MainTexture",2D)="white"{}
        _MaskTex("MaskTexture",2D)="white"{}
        _RClip("_RClip",Range(-1,1))=0.5
        _GClip("_GClip",Range(-1,1))=0.5
        _BClip("_BClip",Range(-1,1))=0.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Pass{
            Name "OnelastKissEye"
           
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            fixed4 _MainTex_ST;   
            sampler2D _MaskTex;
            fixed4 _MaskTex_ST; 
            float _RClip;  
            float _GClip;  
            float _BClip;  
          
            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL0;

                float4 mainTex:TEXCOORD0;
                float4 maskTex:TEXCOORD1;
                
            };

            struct v2f{
                float4 pos:SV_POSITION;
                float3 normalOS:TEXCOORD0;
                float2 uv:TEXCOORD1;
                float4 screenPos : TEXCOORD2;
            };

            v2f vert(a2v v) 
            {
                v2f o;
                o.pos=UnityObjectToClipPos(v.vertex);
                o.uv=TRANSFORM_TEX(v.maskTex,_MainTex);
                o.screenPos=ComputeScreenPos(o.pos);
                return o;
            }

            half4 frag(v2f i) : SV_TARGET
            {    
                float3 color= tex2D(_MainTex,i.screenPos.xy/i.screenPos.w).rgb;
                float3 mask=tex2D(_MaskTex,i.uv)-float3(_RClip,_GClip,_BClip);
                mask=round(mask);
                color=color*(1-mask.b);
                return half4(color+half3(mask.b,mask.b,mask.b),1);
            }

            ENDCG

        }
        
        
    }
}
