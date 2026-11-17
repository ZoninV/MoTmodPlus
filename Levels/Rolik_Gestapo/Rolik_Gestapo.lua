----------------------------------------------------------------------------
--
-- Description :  Rolik_Gestapo (adapted for Moment of Truth engine / MoTmod)
--
----------------------------------------------------------------------------
MissionText =
	{
	-- Wunder
	Intro = "\205\224\246\232\241\242\241\234\224\255 \242\254\240\252\236\224 \227\228\229-\242\238 \226 \195\229\240\236\224\237\232\232...";
	};
  --function Rc()
    --    local ns = Level.FindCutScene( 'gestapo' );
    --    CutScene.Stop(ns);
  --end;

  --function Rp()
    --    local ns = Level.FindCutScene( 'gestapo' );
    --    CutScene.Reset(ns);
    --    CutScene.Play(ns,30.0);
  --end;

--------------------------------------------------------
-- Name: Level.CommonCutSceneInit()
-- Desc:
-------------------------------------------------------- 
function Level.CommonCutSceneInit( cutscene )

    Level.EnableLight( "PointLight04", true );
    Level.EnableLight( "PointLight03", true );

end;

--------------------------------------------------------
-- Name: Level.InitCutScene()
-- Desc:
-------------------------------------------------------- 
function Level.InitCutScene( startFrame, endFrame, animObjects, precacheFrame )
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Gestapo\\gestapo.scm' );

    local ns = Level.NewCutScene( 'gestapo' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Gestapo\\gestapo.scm' );
    CutScene.SetBlurEffect( ns, 0.12 );
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
    System:SetVar( "r_glow_r" , 1.2 );
    System:SetVar( "r_rimsunlightfactor" , 1.0 );

    Level.RolikCamera   = {};
    Level.FadeRolikTime = nil;

    local animObjects = { 'BULL', 'SSMN', 'SPYM', 'STUL' };
    local ns = Level.InitCutScene( 0.0, 1030.0, animObjects, nil );

    CutScene.AddAnimInterval( ns, 'STUL', 900.0, 925.0 );

    CutScene.SetNotifyFunction( ns, "OnCutSceneNotify" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Gestapo\\sound_05.ogg", true, false );

    local frameNotify = { { n = 100.0 },
                          { n = 200.0 },
                          { n = 400.0 },
                          { n = 443.0 },
                          { n = 487.0 },
                          { n = 565.0 },
                          { n = 617.0 },
                          { n = 737.0 },
                          { n = 809.0 },
                          { n = 896.0 },
                          { n = 924.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 950.0, 2.0 );

    Level.SetHudEffect( "noise" , true );
    Level.SetHudEffect( "lines" , true );
    Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.75, 10000.0 );
    Level.AddLargeMessage(MissionText.Intro , 10.0, 180, 180, 180 ); -- Wunder

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
       System:ConsoleCommand( 'l_loadlevel "rolik_lubyanka" 6' );
    else
       Level.NextLevel = "krasavitca";
       System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    end;

end;
