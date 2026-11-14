----------------------------------------------------------------------------
--
-- Description :  Rolik_Bridge (adapted for Moment of Truth engine / MoTmod)
--
----------------------------------------------------------------------------

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
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Bridge\\camera.scm' );

    local ns = Level.NewCutScene( 'cherdak' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Bridge\\camera.scm' );
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

    local animObjects = { 'BRG1', 'BRG2', 'BRG3', 'BRG4', 'BRG5', 'BRG6', 'EXPL', 'sol2' };
    local ns = Level.InitCutScene( 0.0, 1070.0, animObjects, nil );

    CutScene.AddAnimInterval( ns, 'BRG1', 652.0, 1070.0 );
    CutScene.AddAnimInterval( ns, 'BRG2', 652.0, 1070.0 );
    CutScene.AddAnimInterval( ns, 'BRG3', 652.0, 1070.0 );
    CutScene.AddAnimInterval( ns, 'BRG4', 652.0, 1070.0 );
    CutScene.AddAnimInterval( ns, 'BRG5', 652.0, 1070.0 );
    CutScene.AddAnimInterval( ns, 'BRG6', 652.0, 1070.0 );
    CutScene.AddAnimInterval( ns, 'EXPL', 652.0, 1070.0 );

    local ef = "Levels\\Rolik_Bridge\\dynamite_explosion.sef";
    local sf = 652.0;

    CutScene.AddEffect( ns, ef, 'EX01', 'EXPL', 'expl_01', sf + 0.0, 1070.0 );
    CutScene.AddEffect( ns, ef, 'EX02', 'EXPL', 'expl_02', sf + 3.0, 1070.0 );
    CutScene.AddEffect( ns, ef, 'EX03', 'EXPL', 'expl_03', sf + 1.0, 1070.0 );
    CutScene.AddEffect( ns, ef, 'EX04', 'EXPL', 'expl_04', sf + 5.0, 1070.0 );
    CutScene.AddEffect( ns, ef, 'EX07', 'EXPL', 'expl_07', sf + 7.0, 1070.0 );
    CutScene.AddEffect( ns, ef, 'EX05', 'EXPL', 'expl_05', sf + 1.0, 1070.0 );
    CutScene.AddEffect( ns, ef, 'EX06', 'EXPL', 'expl_06', sf + 5.0, 1070.0 );

    -- water ploom
    local ef_water = "Levels\\Rolik_Bridge\\water_ploom.sef";
    CutScene.AddEffect( ns, ef_water, 'EXP1', 'EXPL', 'expl_ploom_01', sf + 110.0, 1070.0 );
    CutScene.AddEffect( ns, ef_water, 'EXP2', 'EXPL', 'expl_ploom_02', sf + 105.0, 1070.0 );
    CutScene.AddEffect( ns, ef_water, 'EXP3', 'EXPL', 'expl_ploom_03', sf + 119.0, 1070.0 );
    CutScene.AddEffect( ns, ef_water, 'EXP4', 'EXPL', 'expl_ploom_04', sf + 102.0, 1070.0 );
    CutScene.AddEffect( ns, ef_water, 'EXP5', 'EXPL', 'expl_ploom_03', sf + 149.0, 1070.0 );
    CutScene.AddEffect( ns, ef_water, 'EXP6', 'EXPL', 'expl_ploom_04', sf + 125.0, 1070.0 );

    CutScene.SetNotifyFunction( ns, "OnCutSceneNotify" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Bridge\\sound_17.ogg", true, false );

    local frameNotify = { { n = 150.0 },
                          { n = 270.0 },
                          { n = 330.0 },
                          { n = 390.0 },
                          { n = 510.0 },
                          { n = 571.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 990.0, 3.0 );

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
       Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.85, 0.5 );
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );

end;

--------------------------------------------------------
-- Name: Level.OnFinishCutScene()
-- Desc:
--------------------------------------------------------   
function Level.OnFinishCutScene( cutscene, interruped )

    if ( interruped == false ) then
       System:ConsoleCommand( 'l_loadlevel "rolik_lubyanka" 13' );
    else
       Level.NextLevel = "izyatie";
       System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    end;

end;
