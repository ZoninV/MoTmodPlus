----------------------------------------------------------------------------
--
-- Description :  Roliks
--
--
----------------------------------------------------------------------------

  --function Rc()

    --    local ns = Level.FindCutScene( 'final' );        
    --    CutScene.Stop(ns);
  --end;

  --function Rp()
    --    local ns = Level.FindCutScene( 'final' );
        --CutScene.Reset(ns);
      --  CutScene.Play(ns,30.0);
  --end;

  --function Rs(fr,fs)
    --    if fs == nil then fs = 30.0; end;
      --  local ns = Level.FindCutScene( 'final' );
      --  CutScene.Stop(ns);
      --  CutScene.Reset(ns);
      --  CutScene.Play(ns,fs);
      --  CutScene.SetCurrentFrame( ns, fr );
  --end;

--------------------------------------------------------
-- Name: Level.CommonCutSceneInit()
-- Desc:
-------------------------------------------------------- 
function Level.CommonCutSceneInit( cutscene )

    Level.EnableLight( "FireLight" , false );
    Level.EnableLight( "LampaKor"  , false );
    Level.EnableLight( 'WLIT' , false );
    Level.EnableLight( 'PLIT' , false );
    Level.EnableLight( 'KRL1' , false );
    Level.EnableLight( 'LIT4' , false );
    Level.EnableLight( 'LampaF02' , false );
    
    CutScene.MoveFlare( cutscene, 'FFLR' , -195.0 );      
    Level.EnableLight( "Fonar" , false );
    Level.EnableLight( 'FONR' , false );
    
    local obj = Level.FindWorldObject( 'MANN' );
    if ( obj != nil ) then
      Level.SetWorldObjectPos( obj, 0.0, -90.0, 0.0 );    
    end;
    
end;

--------------------------------------------------------
-- Name: Level.InitCutScene()
-- Desc:
-------------------------------------------------------- 
 function Level.InitCutScene( startFrame, endFrame, animObjects, precacheFrame )
 
    Level.AddCinematicCamera( 'Levels\\Rolik_Addon\\camera.scm' );

    local ns = Level.NewCutScene( 'final' , startFrame, endFrame );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Addon\\camera.scm' );
    CutScene.SetBlurEffect( ns, 0.5 );
    CutScene.Activate( ns );
    CutScene.EnableDeltaLimit( ns, false );
            
    if ( precacheFrame != nil ) then
      CutScene.PreCache( ns, precacheFrame );
    end;
     
    Level.CommonCutSceneInit( ns );    
    
    Level.PrecacheCutScenes();
    Level.SetHudEffect("noise_small", true );
    
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

     System:SetVar("r_rimsunlightfactor" , 1.0 );
      
     Level.RolikCamera   = {};
     Level.DofEffects    = nil;
     Level.FadeRolikTime = nil;
     
     Level.CutSceneId    = cutsceneId;
      
     if ( cutsceneId == 1 ) then
     
          Level.InitRolik_1();
     
     elseif ( cutsceneId == 2 ) then
     
          Level.InitRolik_2();
     
     elseif ( cutsceneId == 3 ) then
     
          Level.InitRolik_3();
     
     elseif ( cutsceneId == 4 ) then
     
          Level.InitRolik_4();
          
     elseif ( cutsceneId == 5 ) then
     
          Level.InitRolik_5();
     
     elseif ( cutsceneId == 6 ) then
     
          Level.InitRolik_6();
          
     elseif ( cutsceneId == 7 ) then
     
          Level.InitRolik_7();
     
     elseif ( cutsceneId == 8 ) then
     
          Level.InitRolik_8();
     
     end;
               
  end;

--------------------------------------------------------
-- Name: Level.OnFinishCutScene()
-- Desc:
--------------------------------------------------------   
 function Level.OnFinishCutScene( cutscene, interruped )
  
    if ( Level.CutSceneId == 1 ) then
      Level.NextLevel = "airbase";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 2 ) then
      Level.NextLevel = "uboat";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 3 ) then
      Level.NextLevel = "whitehead";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 4 ) then
      Level.NextLevel = "dora";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 5 ) then
      Level.NextLevel = "pgift";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 6 ) then
      Level.NextLevel = "cowboy";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 7 ) then
      Level.NextLevel = "otstupniki";
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 2' );
    elseif ( Level.CutSceneId == 8 ) then      
      Level.NextLevel = nil;
      System:ConsoleCommand( 'l_loadlevel "gamemenu" 3' );
    end;
    
    --print('OnFinishCutScene');
  
 end;
  
