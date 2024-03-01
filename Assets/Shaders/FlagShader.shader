Shader"Unlit/FlagShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
        _Speed("Speed", float)=1
        _Frequency("Frequency", float)=0
        _Amplitude("Amplitude", float)=0
        
    }
    SubShader
    {
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;


            struct VertexInput
            {
                float4 vertex: POSITION;
	            float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex: SV_POSITION;
	            float4 texcoord : TEXCOORD0;
            };
            
            float4 vertexAnimFlag(float4 pos, float2 uv)
                {
                    pos.z=pos.z+sin((uv.x-_Time.y*_Speed)*_Frequency)*_Amplitude * uv.x;
                    
                    return pos;
                }
            
            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                v.vertex = vertexAnimFlag(v.vertex, v.texcoord);
	            o.vertex = UnityObjectToClipPos(v.vertex);
	            o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            

            half4 frag (VertexOutput i) : COLOR
            {
	            return tex2D(_MainTex, i.texcoord)* _Color;
}
            ENDCG
        }
    }
}
