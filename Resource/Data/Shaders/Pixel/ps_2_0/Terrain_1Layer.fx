// <effectEd direct3D="9" profile="fx_2_0" shaderFlags="None, WarningsAreErrors" />

//--------------------------------------------------------------------------------------
// Global variables
//--------------------------------------------------------------------------------------
struct ConstantBuffer
{
	half4	Params;		//0: numTextures
	half4  FogColor;
};

ConstantBuffer g_cbuffer : register(c0);

sampler2D g_TexSampler0;			//blend map
sampler2D g_TexSampler1;

struct PS_IN
{
	half4 Diffuse : COLOR0;
	half4 Specular : COLOR1;
	half2 Tex0 : TEXCOORD0;		//base texture
	half3 Tex1 : TEXCOORD1;		//alpha map, z: fogAlpha
};


float4 main(PS_IN i) : COLOR
{
	float fogAlpha = i.Tex1.z;

	float4 alpha = tex2D(g_TexSampler0, i.Tex1.xy);	
	float4 color = tex2D(g_TexSampler1, i.Tex0.xy);
	float4 specular = i.Specular;
	
	//blend
	float x = (1.0f - alpha.a) * 0.3f + 0.69999999f;	
	color.rgb = color.rgb * x * i.Diffuse + (1.0f - alpha.a) * color.a * specular.rgb;	
	
	//fog
	color.rgb = color.rgb * (1.0f - fogAlpha) + g_cbuffer.FogColor.rgb * fogAlpha;

	color.a = 1.0f;
	
	return color;
}