--------------------------------------------------------
-- Name: Level.SetCutSceneFade()
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
    
    CutScene.SetCurrentFrame( cutscene, Level.RolikCamera[cutsceneId] );
 
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
 
    -- HOUSE CUTSCENE
    
    local house = Level.NewCutScene( 'house' , 1.0, 3500.0 );
    
    Level.AddCinematicCamera( 'Levels\\Rolik_Addon\\camera_f.scm' );
    
    CutScene.SetCamera( house, 'Levels\\Rolik_Addon\\camera_f.scm' );
    CutScene.SetBlurEffect( house, 0.5 );
    CutScene.Activate( house );
    CutScene.EnableDeltaLimit( house, false );
                     
    Level.SetHudEffect("noise_small", true );
    
    Level.CommonCutSceneInit( house );
        
    local houseAnimObjects = { 'STR1' , 'PAPR', 'MEDL', 'PILW', 'KONV', 'DOOR', 'PST1' };
    
    for i in houseAnimObjects do
       CutScene.AddAnimatedObject( house, houseAnimObjects[i], false );
    end;
    
    CutScene.AddAnimInterval( house, 'DOOR', 2779.0, 3454.0 );    
    CutScene.SetNotifyFunction( house, "OnNotify_Rolik1" );
    
    local frameNotify = { { n = 220.0  },
                          { n = 297.0  },
                          { n = 389.0 },
                          { n = 538.0 },
                          { n = 652.0 },
                          { n = 762.0 },
                          { n = 871.0 },
                          { n = 1042.0 },
                          { n = 1340.0 },
                          { n = 1440.0, j = 1525.0 },
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

    Level.DofEffects = { { t = 1, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 10.0, f = 20.0  },
                         { t = 1, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 30.0, f = 40.0  },
                         { t = 1, n = 0.0 , c = 30.0, f = 40.0  },
                         { t = 1, n = 0.0 , c = 10.0, f = 20.0  },
                         { t = 1, n = 0.0 , c = 30.0, f = 40.0  },
                         { t = 1, n = 0.0 , c = 80.0, f = 150.0  }, --
                         { t = 1, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 70.0, f = 100.0  },
                         { t = 1, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 30.0, f = 40.0  },
                         { t = 1, n = 0.0 , c = 50.0, f = 70.0  },    
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 50.0, f = 60.0  },
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 200.0, f = 300.0  },
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 200.0, f = 300.0  },
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 20.0, f = 30.0  },
                         { t = 1, n = 0.0 , c = 60.0, f = 100.0  },
                         { t = 1, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 10.0, f = 20.0  }                         
                       };

    Level.SetDOFPostFilter( 1, 0.0, 90.0, 150.0 );
                                                                                                         
    -- flare on/off ( off = 1000, on = 1001 )
    
    CutScene.AddNotify( house, 1000, 1166.0 );
    CutScene.AddNotify( house, 1001, 1170.0 );
    CutScene.AddNotify( house, 1000, 1203.5 );
    CutScene.AddNotify( house, 1001, 1341.2 );
            
    CutScene.SetAudio( house, "Levels\\Rolik_Addon\\sound_01_1.ogg" , true, false );        
    Level.SetCameraFrameNotifys( house, frameNotify );
        
    ------------------------------------------------------------
    -- SUIT CUTSCENE
        
    Level.AddCinematicCamera( 'Levels\\Rolik_Addon\\camera.scm' );

    local ns = Level.NewCutScene( 'final' , 2.0, 437.0 );

    CutScene.SetCamera( ns, 'Levels\\Rolik_Addon\\camera.scm' );    
    CutScene.SetBlurEffect( ns, 0.5 );
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik1_SuitScene" );

    local animObjects = { 'STOG' , 'PAPK', 'PIST' };
    
    if ( animObjects != nil ) then
    
      for i in animObjects do
        CutScene.AddAnimatedObject( ns, animObjects[i], false );      
      end;
    
    end;
       
    -- flash light 1000 - on, 1001 - off
    
    CutScene.AddNotify( ns, 999, 3.0 );
    CutScene.AddNotify( ns, 1000, 7.0 );
    CutScene.AddNotify( ns, 1001, 10.0 );
    CutScene.AddNotify( ns, 1000, 21.0 );
    CutScene.AddNotify( ns, 1001, 24.0 );
    CutScene.AddNotify( ns, 1000, 34.0 );
    CutScene.AddNotify( ns, 1001, 37.0 );
    
    CutScene.AddEffect( ns, "Levels\\Rolik_Addon\\muzzle_pistol.sef", 'FIR1', 'EFFT', '', 7.0, 10.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Addon\\muzzle_pistol.sef", 'FIR2', 'EFFT', '', 21.0, 24.0 );
    CutScene.AddEffect( ns, "Levels\\Rolik_Addon\\muzzle_pistol.sef", 'FIR3', 'EFFT', '', 34.0, 37.0 );
    
    CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_01_2.ogg" , true, false );        
        
    -- Start
        
    Level.PrecacheCutScenes();
--    CutScene.SetCurrentFrame( house, 3000 );
    
    -- Skip duplicate house intro (already played in Rolik_Final) and start Suit Scene directly:
    if ( System:GetVar('r_shadowvolumes') == true ) then
       System:SetVar("r_rimsunlightfactor" , 1.0 );
    else
       System:SetVar("r_rimsunlightfactor" , 0.6 );
    end;
    Level.CommonCutSceneInit( ns );
    Level.OnRolik1_StartSuit();       
         
 end
  
--------------------------------------------------------
-- Name: Level.OnNotify_Rolik1()
-- Desc:
--------------------------------------------------------   
 function Level.OnNotify_Rolik1( cutscene, cutsceneId, frame )
 
   if ( cutsceneId == 3 or cutsceneId == 10 ) then
      Level.SetLightParam( 'LIT1' , 'color' , 0.8, 0.8, 0.8 );   
   elseif ( cutsceneId == 4 ) then
      Level.SetLightParam( 'LIT1' , 'color' , 1.0, 1.0, 1.0 );   
   end;
   
   if ( cutsceneId == 1000 ) then
   
      CutScene.MoveFlare( cutscene, 'AAAA' , -30.0 );
      return;
   
   elseif ( cutsceneId == 1001 ) then
   
      CutScene.MoveFlare( cutscene, 'AAAA' ,  30.0 );
      return;
   
   end;
   
   if ( cutsceneId == 13 ) then   
     if ( System:GetVar('r_shadowvolumes') == true ) then
        System:SetVar("r_rimsunlightfactor" , 1.0 );
     else
        System:SetVar("r_rimsunlightfactor" , 0.6 );
     end;
   elseif ( cutsceneId == 8 ) then
     System:SetVar("r_rimsunlightfactor" , 0.3 );
   elseif ( cutsceneId == 9 ) then   
     if ( System:GetVar('r_shadowvolumes') == true ) then
        System:SetVar("r_rimsunlightfactor" , 0.6 );
     else
        System:SetVar("r_rimsunlightfactor" , 0.3 );
     end;
   end;
   
   -- dream on
   
   if ( cutsceneId == 14 or cutsceneId == 23 or cutsceneId == 25 or cutsceneId == 21 ) then
   
      if ( cutsceneId == 14 ) then
        CutScene.SetLighting( cutscene, 'NOLT' );
        CutScene.SetLightColor( cutscene, 'LIT1' , 0.5, 0.5, 0.5 );
        CutScene.SetLightColor( cutscene, 'LIT2' , 0.0, 0.0, 0.0 ); 
        
        -- reset syncompensate..
        
        CutScene.EnableAudioSync( cutscene, false );
        CutScene.EnableAudioSync( cutscene, true );
        
      elseif ( cutsceneId == 23 ) then
        CutScene.SetLightColor( cutscene, 'LIT3' , 0.0, 0.0, 0.0 );    
      end;
            
      CutScene.SetLighting( cutscene, 'KLIT' );
      Level.SetColorPostFilter( 0.85, 0.85, 1.0, 1.0, 10000.0 );
      
   elseif ( cutsceneId == 20 or cutsceneId == 22 or cutsceneId == 24 or cutsceneId == 26 ) then
   
      Level.SetColorPostFilter( 0.85, 0.85, 1.0, 0.0, 10000.0 );
      CutScene.SetLighting( cutscene, 'KNOR' );
      
      if ( cutsceneId == 26 ) then
               
         Level.SetHudFadeOut( 1.0, 255, 255, 255 );
         Level.AddTimer( 'ROL2', "OnRolik1_StartSuit", 1.0, false );
      
      end;
         
   end;
   
   -- dream off
         
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
 end

--------------------------------------------------------
-- Name: Level.OnRolik1_StartSuit()
-- Desc:
--------------------------------------------------------   
function Level.OnRolik1_StartSuit()

   local ns = Level.FindCutScene('final');
   if ( ns == nil ) then
      return;
   end;
   
   local frameNotify = { { n = 112.0 },
                         { n = 162.0 },
                         { n = 336.0 }
                       };
    
   Level.SetDOFPostFilter( 1, 0.0, 60.0, 90.0 );

   Level.DofEffects = { { t = 1, n = 0.0 , c = 30.0, f = 40.0  },
                        { t = 1, n = 0.0 , c = 60.0, f = 120.0 },
                        { t = 1, n = 0.0 , c = 20.0, f = 30.0  }
                       };
        
     
   Level.SetCameraFrameNotifys( ns, frameNotify );
   
   CutScene.Activate(ns);   
   CutScene.Play( ns, 30.0 );   
   CutScene.PreCache( ns, 180.0 );
   Level.PrecacheCutScenes();
   Level.SetCutSceneFadeTime( ns, 380.0, 1.7 );
       
end;

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik1_SuitScene()
-- Desc:
--------------------------------------------------------   
 function Level.OnNotify_Rolik1_SuitScene( cutscene, cutsceneId, frame )
            
   if ( cutsceneId == 999 ) then
      Level.SetHudFadeIn( -1.0, 0, 0, 0 );
      return;   
   elseif ( cutsceneId == 1000 ) then
      Level.SetHudFadeIn( -1.0, 0, 0, 0 );
      Level.EnableLight( "FireLight" , true );
      return;
   elseif ( cutsceneId == 1001 ) then
      Level.EnableLight( "FireLight" , false );
      return;
   end;
      
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
 end
 
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

   if ( cutsceneId == 1 ) then
     System:SetVar("r_rimsunlightfactor" , 0.0 );
   elseif ( cutsceneId == 2 ) then
     System:SetVar("r_rimsunlightfactor" , 2.0 );
   elseif ( cutsceneId == 5 ) then
     Level.SetLightParam('Lampa' , 'color' , 0.15, 0.15, 0.15 );   
   elseif ( cutsceneId == 6 ) then
     System:SetVar("r_rimsunlightfactor" , 0.8 );
     Level.SetLightParam('Lampa' , 'color' , 0.3, 0.3, 0.3 );   
   end;
   
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
 end;

--------------------------------------------------------
-- Name: Level.InitRolik_2()
-- Desc:
--------------------------------------------------------   
 function Level.InitRolik_2()
 
    local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'CHIR' };
    
    local ns = Level.InitCutScene( 447.0, 1600.0, animObjects, 580.0 );
        
    CutScene.AddAnimInterval( ns, 'CHIR', 447.0, 457.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik2" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_02.ogg" , true, false );
   
    if ( System:GetVar("cl_subtitles") == true ) then
      CutScene.LoadSubTitles( ns, "Levels\\Rolik_Addon\\rolik_2.shad" );
    end;
             
    local frameNotify = { { n = 554.0  },
                          { n = 944.0  },
                          { n = 1104.0 },
                          { n = 1154.0 },
                          { n = 1303.0 },
                          { n = 1346.0 }
                        };
                        
        
    Level.DofEffects = { { t = 1, n = 0.0 , c = 80.0, f = 90.0  },
                         { t = 1, n = 0.0 , c = 50.0, f = 100.0 },
                         { t = 3, n = 20.0, c = 40.0, f = 60.0  },
                         { t = 1, n = 0.0,  c = 50.0, f = 70.0 },
                         { t = 1, n = 0.0,  c = 30.0, f = 40.0 },
                         { t = 1, n = 0.0,  c = 20.0, f = 30.0 }    
                       };
                       
    --Level.DofEffects = nil;    
                        
    Level.SetDOFPostFilter( 1, 0.0, 80.0, 100.0 );
    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 1535.0, 2.0 );

    CutScene.Play( ns, 30.0 );    
    Level.SetHudFadeIn( 2.0 );
        
 end;


