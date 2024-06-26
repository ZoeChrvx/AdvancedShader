Shader"Unlit/WaterMoveShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _SecondColor("Second Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
        _Speed("Speed", float)=1
        _Frequency("Frequency", float)=0
        _Amplitude("Amplitude", float)=0
        _Height("Height", float)=0
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
            Blend SrcAlpha
            OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform half4 _SecondColor;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;
            uniform float _Height;


            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 normal: NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 displacement: COLOR;
                float4 texcoord : TEXCOORD0;
            };
                        
            float4 vertexAnimFlag(float4 pos, float2 uv)
                {
                    pos.y=pos.y+sin((uv.y-_Time.y*_Speed)*_Frequency)*(_Amplitude/100);
                    //pos.x=pos.x+sin((uv.x-_Time.y*_Speed)*_Frequency)*(_Amplitude/100);            
                    return pos;
                }
                        
            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                v.vertex = vertexAnimFlag(v.vertex,v.texcoord);
                float4 offset = (v.normal * tex2Dlod(_MainTex, v.texcoord*_MainTex_ST)*_Height);
                o.vertex = UnityObjectToClipPos(v.vertex + offset);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                //o.displacement = lerp(_Color,_SecondaryColor,v.vertex.y);
                float percentage = (v.vertex.y + offset.y) / _Height;
                o.displacement = (_Color * percentage + _SecondColor * (1-percentage));
                return o; 
            }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       

            half4 frag(VertexOutput i) : COLOR
            {
                half4 color;
                color = i.displacement;
                return color;
            }
            ENDCG
        }
    }
}

