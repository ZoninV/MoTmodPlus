----------------------------------------------------------------------------
--
-- Description :  rolik_svalka (adapted for Moment of Truth engine / MoTmod)
--
----------------------------------------------------------------------------

  --function Rc()
    --    local ns = Level.FindCutScene( 'cherdak' );
    --    CutScene.Stop(ns);
  --end;

  --function Rp()
    --    local ns = Level.FindCutScene( 'cherdak' );
    --    CutScene.Reset(ns);
    --    CutScene.Play(ns,30.0);
  --end;

--------------------------------------------------------
-- Name: Level.CommonCutSceneInit()
-- Desc:
-------------------------------------------------------- 
function Level.CommonCutSceneInit( cutscene )

end;

--------------------------------------------------------
-- Name: Level.InitCutScene()
-- Desc:
-------------------------------------------------------- 
function Level.InitCutScene( startFrame, endFrame, animObjects, precacheFrame )
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Svalka\\camera.scm' );

    local ns = Level.NewCutScene( 'cherdak' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Svalka\\camera.scm' );
    CutScene.SetBlurEffect( ns, 0.15 );
    CutScene.Activate( ns );
    CutScene.EnableDeltaLimit( ns, false );
            
    if ( precacheFrame != nil ) then
      CutScene.PreCache( ns, precacheFrame );
    end;
     
    Level.CommonCutSceneInit( ns );    
    
    if ( animObjects != nil ) then
      for i in animObjects do
        CutScene.AddAnimatedObject( ns, animObjects[i], false );      
      end;
    end;

    Level.PrecacheCutScenes();
     
    return ns;
    
end;

--------------------------------------------------------
-- Name: Level.SetCutSceneFadeTime()
-- Desc:
--------------------------------------------------------   
function Level.SetCutSceneFadeTime( cutscene, frame, fadeTime )
 
    Level.FadeRolikTime = fadeTime;
    
    if ( fadeTime != nil ) then    
       CutScene.AddNotify( cutscene, 32768, frame );    
    end;
 
end;

--------------------------------------------------------
-- Name: Level.SetCameraFrameNotifys()
-- Desc:
--------------------------------------------------------   
function Level.SetCameraFrameNotifys( cutscene, frameNotifys )
 
    local notify = 1;
    
    Level.RolikCamera = {};
    
    for i in frameNotifys do
    
      CutScene.AddNotify( cutscene, notify, frameNotifys[i].n );
      
      if ( frameNotifys[i].j == nil ) then      
         Level.RolikCamera[notify] = frameNotifys[i].n + 1.0;      
      else        
         Level.RolikCamera[notify] = frameNotifys[i].j;            
      end;

      notify = notify + 1;     
    
    end;
 
end;

--------------------------------------------------------
-- Name: Level.OnCommonNotification()
-- Desc:
--------------------------------------------------------   
function Level.OnCommonNotification( cutscene, cutsceneId, frame )
            
    if ( cutsceneId == 32768 and Level.FadeRolikTime != nil ) then
         Level.SetHudFadeOut( Level.FadeRolikTime );
         return;
    end;
    
    if ( Level.RolikCamera[cutsceneId] != nil ) then
       CutScene.SetCurrentFrame( cutscene, Level.RolikCamera[cutsceneId] );
    end;
    
end;

--------------------------------------------------------
-- Name: Level.OnLoaded()
-- Desc:
--------------------------------------------------------   
function Level.OnLoaded()

    System:SetVar( "r_shadowmapboxf" , 2.0 );
    System:SetVar( "r_glow" , true );
    System:SetVar( "r_glow_r" , 1.5 );
    System:SetVar( "r_glow_b" , 230 );
    System:SetVar( "r_rimsunlightfactor" , 1.0 );

    Level.RolikCamera   = {};
    Level.FadeRolikTime = nil;

    local animObjects = { 'STRG', 'LKMT', 'SOL1', 'SOL2' };
    local ns = Level.InitCutScene( 160.0, 1099.0, animObjects, nil );

    CutScene.AddAnimInterval( ns, 'SOL1', 518.0, 923.0 );
    CutScene.AddAnimInterval( ns, 'SOL2', 518.0, 923.0 );

    local is = 160.0;
    local ie = 1099.0;

    CutScene.AddEffect( ns, "Levels\\Rolik_Svalka\\smoke.sef", 'STRM', 'LKMT', 'loc_stream_big', is, ie );

    local ef = "Levels\\ProjectY\\tube_smoke03.sef";
    CutScene.AddEffect( ns, ef, 'STRE', 'LKMT', 'loc_stream_small_01', is, ie );
    CutScene.AddEffect( ns, ef, 'STEE', 'LKMT', 'loc_stream_small_02', is, ie );

    CutScene.SetNotifyFunction( ns, "OnCutSceneNotify" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Svalka\\sound_12.ogg", true, false );

    local frameNotify = { { n = 399.0 },
                          { n = 517.0 },
                          { n = 923.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 975.0, 3.0 );

    Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.0, 10000.0 );

    Level.PrecacheCutScenes();
    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 3.0 );

end;

--------------------------------------------------------
-- Name: Level.OnCutSceneNotify()
-- Desc:
--------------------------------------------------------   
function Level.OnCutSceneNotify( cutscene, cutsceneId, frame )

    if ( cutsceneId == 32768 ) then
       Level.OnCommonNotification( cutscene, cutsceneId, frame );
       return;
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );

    if ( cutsceneId == 2 ) then
       Level.SetHudOverlay( "binocular" );
    else
       Level.SetHudOverlay( "none" );
    end;

end;

--------------------------------------------------------
-- Name: Level.OnFinishCutScene()
-- Desc:
--------------------------------------------------------   
function Level.OnFinishCutScene( cutscene, interruped )

    Level.NextLevel = "svalka";
    System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );

end;
