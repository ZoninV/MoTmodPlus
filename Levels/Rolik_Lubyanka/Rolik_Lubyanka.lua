----------------------------------------------------------------------------
--
-- Description :  Roliks (Lubyanka - adapted for Moment of Truth engine / MoTmod)
--
--
----------------------------------------------------------------------------

  --function Rc()
    --    local ns = Level.FindCutScene( 'rolik01' );        
    --    CutScene.Stop(ns);
  --end;

  --function Rp()
    --    local ns = Level.FindCutScene( 'rolik01' );
    --    CutScene.Reset(ns);
    --    CutScene.Play(ns,30.0);
  --end;

  --function Rs(fr,fs)
    --    if fs == nil then fs = 30.0; end;
    --    local ns = Level.FindCutScene( 'rolik01' );
    --    CutScene.Stop(ns);
    --    CutScene.Reset(ns);
    --    CutScene.Play(ns,fs);
    --    CutScene.SetCurrentFrame( ns, fr );
  --end;

--------------------------------------------------------
-- Name: Level.CommonCutSceneInit()
-- Desc:
-------------------------------------------------------- 
function Level.CommonCutSceneInit( cutscene )

    local lights = { "PointLight01", "PointLight02", "PointLight05" };
    for i in lights do
      Level.EnableLight( lights[i], true );
      Level.SetLightParam( lights[i], "color", 0.8, 0.8, 0.8 );
    end;

    CutScene.MoveFlare( cutscene, "FL03", 24.95546 );
    CutScene.MoveFlare( cutscene, "FL05", 12.2808 );
    CutScene.MoveFlare( cutscene, "FL06", 12.48708 );
    Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.0, 10000.0 );

end;

--------------------------------------------------------
-- Name: Level.InitCutScene()
-- Desc:
-------------------------------------------------------- 
function Level.InitCutScene( startFrame, endFrame, animObjects, precacheFrame )
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Lubyanka\\rolik01.scm' );

    local ns = Level.NewCutScene( 'rolik01' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Lubyanka\\rolik01.scm' );
    CutScene.SetBlurEffect( ns, 0.12 );
    CutScene.Activate( ns );
    CutScene.EnableDeltaLimit( ns, false );
            
    if ( precacheFrame != nil ) then
      CutScene.PreCache( ns, precacheFrame );
    end;
     
    Level.CommonCutSceneInit( ns );    
    
    Level.PrecacheCutScenes();
    Level.SetHudEffect( "noise_small", true );
    
    if ( animObjects != nil ) then
    
      for i in animObjects do
        CutScene.AddAnimatedObject( ns, animObjects[i], false );      
      end;
    
    end;
     
    return ns;
    
end;

--------------------------------------------------------
-- Name: Level.OnLoaded()
-- Desc:
--------------------------------------------------------   
function Level.OnLoaded( cutsceneId )
     
     --System:ConsoleCommand( 'bind key:1 command "$ Rc();"' );
     --System:ConsoleCommand( 'bind key:2 command "$ Rp();"' );
     --System:ConsoleCommand( 'bind key:3 command "$ Rs(1,30);"' );

     System:SetVar( "r_glow" , true );
     System:SetVar( "r_glow_r" , 1.2 );
     System:SetVar( "r_rimsunlightfactor" , 1.0 );
      
     Level.RolikCamera   = {};
     Level.DofEffects    = nil;
     Level.FadeRolikTime = nil;
     
     Level.CutSceneId    = cutsceneId;
      
     if ( cutsceneId == 1 ) then
     
          Level.InitRolik_1();
     
     elseif ( cutsceneId == 2 ) then
     
          Level.InitRolik_2();
     
     elseif ( cutsceneId == 4 ) then
     
          Level.InitRolik_4();
          
     elseif ( cutsceneId == 6 ) then
     
          Level.InitRolik_6();
     
     elseif ( cutsceneId == 7 ) then
     
          Level.InitRolik_7();
          
     elseif ( cutsceneId == 9 ) then
     
          Level.InitRolik_9();
     
     elseif ( cutsceneId == 13 ) then
     
          Level.InitRolik_13();

     elseif ( cutsceneId == 14 ) then
     
          Level.InitRolik_14();
     
     end;
               
end;

--------------------------------------------------------
-- Name: Level.OnFinishCutScene()
-- Desc:
--------------------------------------------------------   
function Level.OnFinishCutScene( cutscene, interruped )
  
    if ( Level.CutSceneId == 1 ) then
      Level.NextLevel = "jagdpanther";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 2 ) then
      if ( interruped == false ) then
        System:ConsoleCommand( 'l_loadlevel "rolik_blindaj" 1' );
      else
        Level.NextLevel = "posilka";
        System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
      end;
    elseif ( Level.CutSceneId == 4 ) then
      if ( interruped == false ) then
        System:ConsoleCommand( 'l_loadlevel "rolik_gestapo" 1' );
      else
        Level.NextLevel = "krasavitca";
        System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
      end;
    elseif ( Level.CutSceneId == 6 ) then
      Level.NextLevel = "krasavitca";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 7 ) then
      Level.NextLevel = "hotel";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 9 ) then
      Level.NextLevel = "projecty";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 13 ) then
      Level.NextLevel = "izyatie";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 14 ) then      
      if ( interruped == false ) then
        System:ConsoleCommand( 'l_loadlevel "rolik_podvorotnya" 1' );
      else
        Level.NextLevel = "posolstvo";
        System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
      end;
    end;
    
    --print('OnFinishCutScene');
  
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
 
    --print('OnCommonNotification: ' .. tostring(cutsceneId) .. ' , ' .. tostring(frame) .. ' , ' .. tostring( Level.RolikCamera[cutsceneId] ) );
            
    if ( cutsceneId == 32768 and Level.FadeRolikTime != nil ) then
     
         Level.SetHudFadeOut( Level.FadeRolikTime );
         return;
             
    end;
    
    if ( Level.RolikCamera[cutsceneId] != nil ) then
       CutScene.SetCurrentFrame( cutscene, Level.RolikCamera[cutsceneId] );
    end;
 
    if ( Level.DofEffects != nil and Level.DofEffects[cutsceneId] != nil ) then
    
       Level.SetDOFPostFilter( Level.DofEffects[cutsceneId].t,
                               Level.DofEffects[cutsceneId].n,
                               Level.DofEffects[cutsceneId].c,
                               Level.DofEffects[cutsceneId].f );
    end;
    
