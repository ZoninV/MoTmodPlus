----------------------------------------------------------------------------
--
-- Description :  Rolik_Mashina (adapted for Moment of Truth engine / MoTmod)
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

    Level.EnableLight( "PointLight01", true );

end;

--------------------------------------------------------
-- Name: Level.InitCutScene()
-- Desc:
-------------------------------------------------------- 
function Level.InitCutScene( startFrame, endFrame, animObjects, precacheFrame )
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Mashina\\camera.scm' );

    local ns = Level.NewCutScene( 'cherdak' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Mashina\\camera.scm' );
    CutScene.SetBlurEffect( ns, 0.2 );
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

    System:SetVar( "r_glow" , true );
    System:SetVar( "r_glow_r" , 2.0 );
    System:SetVar( "r_rimsunlightfactor" , 1.0 );

    Level.RolikCamera   = {};
    Level.FadeRolikTime = nil;

    local animObjects = { 'STOG', 'ZOLL', 'PAPK' };
    local ns = Level.InitCutScene( 1.0, 940.0, animObjects, nil );

    CutScene.SetNotifyFunction( ns, "OnCutSceneNotify" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Mashina\\sound_10.ogg", true, false );

    local frameNotify = { { n = 156.0 },
                          { n = 523.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 890.0, 1.0 );

    Level.SetHudEffect( "noise" , true );
    Level.SetHudEffect( "lines" , true );
    Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.75, 10000.0 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 2.0 );

end;

--------------------------------------------------------
-- Name: Level.OnCutSceneNotify()
-- Desc:
--------------------------------------------------------   
function Level.OnCutSceneNotify( cutscene, cutsceneId, frame )

    Level.OnCommonNotification( cutscene, cutsceneId, frame );

end;

--------------------------------------------------------
-- Name: Level.OnFinishCutScene()
-- Desc:
--------------------------------------------------------   
function Level.OnFinishCutScene( cutscene, interruped )

    if ( interruped == false ) then
       System:ConsoleCommand( 'l_loadlevel "rolik_cherdak" 1' );
    else
       Level.NextLevel = "razvedshkola";
       System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    end;

end;
