Shader"Unlit/DisplacementShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _SecondColor ("Second Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
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
            uniform half4 _SecondColor;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;    


            struct VertexInput
            {
                float4 vertex: POSITION;
                float4 normal: NORMAL;
	            float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex: SV_POSITION;
	            float4 texcoord : TEXCOORD0;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                float displacement = tex2Dlod(_MainTex, v.texcoord* _MainTex_ST);
                o.vertex = UnityObjectToClipPos(v.vertex+(v.normal*displacement*0.1f));
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
                half4 color;
                color = tex2D(_MainTex, i.texcoord) * _Color + (1 - tex2D(_MainTex, i.texcoord)) * _SecondColor;
                            
                return color;
            }
            ENDCG
        }
    }
}
