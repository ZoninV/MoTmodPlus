//-----------------------------------------------------------------------------------------
// Project lightmap + bend vertex position
//-----------------------------------------------------------------------------------------

#include "vs:vs_functions.vsh"

// <version:vs_1_1>


//-----------------------------------------------------------------------------------------

float4    FogParams      : register(c0);
float3    LightDir       : register(c1);
float4    LightDiffuse   : register(c2);
float4    LightAmbient   : register(c3);

float4    TClipPlane1     : register(c4);
float4    TCameraWorldPos : register(c5);
float4x4  TCameraViewProj : register(c6);

#if NUM_PROJECTORS > 0
float4    LightmapProject : register(c10);
#endif

float4    TDeformFactor1[12]: register(c11);
float4x3  TWorld[12]        : register(c24);

float4x4  TCameraView    : register(c80);
float4x4  TCameraProj    : register(c84);
float4x4  TInvCameraView : register(c90);

//-----------------------------------------------------------------------------------------

struct VS_OUTPUT
{
    float4 position : POSITION;
    float4 color    : COLOR0;

    float2 tex      : TEXCOORD0;

#if NUM_PROJECTORS > 0
    float2 tex2     : TEXCOORD1;
#endif

#ifdef FOG_ENABLED
    float  fog      : FOG;
#endif
};

//-----------------------------------------------------------------------------------------

VS_OUTPUT VS( float4 pos  : POSITION,
              float3 nor : NORMAL,
              float2 tex  : TEXCOORD0,
              float4 inds : BLENDINDICES )
{
    VS_OUTPUT vsOut;

    int4 index = D3DCOLORtoUBYTE4(inds);

#ifdef DEFORM_ENABLED

// Fix for driver bug
#ifdef BATCHING_ENABLED
#define BUG           
#endif

    float4 deform   = TDeformFactor1[index.r];

    float fBF       = max( pos.y, 0) * deform.y;
    fBF = fBF * fBF;

    float4 vP;
    vP.xz = deform.xz * fBF;

    float3 posWorld = mul( float4(pos.xyz,1) , TWorld[index.r] );
    float3 pw       = posWorld;

#ifdef BUG
    pw = mul( TCameraView, float4(posWorld.xyz,1) );    
#endif

    float fLength = length(pw.xyz);

#ifdef BUG
    pw.xyz = mul( TCameraView, float4( posWorld.x + vP.x,
                                       posWorld.y,
                                       posWorld.z + vP.z, 1) );
#else
    pw.xz = pw.xz + vP.xz;
#endif

    float3 vDirect = normalize(pw.xyz);
    float3 bend    = vDirect * fLength;

#ifdef BUG
 //   float3 wp = mul( TInvCameraView, float4(bend.xyz,1) );    
    float3 wp = bend;
#else
    float3 wp = bend;
#endif

#else // DEFORM_ENABLED

    float3 wp = mul( pos, TWorld[index.r] );

#endif

#ifdef BUG
    vsOut.position = mul( TCameraProj, float4(wp.xyz,1) );
#else
    vsOut.position = mul( TCameraViewProj, float4(wp.xyz,1.0f) );
#endif

#ifdef FOG_ENABLED
    vsOut.fog        = 1.0f; // CalculateFog( vsOut.position.z, FogParams );
#endif

    float3 norWorld  = mul( nor, (float3x3)(TWorld[index.r]) );

    float  I         = max( 0, dot( LightDir, norWorld ) );// * TDeformFactor1[index.r].w;
    vsOut.color      = saturate(LightDiffuse * I + LightAmbient) * TDeformFactor1[index.r].w;

    // Calculate squred distance to camera

#ifdef BUG
    float3 eyeVec    = wp.xyz;
#else
    float3 eyeVec    = wp.xyz - TCameraWorldPos.xyz;
#endif

    float distCamera = dot( eyeVec, eyeVec );

    vsOut.color.w    = 1.0f - ( distCamera - TClipPlane1.x ) * TClipPlane1.z;
    
    vsOut.tex        = tex;

#if NUM_PROJECTORS > 0

#error Do for BUG!

    vsOut.tex2.xy    = float2( wp.x * LightmapProject.x + LightmapProject.z,
                               wp.z * LightmapProject.y + LightmapProject.z );

#endif

    return vsOut;
}