end;

  
----------------------------------------------------------------------------
--
-- Description :  Rolik 1
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.InitRolik_1()
-- Desc:
--------------------------------------------------------   
function Level.InitRolik_1()
 
    -- BUILDING CUTSCENE
    
    local bs = Level.NewCutScene( 'building' , 0.0, 240.0 );
    
    Level.AddCinematicCamera( 'Levels\\Rolik_Lubyanka\\lubyanka_zdanie.scm' );
    
    CutScene.SetCamera( bs, 'Levels\\Rolik_Lubyanka\\lubyanka_zdanie.scm' );
    CutScene.SetBlurEffect( bs, 0.12 );
    CutScene.Activate( bs );
    CutScene.EnableDeltaLimit( bs, false );
                     
    Level.CommonCutSceneInit( bs );
    
    CutScene.AddNotify( bs, 9999, 230.0 );
    CutScene.SetNotifyFunction( bs, "OnNotify_Rolik1_Building" );
    CutScene.SetAudio( bs, "Levels\\Rolik_Lubyanka\\sound_01.ogg" , true, false );
        
    ------------------------------------------------------------
    -- STROGOV CUTSCENE
        
    Level.AddCinematicCamera( 'Levels\\Rolik_Lubyanka\\rolik01.scm' );

    local ns = Level.NewCutScene( 'rolik01' , 90.0, 4648.0 );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Lubyanka\\rolik01.scm' );    
    CutScene.SetBlurEffect( ns, 0.12 );
    CutScene.EnableDeltaLimit( ns, false );
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik1" );

    local animObjects = { 'YACH', 'STRG', 'DOOR', 'CIGR', 'BEEE', 'KONV' };
    
    if ( animObjects != nil ) then
    
      for i in animObjects do
        CutScene.AddAnimatedObject( ns, animObjects[i], false );      
      end;
    
    end;
       
    CutScene.AddAnimInterval( ns, 'DOOR', 1476.0, 1886.0 );
    CutScene.AddAnimInterval( ns, 'KONV', 90.0, 1826.0 );
    
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_smoke.sef", 'CSMK', 'CIGR', '', 90.0, 4648.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMK', 'YACH', 'smoke', 967.0, 3866.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSM2', 'YACH', 'smoke', 2206.0, 3866.0 );
    
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_01_a.ogg" , true, false );        
        
    -- Start
        
    Level.PrecacheCutScenes();
    
    Level.SetHudEffect( "noise" , true );
    Level.SetHudEffect( "lines" , true );
    Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.75, 10000.0 );
    Level.SetLargeMessage( '$020$470\203\243\225\255\237\234\224, 1951 \227.' , 10.0 , 180, 180, 180 );
    
    CutScene.Play( bs, 30.0 );    
    Level.SetHudFadeIn( 2.0 );
         