----------------------------------------------------------------------------
--
-- Description :  Rolik 3
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.InitRolik_3()
-- Desc:
--------------------------------------------------------   
 function Level.InitRolik_3()
 
    local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'BULT', 'CHIR' };
            
    local ns = Level.InitCutScene( 1570.0, 3395.0, animObjects, 1650.0 );
        
    CutScene.AddAnimInterval( ns, 'PAPK', 1570.0, 1580.0 );
    CutScene.AddAnimInterval( ns, 'PHON', 1570.0, 1580.0 );
    CutScene.AddAnimInterval( ns, 'CHIR', 1570.0, 1640.0 );
         
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik3" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_03.ogg" , true, false );
    
    if ( System:GetVar("cl_subtitles") == true ) then
      CutScene.LoadSubTitles( ns, "Levels\\Rolik_Addon\\rolik_3.shad" );
    end;
    
    local frameNotify = { { n = 1627.0  },
                          { n = 1938.0  },
                          { n = 2083.0 },
                          { n = 2831.0, j = 2850.0 },
                          { n = 3245.0 }                          
                        };
                        
        
    Level.DofEffects = { { t = 1, n = 0.0 , c = 50.0, f = 90.0  },
                         { t = 2, n = 0.0 , c = 40.0, f = 50.0  },
                         { t = 1, n = 0.0 , c = 50.0, f = 90.0  },
                         { t = 1, n = 0.0,  c = 20.0, f = 30.0  },
                         { t = 3, n = 10.0, c = 3.0 , f = 5.0   }                         
                       };
                       
    --Level.DofEffects = nil;    
                        
    Level.SetDOFPostFilter( 1, 0.0, 20.0, 30.0 );
    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 3364.0, 1.0 );
    
    CutScene.Play( ns, 30.0 );    
    Level.SetHudFadeIn( 2.0 );
        
 end;
 
