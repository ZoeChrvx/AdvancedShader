Shader"Unlit/LineShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
        _SecondColor("Second Color", Color)=(1,1,1,1)
        _Start("Start",float)=0
        _Width("Width", float)=1
        _Multiple("Multiple", float)=0
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
            Blend srcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform half4 _SecondColor;
            uniform sampler2D _SecondTex;
            uniform float _Start;
            uniform float _Width;
            uniform float _Multiple;
            uniform float4 _MainTex_ST;
        

		    struct VertexInput
		    {
			    float4 vertex : POSITION;
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
	            o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);

                return o;
            }

            float drawLine(float2 uv, float start, float end, float lineNumber)
            {
                if (uv.x > start && uv.x < end)
                {
                    return _Color;
                }
                return _SecondColor;
            }

            half4 frag (VertexOutput i) : COLOR
            {
                half4 color;
                float pourcent = (1.0 / _Multiple) * 100.0;
                if ((i.texcoord.x * 100) % (2 * pourcent)<pourcent)
                {
                    color = tex2D(_MainTex, i.texcoord) * _Color;
                }
                else
                {
                    color = tex2D(_SecondTex, i.texcoord) * _SecondColor;
                }
	            return color;
            }
            ENDCG
        }
    }
}
