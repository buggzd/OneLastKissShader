Shader "Custom/OneLastKiss"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("MainTexture",2D)="white"{}
        _OutLineMax("Outline Width Max", Range(0.01, 1)) = 0.24
        _OutLineMin("Outline Width Min", Range(0.01, 1)) = 0.2
        _OutLineWeight("Outline Width Weight", Range(0.01, 1)) = 0.5
       
    

    }
    SubShader
    {
        UsePass "Custom/SingleColor/singleColor"
        Tags { "RenderType" = "Opaque" }
        
        Pass{
            Name "Outline"
            Tags{"LightMode"="UniversalForward"}
            Cull Front
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            fixed4 _MainTex_ST;    

            half _OutLineMax;
            float _OutLineMin;
            float _OutLineWeight;

            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL0;
                float4 mainTex:TEXCOORD0;
                
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

                //get vertex diffuse color
                fixed3 worldNormal=normalize(UnityObjectToWorldNormal(v.normal));
                fixed3 worldLight=normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuse=_LightColor0.rgb*saturate(dot(worldNormal,-worldLight));
                //outline width effected by diffuse strength
                float outLineStrength=_OutLineWeight*_OutLineMax*(diffuse.r*0.299f+diffuse.g*0.587f+diffuse.b*0.114f+0.5)+(1-_OutLineWeight)*_OutLineMin;


                o.pos=UnityObjectToClipPos(v.vertex);
                o.normalOS=UnityObjectToWorldNormal(v.normal);
                float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
			    float2 extendDir = normalize(TransformViewToProjection(norm.xy));
			   
                float4 nearUpperRight = mul(unity_CameraInvProjection, float4(1, 1, UNITY_NEAR_CLIP_VALUE, _ProjectionParams.y));
                float aspect = abs(nearUpperRight.y / nearUpperRight.x);
                extendDir.x *= aspect;

                o.pos.xy += extendDir * (outLineStrength * 0.1);
                o.uv=TRANSFORM_TEX(v.mainTex,_MainTex);
                o.screenPos=ComputeScreenPos(o.pos);
                return o;
            }

            half4 frag(v2f i) : SV_TARGET
            {    
                float3 color= tex2D(_MainTex,i.screenPos.xy/i.screenPos.w).rgb;
                return half4(color,1);
            }

            ENDCG

        }
        
        
    }
}