--------------------------------------------------------
-- Name: Level.OnNotify_Rolik3()
-- Desc:
--------------------------------------------------------   
 function Level.OnNotify_Rolik3( cutscene, cutsceneId, frame )
 
   if ( cutsceneId == 2 or cutsceneId == 4 ) then
     System:SetVar("r_rimsunlightfactor" , 0.5 );
     
     if ( cutsceneId == 4 ) then
       Level.SetLightParam('GLIT' , 'color' , 0.8, 0.8, 0.8 );     
     end;
     
   elseif ( cutsceneId == 3 ) then
     System:SetVar("r_rimsunlightfactor" , 1.0 );
   elseif ( cutsceneId == 5 ) then
     System:SetVar("r_rimsunlightfactor" , 0.75 );
     System:SetVar("r_rimsunlightpower" , 8.0 );
     Level.SetLightParam('GLIT' , 'color' , 1.0, 1.0, 1.0 );
   end;
   
   if ( frame >= 2831.0 ) then   
      Level.SetLightParam( 'Lampa' , 'color' , 0.15, 0.15, 0.15 );   
   end;
   
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
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
 
    local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'BULT', 'SHTS', 'TABL', 'SKRP', 'CHIR' };
            
    local ns = Level.InitCutScene( 3413.0, 4900.0, animObjects, 3560.0 );
        
    CutScene.AddAnimInterval( ns, 'PAPK', 3413.0, 3420.0 );
    CutScene.AddAnimInterval( ns, 'PHON', 3413.0, 3420.0 );
    CutScene.AddAnimInterval( ns, 'PIST', 3413.0, 3420.0 );
    CutScene.AddAnimInterval( ns, 'CHIR', 3413.0, 3420.0 );
         
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik4" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_04.ogg" , true, false );
    
    if ( System:GetVar("cl_subtitles") == true ) then
      CutScene.LoadSubTitles( ns, "Levels\\Rolik_Addon\\rolik_4.shad" );
    end;
         
    local frameNotify = { { n = 3508.0 },
                          { n = 3645.0 },
                          { n = 3703.0 },
                          { n = 4001.0 },
                          { n = 4160.0, j = 4204.0 },
                          { n = 4281.0 },
                          { n = 4482.0 },
                          { n = 4659.0 },
                          { n = 4719.0 }
                        };
                        
        
    Level.DofEffects = { { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 80.0 , f = 120.0 },
                         { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 80.0 , f = 120.0 },
                         { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c =  9.0 , f = 12.0  },
                         { t = 1, n = 0.0 , c = 15.0 , f = 20.0  },
                       };
                       
    --Level.DofEffects = nil;    
                        
    Level.SetDOFPostFilter( 1, 0.0, 40.0, 50.0 );
    Level.SetCameraFrameNotifys( ns, frameNotify );
    Level.SetCutSceneFadeTime( ns, 4809.0, 3.0 );

    CutScene.Play( ns, 30.0 );    
    Level.SetHudFadeIn( 3.0 );
    
    System:SetVar("r_rimsunlightfactor" , 0.5 );
        
 end;

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik4()
-- Desc:
--------------------------------------------------------   
 function Level.OnNotify_Rolik4( cutscene, cutsceneId, frame )
    
   if ( frame >= 4719.0 or cutsceneId == 9 ) then   
      Level.SetLightParam( 'Lampa' , 'color' , 0.15, 0.15, 0.15 );   
      Level.SetLightParam( 'GLIT' , 'color' , 0.3, 0.3, 0.3 );
   end;
   
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
 end;
 
