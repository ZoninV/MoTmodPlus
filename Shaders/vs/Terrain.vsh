//-----------------------------------------------------------------------------------------
// Terrain shader
//-----------------------------------------------------------------------------------------

// <version:vs_1_1>


#include "vs:vs_functions.vsh"

//-----------------------------------------------------------------------------------------

float4   LightmapCoords           : register(c0);
float4x4 TWorldViewProjection     : register(c1);
float4   FogParameters            : register(c5);

#if (NUM_PROJECTORS > 0)

float4x4 TShadowMap_1             : register(c6);
float4x4 TShadowMap_2             : register(c10);

#endif

#if (NUM_POINTLIGHTS > 0)

struct PointLight_t
{
   float4 Position;
   float4 Diffuse;
   float4 Atten;
};

PointLight_t PointLights[NUM_POINTLIGHTS] : register(c14);

#endif

#ifdef BATCHING_ENABLED
float4 TClipPlane1                : register(c90);
#endif

//-----------------------------------------------------------------------------------------

struct VS_OUTPUT
{
    float4 position : POSITION;
    float4 color    : COLOR0;
    float2 tex1     : TEXCOORD0;
    float2 tex2     : TEXCOORD1;

#if NUM_TEXCOORDS > 2
    float2 tex3     : TEXCOORD2;

#if NUM_PROJECTORS > 0
    float4 proj1    : TEXCOORD3;
#endif

#if NUM_PROJECTORS > 1
    float4 proj2    : TEXCOORD4;
#endif
    
#else

#if NUM_PROJECTORS > 0
    float4 proj1    : TEXCOORD2;
#endif

#if NUM_PROJECTORS > 1
    float4 proj2    : TEXCOORD3;
#endif

#endif

#ifdef BATCHING_ENABLED

 #if NUM_TEXCOORDS > 2
   #if NUM_PROJECTORS > 0
     #if NUM_PROJECTORS > 1
        float2 detailTex : TEXCOORD5;
     #else
        float2 detailTex : TEXCOORD4;
     #endif
   #else
     float2 detailTex : TEXCOORD3;
   #endif
  
 #else // NUM_TEXCOORDS
  #if NUM_PROJECTORS > 0 
    #if NUM_PROJECTORS > 1
     float2 detailTex : TEXCOORD4;
    #else
     float2 detailTex : TEXCOORD3;
    #endif
  #else
    float2 detailTex : TEXCOORD2;
  #endif
 #endif // NUM_TEXCOORDS   
  

#endif // BATCHING_ENABLED

    float  fog      : FOG;   
};

//-----------------------------------------------------------------------------------------

VS_OUTPUT VS( float4 pos   : POSITION,
              float3 nor   : NORMAL,
              float4 color : COLOR0,
              float2 tex   : TEXCOORD0,
              float2 tex2  : TEXCOORD1 )
{
    VS_OUTPUT vsOut;

    vsOut.position  = mul( pos, TWorldViewProjection );
   
    vsOut.fog       = 1.0f; // 1.0f - (vsOut.position.z - FogParameters.x) * FogParameters.z;

    vsOut.tex1      = tex;
    vsOut.tex2      = tex2;

#ifdef LIGHTING_ENABLED

    vsOut.color     = float4(0.0f,0.0f,0.0f,0.0f);

#if NUM_POINTLIGHTS > 0

    for( int i = 0; i < NUM_POINTLIGHTS; i++ )
       vsOut.color += PointLight_Attenuation( PointLights[i].Position,
                                              pos, nor, 
                                              PointLights[i].Atten,
                                              PointLights[i].Diffuse );
#endif

    vsOut.color.a   = color.a;

#else

    vsOut.color     = color;

#endif

#if NUM_TEXCOORDS > 2
    vsOut.tex3      = float2( pos.x * LightmapCoords.x + LightmapCoords.z,
                              pos.z * LightmapCoords.y + LightmapCoords.z );
#endif

#if NUM_PROJECTORS > 0
    vsOut.proj1     = mul( pos, TShadowMap_1 );
#endif

#if NUM_PROJECTORS > 1
    vsOut.proj2     = mul( pos, TShadowMap_2 );
#endif

#ifdef BATCHING_ENABLED

    vsOut.color.xyz = saturate( (vsOut.position.z - TClipPlane1.x) * TClipPlane1.z );
    vsOut.detailTex = tex2 * TClipPlane1.w;    

#endif

    return vsOut;
}

