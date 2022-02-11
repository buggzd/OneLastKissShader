Shader "Custom/SingleColor"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
       
    }
    SubShader
    {

        Tags { "RenderType"="Opaque" }
       
        Pass{
            Name "singleColor"
        CGPROGRAM
        #pragma vertex vert;
        #pragma fragment frag;
         #include "UnityCG.cginc"
        half4 _Color;
        struct a2v{
            float4 vertex:POSITION;
        };
        struct v2f{
            float4 pos:SV_POSITION;
        };

        v2f vert(a2v v){
            v2f o;
            o.pos=UnityObjectToClipPos(v.vertex);
            return o;
        }
            
        half4 frag(v2f i):SV_TARGET{
            return _Color;
        }

        
        ENDCG
        }
        
    }
    
}