----------------------------------------------------------------------------
--
-- Description :  Rolik 5
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.InitRolik_5()
-- Desc:
--------------------------------------------------------
 function Level.InitRolik_5()
 
    local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'BULT', 'SHTS', 'CHIR' , 'MANN', 'OPAP' };
    
    local ns = Level.InitCutScene( 4931.0, 6244.0, animObjects, 5360.0 );
    
    CutScene.AddAnimInterval( ns, 'SHTS', 4931.0, 5000.0 );
    CutScene.AddAnimInterval( ns, 'BULT', 4931.0, 4941.0 );
    CutScene.AddAnimInterval( ns, 'PAPK', 4931.0, 4941.0 );
    CutScene.AddAnimInterval( ns, 'PHON', 4931.0, 4941.0 );
    CutScene.AddAnimInterval( ns, 'PIST', 4931.0, 4941.0 );
    CutScene.AddAnimInterval( ns, 'CHIR', 4931.0, 4941.0 );
    CutScene.AddAnimInterval( ns, 'OPAP', 5430.0, 5600.0 );
    
    CutScene.SetNotifyFunction( ns, "OnNotify_Rolik5" );
    CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_05.ogg" , true, false );

    if ( System:GetVar("cl_subtitles") == true ) then
      CutScene.LoadSubTitles( ns, "Levels\\Rolik_Addon\\rolik_5.shad" );
    end;
             
    local frameNotify = { { n = 5209.0, j = 5239.0 },
                          { n = 5339.0 },
                          { n = 5431.0 },
                          { n = 5588.0 },
                          { n = 5774.0 },
                          { n = 5956.0 },
                          { n = 6154.0 }                          
                        };
                                 
    Level.DofEffects = { { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 20.0 , f = 30.0  },
                         { t = 2, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 20.0 , f = 40.0  },
                         { t = 1, n = 0.0 , c = 150.0, f = 300.0 },
                         { t = 1, n = 0.0 , c = 100.0, f = 300.0 },
                         { t = 2, n = 0.0 , c = 40.0 , f = 50.0  }                         
                       };
    -- Flare switch
    
    CutScene.AddNotify( ns, 5000, 5185.0 );
    CutScene.AddNotify( ns, 5001, 5270.0 );
       
    Level.EnableLight( 'WLIT' , true );
        
    Level.EnableLight( "Fonar" , true );
    Level.EnableLight( 'FONR' , true );
    
    local obj = Level.FindWorldObject( 'MANN' );
    if ( obj != nil ) then
      Level.SetWorldObjectPos( obj, 0.0, 0.0, 0.0 );
    end;
    
    Level.SetDOFPostFilter( 1, 0.0, 40.0, 50.0 );    
    Level.SetCameraFrameNotifys( ns, frameNotify );
    
    Level.SetCutSceneFadeTime( ns, 6210.0, 1.0 );

    Level.SetLightParam( 'Lampa' , 'color' , 0.15, 0.15, 0.15 );   
    Level.SetLightParam( 'GLIT'  , 'color' , 0.8, 0.8, 0.8 );

    CutScene.Play( ns, 30.0 );    
    Level.SetHudFadeIn( 3.0 );
        
 end;
 