end;

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik1_Building()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik1_Building( cutscene, cutsceneId, frame )

    if ( cutsceneId == 9999 ) then
       Level.OnRolik1_StartMain();
       return;
    end;

end;

--------------------------------------------------------
-- Name: Level.OnRolik1_StartMain()
-- Desc:
--------------------------------------------------------   
function Level.OnRolik1_StartMain()

    local ns = Level.FindCutScene( 'rolik01' );
    if ( ns == nil ) then
       Level.OnFinishCutScene( Level.FindCutScene( 'building' ), false );
       return;
    end;
    
    local frameNotify = { { n = 738.0  },
                          { n = 884.0  },
                          { n = 1034.0 },
                          { n = 1089.0 },
                          { n = 1201.0 },
                          { n = 1269.0 },
                          { n = 1392.0 },
                          { n = 1839.0 },
                          { n = 2098.0 },
                          { n = 2163.0 },
                          { n = 2255.0 },
                          { n = 2781.0 },
                          { n = 2989.0 },
                          { n = 3382.0 },
                          { n = 3470.0 },
                          { n = 3654.0 },
                          { n = 4203.0 }
                        };
         
    Level.SetCameraFrameNotifys( ns, frameNotify );
    
    Level.SetHudEffect( "noise" , false );
    Level.SetHudEffect( "lines" , false );
    Level.SetHudEffect( "noise_small" , true );
    Level.ClearLargeMessages();
    
    CutScene.Activate( ns );   
    CutScene.Play( ns, 30.0 );   
    CutScene.PreCache( ns, 750.0 );
    Level.PrecacheCutScenes();
    Level.SetCutSceneFadeTime( ns, 4570.0, 3.0 );
       
end;

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik1()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik1( cutscene, cutsceneId, frame )
 
    if ( cutsceneId == 1 ) then
       Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.0, 5.0 );
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;
 
----------------------------------------------------------------------------
--
-- Description :  Rolik 2
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik2()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik2( cutscene, cutsceneId, frame )

    if ( cutsceneId == 32768 ) then
       Level.SetColorPostFilter( 1.0, 1.0, 1.0, 1.0, 0.5 );
    end;
   
    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_2()
-- Desc:
--------------------------------------------------------   
function Level.InitRolik_2()
 
    local animObjects = { 'YACH', 'STRG', 'CIGR', 'KONV' };
    
    local ns = Level.InitCutScene( 4649.0, 5894.0, animObjects, 4750.0 );
    CutScene.AddAnimInterval( ns, 'KONV', 4649.0, 4650.0 );
        
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_smoke.sef", 'CSMK', 'CIGR', '', 4649.0, 5894.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMK', 'YACH', 'smoke', 4707.0, 5894.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik2" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_02.ogg" , true, false );
                 
    local frameNotify = { { n = 5460.0 }
                        };
                        
    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 5774.0, 4.5 );

    CutScene.Play( ns, 30.0 );    
    Level.SetHudFadeIn( 2.0 );
        
end;


