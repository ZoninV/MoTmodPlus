----------------------------------------------------------------------------
--
-- Description :  Rolik_Final (adapted for Moment of Truth engine / MoTmod)
--
----------------------------------------------------------------------------

  --function Rc()
    --    local ns = Level.FindCutScene( 'final' );
    --    CutScene.Stop(ns);
  --end;

  --function Rp()
    --    local ns = Level.FindCutScene( 'final' );
    --    CutScene.Reset(ns);
    --    CutScene.Play(ns,30.0);
  --end;

--------------------------------------------------------
-- Name: Level.CommonCutSceneInit()
-- Desc:
-------------------------------------------------------- 
function Level.CommonCutSceneInit( cutscene )

    Level.EnableLight( 'LIT1', true );
    Level.EnableLight( 'LIT2', true );
    Level.EnableLight( "PointLight03", false );
    Level.EnableLight( "PointLight06", false );

end;

--------------------------------------------------------
-- Name: Level.InitCutScene()
-- Desc:
-------------------------------------------------------- 
function Level.InitCutScene( startFrame, endFrame, animObjects, precacheFrame )
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Final\\camera.scm' );

    local ns = Level.NewCutScene( 'final' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Final\\camera.scm' );
    CutScene.SetBlurEffect( ns, 0.1 );
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
-- Name: Level.SetNightLighting()
-- Desc:
--------------------------------------------------------   
function Level.SetNightLighting()

    local ns = Level.FindCutScene( 'final' );
    if ( ns == nil ) then
      return;
    end;

    CutScene.SetLighting( ns, 'NOLT' );
    CutScene.SetLightColor( ns, 'LIT1' , 0.5, 0.5, 0.5 );
    CutScene.SetLightColor( ns, 'LIT2' , 0.0, 0.0, 0.0 );

    -- reset audio sync compensation
    CutScene.EnableAudioSync( ns, false );
    CutScene.EnableAudioSync( ns, true );

end;

--------------------------------------------------------
-- Name: Level.OnLoaded()
-- Desc:
--------------------------------------------------------   
function Level.OnLoaded()

    System:SetVar( "r_glow" , true );
    System:SetVar( "r_glow_r" , 1.0 );

    if ( System:GetVar( 'r_shadowvolumes' ) == true ) then
       System:SetVar( "r_rimsunlightfactor" , 0.8 );
    else
       System:SetVar( "r_rimsunlightfactor" , 0.3 );
    end;

    Level.RolikCamera   = {};
    Level.FadeRolikTime = nil;

    local animObjects = { 'STOG', 'KONV', 'DOOR', 'PAPR', 'MEDL', 'PIST', 'PILW' };
    local ns = Level.InitCutScene( 1.0, 3700.0, animObjects, nil );

    CutScene.AddAnimInterval( ns, 'DOOR', 2779.0, 3454.0 );

    CutScene.SetNotifyFunction( ns, "OnCutSceneNotify" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Final\\sound_16.ogg", true, false );

    local frameNotify = { { n = 220.0  },
                          { n = 297.0  },
                          { n = 389.0  },
                          { n = 538.0  },
                          { n = 652.0  },
                          { n = 762.0  },
                          { n = 871.0  },
                          { n = 1042.0 },
                          { n = 1340.0 },
                          { n = 1392.0 },
                          { n = 1524.0 },
                          { n = 1633.0 },
                          { n = 1804.0 },
                          { n = 1966.0 },
                          { n = 2340.0, j = 2418.0 },
                          { n = 2570.0 },
                          { n = 2618.0 },
                          { n = 2689.0 },
                          { n = 2741.0 },
                          { n = 2807.0 },
                          { n = 2961.0 },
                          { n = 3048.0 },
                          { n = 3106.0 },
                          { n = 3170.0 },
                          { n = 3363.0 },
                          { n = 3394.0 },
                          { n = 3415.0, j = 3436.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 3490.0, 0.05 );

    -- switch flare (paired notifications), 300-on, 400-off
    CutScene.AddNotify( ns, 400, 1163.15 );
    CutScene.AddNotify( ns, 300, 1199.55 );
    CutScene.AddNotify( ns, 401, 1365.10 );
    CutScene.AddNotify( ns, 402, 1424.70 );
    CutScene.AddNotify( ns, 302, 1519.10 );

    Level.SetHudEffect( "noise_small" , true );
    Level.SetColorPostFilter( 0.55, 0.55, 0.35, 0.35, 10000.0 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 3.0 );

end;

--------------------------------------------------------
-- Name: Level.OnCutSceneNotify()
-- Desc:
--------------------------------------------------------   
function Level.OnCutSceneNotify( cutscene, cutsceneId, frame )

    if ( cutsceneId == 3 or cutsceneId == 11 ) then
       Level.SetLightParam( 'LIT1' , 'color' , 0.8, 0.8, 0.8 );
    elseif ( cutsceneId == 4 ) then
       Level.SetLightParam( 'LIT1' , 'color' , 1.0, 1.0, 1.0 );
    end;

    if ( cutsceneId == 10 ) then
       CutScene.MoveFlare( cutscene, 'AAAA' , -1.68294 );
    end;

    if ( cutsceneId >= 300 and cutsceneId < 500 ) then
       if ( cutsceneId < 400 ) then
          CutScene.MoveFlare( cutscene, 'AAAA' , -1.68294 );
       else
          CutScene.MoveFlare( cutscene, 'AAAA' , 1200.0 );
       end;
       return;
    end;

    -- dream on
    if ( cutsceneId == 15 or cutsceneId == 22 or cutsceneId == 24 or cutsceneId == 26 ) then
       if ( cutsceneId == 15 ) then
          Level.SetNightLighting();
       end;
       Level.SetHudEffect( "noise" , false );
       Level.SetHudEffect( "noise" , true );
       CutScene.SetLighting( cutscene, 'KLIT' );
       CutScene.SetBlurEffect( cutscene, 0.5 );
       Level.SetColorPostFilter( 0.85, 0.85, 1.0, 1.0, 10000.0 );

    -- dream off
    elseif ( cutsceneId == 21 or cutsceneId == 23 or cutsceneId == 25 or cutsceneId == 27 ) then
       Level.SetColorPostFilter( 0.55, 0.55, 0.35, 0.35, 10000.0 );
       Level.SetHudEffect( "noise" , false );
       Level.SetHudEffect( "noise_small" , true );
       CutScene.SetLighting( cutscene, 'KNOR' );
       System:SetVar( 'r_glow_r', 1.0 );
       CutScene.SetBlurEffect( cutscene, 0.1 );
    end;

    if ( cutsceneId == 27 ) then
       CutScene.Play( cutscene, 120.0 );
       CutScene.EnableAudioSync( cutscene, false );
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );

end;

--------------------------------------------------------
-- Name: Level.OnFinishCutScene()
-- Desc:
--------------------------------------------------------   
function Level.OnFinishCutScene( cutscene, interruped )

    if ( interruped == false ) then
       System:ConsoleCommand( 'l_loadlevel "rolik_addon" 1' );
    else
       Level.NextLevel = "airbase";
       System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    end;

end;