--------------------------------------------------------
-- Name: Level.OnNotify_Rolik5()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik5( cutscene, cutsceneId, frame )
   
   if ( cutsceneId == 5000 ) then
         
      CutScene.MoveFlare( cutscene, 'FLRE' , -30.0 );      
      return;
      
   end;
   
   if ( cutsceneId == 5001 ) then
   
      CutScene.MoveFlare( cutscene, 'FLRE' , 30.0 );      
      return;
      
   end;
   
   if ( cutsceneId == 2 ) then
      Level.SetLightParam('BLIT', 'color' , 0.6, 0.6, 0.8 );
      Level.EnableLight( 'WLIT' , false );
      System:SetVar("r_rimsunlightfactor" , 0.6 );
   end;
   
   if ( cutsceneId == 3 or cutsceneId == 7 ) then         
      Level.EnableLight('BLIT', false );
      CutScene.MoveFlare( cutscene, 'FFLR' , 22.15721 );
      
      if ( cutsceneId == 3 ) then
      --Level.SetColorPostFilter( 1.0, 0.7, 0.7, 0.2, 10000.0 );
      --else
      Level.SetColorPostFilter( 0.7, 0.7, 1.0, 0.15, 10000.0 );
      end;
      
   end;
   
   if ( cutsceneId == 4 ) then   
      Level.SetLightParam('BLIT', 'color' , 1.0, 1.0, 1.0 ); 
      Level.EnableLight('BLIT', true );
      Level.EnableLight('WLIT', true );
      CutScene.MoveFlare( cutscene, 'FFLR' , -95.0 );
      Level.SetColorPostFilter( 0.7, 0.7, 1.0, 0.0, 10000.0 );
      System:SetVar("r_rimsunlightfactor" , 2.5 );
   elseif ( cutsceneId == 6 ) then
      System:SetVar("r_rimsunlightfactor" , 1.5 );
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
   
   if ( cutsceneId == 5000 ) then         
      CutScene.MoveFlare( cutscene, 'FLRE' , -30.0 );      
      return;      
   end;
   
   if ( cutsceneId == 5001 ) then   
      CutScene.MoveFlare( cutscene, 'FLRE' , 30.0 );      
      return;      
   end;
      
   if ( cutsceneId == 4 ) then
      System:SetVar("r_rimsunlightfactor" , 2.5 );   
   elseif ( cutsceneId == 6 ) then
      Level.EnableLight('PLIT', true );
      Level.SetLightParam('GLIT', 'color' , 0.6, 0.6, 0.8 );   
      System:SetVar("r_rimsunlightfactor" , 1.0 );   
   elseif ( cutsceneId == 7 ) then
      Level.EnableLight('PLIT' , false );
      Level.SetLightParam('GLIT', 'color' , 1.0, 1.0, 1.0 );   
   end;
      
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_6()
-- Desc:
--------------------------------------------------------
function Level.InitRolik_6()

   local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'BULT', 'SHTS', 'CHIR' };
    
   local ns = Level.InitCutScene( 6349.0, 7218.0, animObjects, 6600.0 );
          
   CutScene.AddAnimInterval( ns, 'SHTS', 6349.0, 6359.0 );
   CutScene.AddAnimInterval( ns, 'BULT', 6349.0, 6359.0 );
   CutScene.AddAnimInterval( ns, 'PAPK', 6349.0, 6359.0 );
   CutScene.AddAnimInterval( ns, 'PIST', 6349.0, 6359.0 );
   CutScene.AddAnimInterval( ns, 'CHIR', 6349.0, 6359.0 );
    
   CutScene.SetNotifyFunction( ns, "OnNotify_Rolik6" );
   CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_06.ogg" , true, false );
   
   if ( System:GetVar("cl_subtitles") == true ) then
     CutScene.LoadSubTitles( ns, "Levels\\Rolik_Addon\\rolik_6.shad" );
   end;

   local frameNotify = { { n = 6503.0 },
                         { n = 6597.0 },
                         { n = 6638.0 },
                         { n = 6759.0, j = 6789.0 },
                         { n = 6828.0 },
                         { n = 6923.0 },
                         { n = 7101.0 }
                       };

   Level.DofEffects = {  { t = 1, n = 0.0 , c = 50.0 , f = 80.0 },
                         { t = 1, n = 0.0 , c = 10.0 , f = 30.0 },                         
                         { t = 1, n = 0.0 , c = 40.0 , f = 60.0 },                         
                         { t = 1, n = 0.0 , c = 30.0 , f = 40.0 },
                         { t = 1, n = 0.0 , c = 30.0 , f = 40.0 },                         
                         { t = 1, n = 0.0 , c = 10.0 , f = 15.0 },                         
                         { t = 1, n = 0.0 , c = 15.0 , f = 30.0 }
                       };
                       
   --Level.DofEffects = nil;
    
   -- Flare switch

   CutScene.AddNotify( ns, 5000, 6665.0 );
   CutScene.AddNotify( ns, 5001, 6780.0 );

   Level.SetDOFPostFilter( 1, 0.0, 40.0, 50.0 );
   Level.SetCameraFrameNotifys( ns, frameNotify );
   
   Level.SetCutSceneFadeTime( ns, 7150.0, 2.0 );

   CutScene.Play( ns, 30.0 );
   Level.SetHudFadeIn( 3.0 );
   
   System:SetVar("r_rimsunlightfactor" , 1.5 );

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
   
   if ( cutsceneId == 1 or cutsceneId == 5 ) then
      Level.SetLightParam( 'KRL1' , 'color' , 0.54, 0.54, 0.776 );
   elseif ( cutsceneId == 2 ) then
      System:SetVar("r_rimsunlightfactor" , 0.5 );   
   elseif ( cutsceneId == 4 ) then
      Level.SetLightParam( 'KRL1' , 'color' , 1.0, 1.0, 1.0 );
      
      if ( System:GetVar('r_shadowvolumes') == true and System:GetVar('r_shadowmapsize') != 0 ) then
        Level.EnableLight('LampaKor', true );
      end;
      
   elseif ( cutsceneId == 6 ) then
      Level.SetLightParam( 'KRL1' , 'color' , 1.0, 1.0, 1.0 );
   end;

   Level.OnCommonNotification( cutscene, cutsceneId, frame );

end;

--------------------------------------------------------
-- Name: Level.InitRolik_7()
-- Desc:
--------------------------------------------------------