----------------------------------------------------------------------------
--
-- Description :  Rolik 4
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.InitRolik_4()
-- Desc:
--------------------------------------------------------   
function Level.InitRolik_4()
 
    local animObjects = { 'YACH', 'STRG', 'CIGR', 'CIGS', 'PORT', 'SPCH', 'KONV' };
            
    local ns = Level.InitCutScene( 5895.0, 7935.0, animObjects, 6050.0 );
        
    CutScene.AddAnimInterval( ns, 'KONV', 5895.0, 5896.0 );
    CutScene.AddAnimInterval( ns, 'PORT', 5895.0, 6630.0 );
    CutScene.AddAnimInterval( ns, 'SPCH', 5895.0, 6900.0 );
         
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_smoke.sef", 'CSMK', 'CIGR', '', 5895.0, 6657.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_smoke.sef", 'CSKK', 'CIGR', '', 6913.0, 7935.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\strgcig_smoke.sef", 'CSMS', 'CIGS', '', 6690.0, 7935.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMK', 'YACH', 'smoke', 6034.0, 7935.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMS', 'STRG', 'sgv_smoke', 6756.0, 6873.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSM2', 'STRG', 'sgv_smoke', 6818.0, 7935.0 );
    
    -- fire effect at 6637 - 6731, smoke before 6770, link to 'SPCH' 'match_one'
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\match_fire.sef", 'FIRE', 'SPCH', 'match_one', 6637.0, 6731.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_smoke.sef", 'FSMK', 'SPCH', 'match_one', 6701.0, 6821.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik4" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_04.ogg" , true, false );
         
    local frameNotify = { { n = 6306.0 },
                          { n = 6671.0 },
                          { n = 6873.0 },
                          { n = 6971.0 },
                          { n = 7036.0 },
                          { n = 7151.0 },
                          { n = 7307.0 },
                          { n = 7356.0 },
                          { n = 7500.0 }
                        };
                        
    Level.SetCameraFrameNotifys( ns, frameNotify );
    CutScene.AddNotify( ns, 254, 7800.0 );
    Level.SetCutSceneFadeTime( ns, 7860.0, 2.8 );

    CutScene.Play( ns, 30.0 );    
    Level.SetHudFadeIn( 2.0 );
        
end;

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik4()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik4( cutscene, cutsceneId, frame )

    if ( cutsceneId == 254 ) then
       Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.8, 0.5 );
       return;
    end;
    
    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;
 
----------------------------------------------------------------------------
--
-- Description :  Rolik 6
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik6()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik6( cutscene, cutsceneId, frame )
   
    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_6()
-- Desc:
--------------------------------------------------------
function Level.InitRolik_6()

    local animObjects = { 'STRG', 'CIGS', 'PEPL', 'KONV' };
    
    local ns = Level.InitCutScene( 7936.0, 8584.0, animObjects, 8050.0 );
           
    CutScene.AddAnimInterval( ns, 'KONV', 7936.0, 7937.0 );
    CutScene.AddAnimInterval( ns, 'PEPL', 7936.0, 7975.0 );
    
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\strgcig_smoke.sef", 'CSMK', 'CIGS', '', 7936.0, 8584.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMS', 'STRG', 'sgv_smoke', 8116.0, 8584.0 );
     
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik6" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_06.ogg" , true, false );

    local frameNotify = { { n = 8433.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 8500.0, 2.5 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 2.0 );

end;

----------------------------------------------------------------------------
--
-- Description :  Rolik 7
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik7()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik7( cutscene, cutsceneId, frame )
   
    if ( cutsceneId == 11 ) then
       Level.SetHudFadeOut( 1.7 );
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );

end;

--------------------------------------------------------
-- Name: Level.InitRolik_7()
-- Desc:
--------------------------------------------------------
function Level.InitRolik_7()

    local animObjects = { 'YACH', 'STRG', 'CIGR', 'CIGS', 'PEPL', 'BEEE', 'KONV', 'DOOR', 'FILE' };
    
    local ns = Level.InitCutScene( 8587.0, 10438.0, animObjects, 8750.0 );

    CutScene.AddAnimInterval( ns, 'PEPL', 8587.0, 8617.0 );
    CutScene.AddAnimInterval( ns, 'BEEE', 8587.0, 8607.0 );
    CutScene.AddAnimInterval( ns, 'KONV', 8587.0, 10146.0 );
    CutScene.AddAnimInterval( ns, 'DOOR', 9808.0, 10146.0 );
    CutScene.AddAnimInterval( ns, 'YACH', 8587.0, 10146.0 );
    CutScene.AddAnimInterval( ns, 'FILE', 10146.0, 10438.0 );
    
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_smoke.sef", 'CSMK', 'CIGR', '', 8587.0, 10438.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\strgcig_smoke.sef", 'CSMS', 'CIGS', '', 8587.0, 10438.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMK', 'YACH', 'smoke', 8989.0, 10146.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSM2', 'YACH', 'smoke', 9405.0, 10146.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\cig_breath.sef", 'BSMS', 'STRG', 'sgv_smoke', 8695.0, 10438.0 );
     
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik7" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_07.ogg" , true, false );

    local frameNotify = { { n = 8731.0  },
                          { n = 9054.0  },
                          { n = 9179.0  },
                          { n = 9591.0  },
                          { n = 9831.0  },
                          { n = 9963.0  },
                          { n = 10080.0 },
                          { n = 10149.0 },
                          { n = 10252.0 },
                          { n = 10316.0 },
                          { n = 10393.0 }
                        };
                          
    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 10390.0, 1.7 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 2.0 );