function Level.InitRolik_7()

   local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'BULT', 'SHTS', 'CHIR', 'DVR2', 'FEET' };
    
   local ns = Level.InitCutScene( 7351.0, 8260.0, animObjects, 7660.0 );

   --CutScene.AddAnimInterval( ns, 'BULT', 7351.0, 7361.0 );
   CutScene.AddAnimInterval( ns, 'PHON', 7351.0, 7361.0 );
   CutScene.AddAnimInterval( ns, 'CHIR', 7351.0, 7361.0 );
    
   CutScene.SetNotifyFunction( ns, "OnNotify_Rolik7" );
   CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_07.ogg" , true, false );

   local frameNotify = { { n = 7513.0 , j = 7520.0 },
                         { n = 7621.0 },
                         { n = 7723.0 },
                         { n = 7907.0 },
                         { n = 8052.0 },
                         { n = 8125.0 }
                       };
                         
   Level.DofEffects = {  { t = 1, n = 0.0 , c = 40.0 , f = 150.0 },
                         { t = 1, n = 0.0 , c = 70.0 , f = 120.0 },
                         { t = 1, n = 0.0 , c = 90.0 , f = 150.0 },
                         { t = 1, n = 0.0 , c = 20.0 , f = 30.0  },
                         { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                         { t = 1, n = 0.0 , c = 20.0 , f = 30.0  },
                       };
                       
   --Level.DofEffects = {
    --                  };
   
   Level.SetDOFPostFilter( 2, 0.0, 40.0, 50.0 );
   Level.SetCameraFrameNotifys( ns, frameNotify );
   
   Level.SetCutSceneFadeTime( ns, 8225.0, 1.0 );

   Level.SetLightParam( 'Lampa' , 'color' , 0.8, 0.8, 0.8 );   
   Level.EnableLight( 'KRL1' , true );
   Level.SetLightParam( 'KRL1' , 'color' , 1.0, 1.0, 1.0 );      

   CutScene.Play( ns, 30.0 );
   Level.SetHudFadeIn( 2.0 );

end;

----------------------------------------------------------------------------
--
-- Description :  Rolik 8
--
--
----------------------------------------------------------------------------

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik8()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik8( cutscene, cutsceneId, frame )
            
   if ( cutsceneId == 3 ) then
   
      if ( System:GetVar('r_shadowvolumes') == true and System:GetVar('r_shadowmapsize') != 0 ) then
        Level.EnableLight('LampaKor', true );   
      end;
      
      Level.SetLightParam( 'KRL1' , 'color' , 0.54, 0.54, 0.776 );   
            
   elseif ( cutsceneId == 1 or cutsceneId == 6 or cutsceneId == 8 ) then
      Level.SetLightParam( 'KRL1' , 'color' , 0.54, 0.54, 0.776 );         
      
      if ( cutsceneId == 1 ) then
        Level.EnableLight('LampaF02', true );
      end;
      
   elseif ( cutsceneId == 2 or cutsceneId == 5 or cutsceneId == 7 ) then
      Level.SetLightParam( 'KRL1' , 'color' , 1.0, 1.0, 1.0 );      
      Level.EnableLight('LampaF02', false );
   end;
   
   if ( cutsceneId == 9 ) then
      Level.OnRolik8_StartFinal();
      return;   
   end;
        
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.InitRolik_8()
-- Desc:
--------------------------------------------------------

function Level.InitRolik_8()

   -- Suit scene
   
   local animObjects = { 'STOG' , 'PAPK', 'PIST', 'PHON', 'BULT', 'SHTS', 'CHIR', 'DVR2', 'FEET' };
    
   local ns = Level.InitCutScene( 8320.0, 9045.0, animObjects, 8780.0 );
    
   CutScene.AddAnimInterval( ns, 'PHON', 8320.0, 8330.0 );
   CutScene.AddAnimInterval( ns, 'BULT', 8320.0, 8330.0 );
   CutScene.AddAnimInterval( ns, 'CHIR', 8320.0, 8330.0 );
   CutScene.AddAnimInterval( ns, 'DVR2', 8320.0, 8330.0 );
   CutScene.AddAnimInterval( ns, 'FEET', 8320.0, 8330.0 );
   
   CutScene.SetNotifyFunction( ns, "OnNotify_Rolik8" );

   local frameNotify = { { n = 8438.0 },
                         { n = 8619.0 },
                         { n = 8735.0 },                         
                         { n = 8823.0 },
                         { n = 8891.0 },
                         { n = 8965.0 },
                         { n = 8996.0 },
                         { n = 9022.0 },
                         { n = 9040.0 }
                       };

   Level.DofEffects = {
                        --{ t = 1, n = 0.0 , c = 70.0 , f = 120.0 },
                        { t = 3, n = 5.0, c = 17.0 , f = 23.0 },
                        { t = 3, n = 1.0 , c = 5.0 , f = 8.0 },
                        --{ t = 1, n = 0.0 , c = 15.0 , f = 30.0  },
                        { t = 1, n = 0.0 , c = 80.0 , f = 100.0 },                        
                        { t = 1, n = 0.0 , c = 20.0 , f = 40.0  },
                        { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                        { t = 1, n = 0.0 , c = 20.0 , f = 40.0  },
                        { t = 1, n = 0.0 , c = 40.0 , f = 50.0  },
                        { t = 1, n = 0.0 , c = 20.0 , f = 40.0  },
                        { t = 1, n = 0.0 , c = 20.0 , f = 40.0  },
                      };
                       
    
   Level.SetDOFPostFilter( 0, 0.0, 40.0, 50.0 );
   Level.SetCameraFrameNotifys( ns, frameNotify );   
   --Level.SetCutSceneFadeTime( ns, 7150.0, 2.0 );

   Level.SetLightParam( 'Lampa' , 'color' , 0.8, 0.8, 0.8 );      
   Level.EnableLight( 'KRL1' , true );
   Level.SetLightParam( 'KRL1' , 'color' , 1.0, 1.0, 1.0 );
   
   CutScene.SetAudio( ns, "Levels\\Rolik_Addon\\sound_08_1.ogg" , true, false );        
   
   -- House scene
          
   local house = Level.NewCutScene( 'house' , 3547.0, 4450.0 );
    
   Level.AddCinematicCamera( 'Levels\\Rolik_Addon\\camera_f.scm' );
    
   CutScene.SetCamera( house, 'Levels\\Rolik_Addon\\camera_f.scm' );
   CutScene.SetBlurEffect( house, 0.5 );   
   CutScene.EnableDeltaLimit( house, false );
   
   CutScene.SetAudio( house, "Levels\\Rolik_Addon\\sound_08_2.ogg" , true, false );        
           
   local houseAnimObjects = { 'STR1' , 'PAPR', 'MEDL', 'PILW', 'KONV', 'DOOR', 'PST1', 'PPR2' };
    
   for i in houseAnimObjects do
       CutScene.AddAnimatedObject( house, houseAnimObjects[i], false );
   end;
    
   CutScene.AddAnimInterval( house, 'DOOR', 3547.0, 3557.0 );
   CutScene.AddAnimInterval( house, 'MEDL', 3547.0, 3557.0 );
   CutScene.AddAnimInterval( house, 'PAPR', 3547.0, 3557.0 );
   --CutScene.AddAnimInterval( house, 'PILW', 3547.0, 3557.0 );
   CutScene.AddAnimInterval( house, 'KONV', 3547.0, 3557.0 );
    
   CutScene.SetNotifyFunction( house, "OnNotify_Rolik8_Final" );
   
   Level.EnableLight('LIT2', false );
   Level.EnableLight('LIT3', false );
   Level.EnableLight('LIT4', true );
                  
   -- Start
          
   CutScene.Play( ns, 30.0 );
   Level.SetHudFadeIn( 2.0 );
   
   --Level.SetHudFadeIn( 0.0 );   
   --Level.OnRolik8_StartFinal();

end;

--------------------------------------------------------
-- Name: Level.OnNotify_Rolik8_Final()
-- Desc:
--------------------------------------------------------   
function Level.OnNotify_Rolik8_Final( cutscene, cutsceneId, frame )
   
   if ( cutsceneId == 1 ) then
     Level.SetHudFadeIn(0.0);
     --Level.SetTablePostFilter( 1.0, 1.0, 1000, "Levels\\Whitehead\\filter_2.dds" );
     Level.SetTablePostFilter( 1.0, 1.0, 1000, "Levels\\Rolik_Addon\\filter_2.dds" );
   elseif ( cutsceneId == 4 ) then
      --Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.1, 10000.0 );   
   elseif ( cutsceneId == 5 ) then
      --Level.SetColorPostFilter( 1.0, 1.0, 1.0, 0.0, 10000.0 );
      Level.SetLightParam( 'LIT4' , 'color' , 0.6, 0.6, 0.6 );      
   --elseif ( cutsceneId == 9 ) then
     --Level.SetTablePostFilter( 1.0, 1.0, 1000, "Levels\\Rolik_Addon\\filter_2.dds" );
   elseif ( cutsceneId == 11 ) then
      Level.SetLightParam( 'LIT4' , 'color' , 1.0, 1.0, 1.0 );
   elseif ( cutsceneId == 32768 ) then      
      Level.SetColorPostFilter( 1, 0, 0, 0.65, 1.0 );
   end;
   
   Level.OnCommonNotification( cutscene, cutsceneId, frame );
 
end;

--------------------------------------------------------
-- Name: Level.OnRolik8_StartFinal()
-- Desc:
--------------------------------------------------------   
function Level.OnRolik8_StartFinal()

   local ns = Level.FindCutScene('house');
   if ( ns == nil ) then
       Level.OnFinishCutScene( Level.FindCutScene('final'), false );
       return;
   end;
   
   local frameNotify = { { n = 3581.0 },
                         { n = 3600.0 },
                         { n = 3623.0 },
                         { n = 3659.0 },
                         { n = 3733.0, j = 3736.0 },
                         { n = 3794.0 },
                         { n = 3834.0 },
                         { n = 3906.0 },
                         { n = 3991.0 },
                         { n = 4092.0 },
                         { n = 4248.0 }
                       };
      
   Level.DofEffects = { { t = 1, n = 0.0 , c = 5.0 , f = 15.0  },
                        { t = 1, n = 0.0 , c = 40.0, f = 80.0  },
                        { t = 1, n = 0.0 , c = 80.0, f = 150.0 },
                        { t = 3, n = 10.0, c = 20.0, f = 40.0  },
                        { t = 1, n = 0.0 , c = 60.0, f = 80.0  },
                        { t = 1, n = 0.0 , c = 60.0, f = 80.0  },
                        { t = 1, n = 0.0 , c = 60.0, f = 80.0  },
                        { t = 1, n = 0.0 , c = 80.0, f = 150.0 },
                        { t = 3, n = 5.0 , c = 12.0, f = 25.0  },
                        { t = 1, n = 0.0 , c = 5.0 , f = 7.0   },
                        { t = 1, n = 0.0 , c = 15.0, f = 25.0  },
                        
                      };
   
   Level.SetDOFPostFilter( 1, 0.0, 40.0, 50.0 );
   Level.SetCameraFrameNotifys( ns, frameNotify );
   
   CutScene.Activate(ns);   
  
   CutScene.Play( ns, 30.0 );   
   CutScene.PreCache( ns, 3800.0 );
      
   Level.SetLightParam( 'LIT4' , 'color' , 0.5, 0.5, 0.5 );
   Level.SetLightParam( 'LIT1' , 'color' , 1.0, 0.8, 0.6 );
               
   Level.PrecacheCutScenes();
   Level.SetCutSceneFadeTime( ns, 4370.0, 2.0 );
   Level.SetTablePostFilter( 1.0, 1.0, 10000, "Levels\\Rolik_Addon\\filter_1.dds" );
   
   Level.SetHudFadeIn( 1.0, 255, 255, 255 );
       
end;