end;

----------------------------------------------------------------------------
--
-- Description :  Rolik 9
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik9()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik9( cutscene, cutsceneId, frame )

    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_9()
-- Desc:
--------------------------------------------------------
function Level.InitRolik_9()

    local animObjects = { 'YACH', 'STRG', 'CIGR', 'PEPL', 'BEEE', 'KONV' };
    
    local ns = Level.InitCutScene( 10440.0, 13779.0, animObjects, 10600.0 );
     
    CutScene.AddAnimInterval( ns, 'CIGR', 10440.0, 10450.0 );
    CutScene.AddAnimInterval( ns, 'PEPL', 10440.0, 10450.0 );
    CutScene.AddAnimInterval( ns, 'BEEE', 10440.0, 10450.0 );
    CutScene.AddAnimInterval( ns, 'KONV', 10440.0, 10450.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik9" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_09.ogg" , true, false );

    local frameNotify = { { n = 10746.0, j = 10748.0 },
                          { n = 11325.0 },
                          { n = 11870.0 },
                          { n = 12094.0 },
                          { n = 12615.0 },
                          { n = 12813.0 },
                          { n = 13205.0 },
                          { n = 13451.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );   
    Level.SetCutSceneFadeTime( ns, 13684.0, 3.0 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 5.0 );

end;

----------------------------------------------------------------------------
--
-- Description :  Rolik 13
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik13()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik13( cutscene, cutsceneId, frame )

    if ( cutsceneId == 5 or cutsceneId == 9 ) then
       CutScene.MoveFlare( cutscene, 'FL06' , 1200.0 );
       CutScene.MoveFlare( cutscene, 'FL05' , 12.17287 );
    elseif ( cutsceneId == 8 ) then
       CutScene.MoveFlare( cutscene, 'FL06' , 12.48708 );
       CutScene.MoveFlare( cutscene, 'FL05' , 12.2808 );  
    elseif ( cutsceneId == 10 ) then
       CutScene.MoveFlare( cutscene, 'FL06' , 1200.0 );
       CutScene.MoveFlare( cutscene, 'FL05' , 1200.0 );
       CutScene.MoveFlare( cutscene, 'FL03' , 1200.0 );
    elseif ( cutsceneId == 11 ) then
       CutScene.MoveFlare( cutscene, 'FL03' , 24.95546 );
       CutScene.MoveFlare( cutscene, 'FL05' , 12.16272 );
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_13()
-- Desc:
--------------------------------------------------------
function Level.InitRolik_13()

    local animObjects = { 'YACH', 'STRG', 'CIGS', 'CIGR', 'SPCH', 'PEPL', 'FILE', 'PORT', 'BEEE', 'KARN', 'KONV', 'DOOR' };
    
    local ns = Level.InitCutScene( 13783.0, 16235.0, animObjects, 13900.0 );
     
    CutScene.AddAnimInterval( ns, 'CIGR', 13783.0, 13793.0 );
    CutScene.AddAnimInterval( ns, 'SPCH', 13783.0, 13793.0 );
    CutScene.AddAnimInterval( ns, 'PEPL', 13783.0, 13793.0 );
    CutScene.AddAnimInterval( ns, 'FILE', 13783.0, 13793.0 );
    CutScene.AddAnimInterval( ns, 'BEEE', 14991.0, 15386.0 );
    CutScene.AddAnimInterval( ns, 'KARN', 13783.0, 14143.0 );
    CutScene.AddAnimInterval( ns, 'KONV', 13783.0, 14593.0 );
    CutScene.AddAnimInterval( ns, 'DOOR', 14232.0, 14593.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik13" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_13.ogg" , true, false );

    local frameNotify = { { n = 14069.0 },
                          { n = 14233.0 },
                          { n = 14386.0 },
                          { n = 14474.0 },
                          { n = 14530.0 },
                          { n = 14596.0 },
                          { n = 14688.0 },
                          { n = 14739.0 },
                          { n = 14886.0 },
                          { n = 14990.0 },
                          { n = 15386.0 },
                          { n = 15516.0 },
                          { n = 15766.0 },
                          { n = 16090.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );   
    Level.SetCutSceneFadeTime( ns, 16140.0, 3.0 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 4.0 );

end;

----------------------------------------------------------------------------
--
-- Description :  Rolik 14
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik14()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik14( cutscene, cutsceneId, frame )

    if ( cutsceneId == 1 or cutsceneId == 4 ) then
       CutScene.MoveFlare( cutscene, 'FL05' , 1200.0 );
       CutScene.MoveFlare( cutscene, 'FL06' , 1200.0 );
    elseif ( cutsceneId == 2 or cutsceneId == 6 ) then
       CutScene.MoveFlare( cutscene, 'FL05' , 12.2808 );
    elseif ( cutsceneId == 11 ) then
       CutScene.MoveFlare( cutscene, 'FL05' , 1200.0 ); 
       CutScene.MoveFlare( cutscene, 'FL03' , 1200.0 ); 
    elseif ( cutsceneId == 32768 ) then
       Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.85, 0.5 );
    end;

    Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_14()
-- Desc:
--------------------------------------------------------
function Level.InitRolik_14()

    local animObjects = { 'YACH', 'STRG', 'KARN', 'PORT', 'SPCH', 'CIGR', 'CIGS', 'BEEE', 'FILE', 'KONV', 'DOOR', 'STAK' };
    
    local ns = Level.InitCutScene( 16416.0, 18701.0, animObjects, 16550.0 );
     
    CutScene.AddAnimInterval( ns, 'PORT', 16416.0, 16446.0 );
    CutScene.AddAnimInterval( ns, 'SPCH', 16416.0, 16446.0 );
    CutScene.AddAnimInterval( ns, 'CIGR', 16416.0, 16446.0 );
    CutScene.AddAnimInterval( ns, 'CIGS', 16416.0, 16446.0 );
    CutScene.AddAnimInterval( ns, 'BEEE', 16416.0, 16446.0 );
    CutScene.AddAnimInterval( ns, 'FILE', 18282.0, 18387.0 );
    CutScene.AddAnimInterval( ns, 'KONV', 16416.0, 16882.0 );
    CutScene.AddAnimInterval( ns, 'DOOR', 16426.0, 16882.0 );
    CutScene.AddAnimInterval( ns, 'STAK', 16426.0, 18701.0 );

    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\stakan2.sef", 'STST', 'STAK', 'glassholder1', 16416.0, 18701.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Lubyanka\\stakan.sef", 'STSS', 'STAK', 'glassholder2', 16416.0, 18701.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik14" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Lubyanka\\sound_14.ogg" , true, false );

    local frameNotify = { { n = 16500.0, j = 16502.0 },
                          { n = 16713.0 },
                          { n = 16968.0 },
                          { n = 17217.0 },
                          { n = 17317.0 },
                          { n = 17671.0 },
                          { n = 17873.0 },
                          { n = 18119.0 },
                          { n = 18223.0 },
                          { n = 18299.0 },
                          { n = 18354.0, j = 18389.0 }
                        };

    Level.SetCameraFrameNotifys( ns, frameNotify );   
    Level.SetCutSceneFadeTime( ns, 18440.0, 8.5 );

    CutScene.Play( ns, 30.0 );
    Level.SetHudFadeIn( 3.0 );

end;

----------------------------------------------------------------------------
-- Backward-compatibility aliases
----------------------------------------------------------------------------
Level.Init_Rolik_1  = Level.InitRolik_1;
Level.Init_Rolik_2  = Level.InitRolik_2;
Level.Init_Rolik_4  = Level.InitRolik_4;
Level.Init_Rolik_6  = Level.InitRolik_6;
Level.Init_Rolik_7  = Level.InitRolik_7;
Level.Init_Rolik_9  = Level.InitRolik_9;
Level.Init_Rolik_13 = Level.InitRolik_13;
Level.Init_Rolik_14 = Level.InitRolik_14;
