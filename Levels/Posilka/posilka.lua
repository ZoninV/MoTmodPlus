
  MissionText = 
  {
      --Mission text
      Task_1                = " Встретиться с курьером";
      Task_2                = " Освободить курьера";
      Task_3                = " Забрать схемы";
      Task_4                = " Покинуть местность";

      Message_1             = "Задания изменены";
      Message_2             = "Задания обновлены";

      Fail_KKilled          = "Курьер убит";

      Docs_Tip              = "Схемы оборонительных полос противника";

      Message_Alarm         = "Поднята тревога. Число патрулей увеличено.";
      Message_AlarmFinished = "Охрана успокоилась.";

	  -- Wunder
      Intro                 = "Окрестности Витебска, Белоруссия, декабрь 1943 г.";
      Babushka1             = "Милок, немцы схватили курьера!";
      Babushka2             = "Его держат в доме неподалеку от главной улицы.";
      Player1               = "Спасибо, бабуля.";
      Player2               = "Понятно!";
      Player3               = "Хорошо, удачи, товарищ.";
      Courier_Thanks        = "Спасибо, это было действительно круто.";
      Courier1              = "Возникла небольшая проблема: у меня забрали схемы.";
      Courier2              = "Теперь они находятся в распоряжении штандартенфюрера Пауля Вебера.";
      Courier3              = "Отлично, у вас есть схемы, товарищ!";
      Courier4              = "Немедленно покиньте город.";
      Message_Courier_Died  = "Курьер мертв. Отнесите схемы в безопасное место.";
      Message_Courier_Died2 = "Курьер мертв. Немедленно получите схемы.";

      -- Liz Shaw
      MM_StopMove_CIV      = "@ Гражданским лицам вход в здание воспрещен.";
      MM_StopMove_SOL      = "@ Мне приказано пропускать внутрь только офицеров.";
      MM_StopMove_KUR      = "@ У нас здесь задержанный под стражей. Вам не разрешено входить в это здание.";
      MM_StopMove_GetOut   = "@ Убирайтесь отсюда!";
      MM_StopMove_OFF      = "@ Что вы здесь делаете? Это моя комната!";
  };

  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_lubyanka" 4' );

  end;

  function Level.OnFinishLoad()

     Level.AddLargeMessage(MissionText.Intro , 10.0, 180, 180, 180 ); -- Wunder

     -- forlik System:SetVar("r_glow", true );
     -- forlik System:SetVar("r_glow_r", 0.8 );
     System:SetVar("r_farclip" , 8192 ); -- Wunder
     Level.OnFinishLoad_Common(); -- forlik
     Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik
     System:SetVar("r_vegalpha", 96 );
     System:SetVar("r_shadowsampledif", 0.35 );
     System:SetVar( "r_dofsky", 128 ); --forlik


     Level.AddMusic( Level.MUSIC_MOOD_DEFAULT, "#0.50#sounds\\music\\ambiento.ogg");
     Level.AddMusic( Level.MUSIC_MOOD_ATTENTION   , "#0.50#sounds\\music\\action_2.ogg");
     Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\action_winter.ogg" );

     -- create snow
      
     local snow = Level.CreateEffect( 'SNOW' , Actor.GetNode( Level.GetPlayer() ) );
     if ( snow != nil ) then
         
         Level.SetEffectParameter( snow, "snow.CancelArea" , 548.6905,-105.2335,-1387.0884,571.6905,-76.2335,-1157.0884 );
         Level.SetEffectParameter( snow, "snow.CancelArea" , 548.1057,-105.2335,-1623.5072,571.1057,-76.2335,-1514.5072 );
         Level.SetEffectParameter( snow, "snow.CancelArea" , 548.1057,-105.2335,-911.5712,571.1057,-76.2335,-311.5712 );

       --Level.SetEffectParameter( snow, "wind.EmitNumber", 250 );         
       --Level.SetEffectParameter( snow, "wind.Alpha", 200 );

     end

     -- patch
     local backpack = Level.FindContainer();
     if (backpack != nil) then
         Level.EnableItemPickup(backpack, true);
     end

     --Liz Shaw
     Entity.SetSkin(Level.FindVehicle('BLT1'), 2);
  end;

  function Level.OnSave()

     Stream.WriteBool( Level.DocsComplete );
     Stream.WriteBool( Level.KurierFree );

     Stream.WriteBool( Level.Alarm[1] );
     Stream.WriteBool( Level.Alarm[2] );
     Level.OnSave_Common(); -- forlik
     if (Level.PendingAutoSaveSlot != nil) then
        Level.AutoSaveSlot = Level.PendingAutoSaveSlot;
        Level.PendingAutoSaveSlot = nil;
     end;
     if (Level.AutoSaveSlot == nil) then
        Stream.WriteInt( 0 );
     else
        Stream.WriteInt( Level.AutoSaveSlot );
     end;
  end;

  function Level.OnLoad()

     Level.DocsComplete = Stream.ReadBool();
     Level.KurierFree   = Stream.ReadBool();

     Level.Alarm = {};

     Level.Alarm[1]     = Stream.ReadBool();
     Level.Alarm[2]     = Stream.ReadBool();

     Level.OnLoad_Common(); -- forlik
     Level.AutoSaveSlot = Stream.ReadInt();
     if (Level.AutoSaveSlot == nil or Level.AutoSaveSlot < 0 or Level.AutoSaveSlot > 2) then
        Level.AutoSaveSlot = 0;
     end;
     Level.OnFinishLoad();

  end;

  function Level.AutoSave()

     if (Level.IsMissionFailed() != false) then
        return;
     end;

     local nextSlot = 0;
     if (Level.AutoSaveSlot != nil) then
        nextSlot = Level.AutoSaveSlot + 1;
        if (nextSlot > 2) then
           nextSlot = 0;
        end;
     end;

     Level.PendingAutoSaveSlot = nextSlot;
     System:SaveGame( "_posilka_" .. tostring(nextSlot) .. ".asv" , false );
     if (Level.PendingAutoSaveSlot != nil) then
        Level.PendingAutoSaveSlot = nil;
        Level.InstallSingleDpc("Level.AutoSave()", 1.0);
     end;

  end;

  function Level.OnFailedMissionHandle()

     local slot = Level.AutoSaveSlot;
     if (slot == nil or slot < 0 or slot > 2) then
        slot = 0;
     end;

     System:LoadGame( "_posilka_" .. tostring(slot) .. ".asv" , true );

     return true;

  end;

  function Level.OnLoaded()

     Level.OnLoaded_Common(); -- forlik
     Level.AddMissionTask( MissionText.Task_1, 'GETK', "levels\\posilka\\kur_task.txt" );

     Level.DocsComplete = false;
     Level.KurierFree   = false;

     Level.Alarm = {};

     Level.Alarm[1]     = false;
     Level.Alarm[2]     = false;

     local kurier = Level.FindActor( 'PKUR' );
     if ( kurier != nil ) then
        Actor.SetMapHidden( kurier, true );
     end;

     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "PKUR" , "OnKilledKurier");

     -- patch
     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GO07" , "OnKilledMarkedOfficer");
     Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GO07" , "OnKilledMarkedOfficer");

     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GO02" , "OnKilledMarkedOfficer");
     Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GO02" , "OnKilledMarkedOfficer");

     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "CIV1" , "OnDedClothChange");

     Level.AddActionHandler( Level.AH_PLAYER_INVENTORY );

     local docs = Level.CreateItem( "Custom" , "Equipment" );
     if ( docs != nil ) then

       Entity.SetUniqueID( docs, 'ADOC' );

       Level.SetCustomItemName( docs, MissionText.Docs_Tip );
       Level.SetCustomItemIcon( docs, "ammo_doc" );
     
       local officer = Level.FindActor('PAUL');
       if ( officer != nil ) then 
         Actor.PutPouch( officer, Actor.GetEmptyPouch(officer), docs );
       end;

     end;

     Level.EnableLevelMark( 'OFFR' , false );

     if (Level.GetDifficulty() != 3) then
       Level.EnableLevelMark('CIV1', true);
     end;

     local diff = Level.GetDifficulty();
     if (diff == 1 or
         diff == 2) then

         AI.SetJob(AI.FindNPC('G218'), "guard");
         AI.SetJob(AI.FindNPC('G235'), "babka");
     end;

     local diff = Level.GetDifficulty();
     if (diff == 2) then

         AI.SetForm(AI.FindNPC('G233'), "SOL6");
     end;
     --- init player

     local player     = Level.FindActor('PLYR');
     if ( player != nil ) then

       Actor.ChangeActorSkin( player, "Winter" );

       if ( Level.HasPlayerEquipPack() == false ) then

         local machineGun = Level.CreateItem("ppsh","Weapon");
         local pistol     = Level.CreateItem("NaganSilencer","Weapon");
         local knife      = Level.CreateItem("knife","Weapon");

         Actor.PutWeapon( player, Actor.WEAPON_SLOT_PISTOL , pistol );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_MACHINEGUN, machineGun );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_KNIFE, knife );
       
         Actor.PutWeaponAmmo( player, "ppsh");
         Actor.PutWeaponAmmo( player, "ppsh");
         Actor.PutWeaponAmmo( player, "nagan");
         Actor.PutWeaponAmmo( player, "nagan");

         Actor.PutEmptyPouch( player, "fiberwire", "Weapon" );
         Actor.PutEmptyPouch( player, "medikit", "Equipment" );
 
         Actor.PutEmptyPouch( player, "binocular", "Equipment" );
 
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "smoke", "Weapon" );

         --local pack = Level.CreateItem( "rukzakwinter", "container" );
         --if ( pack == nil ) 
         --  then
         --   error('Failed create player pack');
         -- end;

         --Actor.PutBackPack( player, pack );

         --ItemPack.AddItem( pack, Level.CreateItem( "pmd6", "Weapon" ) );
         --ItemPack.AddItem( pack, Level.CreateItem( "pmd6", "Weapon" ) );
         --ItemPack.AddItem( pack, Level.CreateItem( "Knife", "Weapon" ) );
       end;

       Level.ChangePlayerStand( 2 );

     end;

     AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik
     Level.OnFinishLoad();
     Level.AutoSave();

  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  function Level.OnKilledKurier()

      Level.FailedMission( MissionText.Fail_KKilled );

  end;

  -- patch
  function Level.CheckKilledOfficers()

      if (AI.FindNPC('GO07') == nil) then 
         Level.EnableLevelMark( 'OFFR' , false );
      end

      if (AI.FindNPC('GO02') == nil) then 
         Level.EnableLevelMark( 'OFR2' , false );
      end

  end

  -- patch
  function Level.OnKilledMarkedOfficer()

      Level.CheckKilledOfficers();

  end

  function Level.ShowTargetGuards()

      local g2 = Level.FindActor('OH01');
      if ( g2 != nil ) then
         Actor.MarkAsTarget( g2, true );
      end;

      local g3 = Level.FindActor('OH02');
      if ( g3 != nil ) then
         Actor.MarkAsTarget( g3, true );
      end;     

  end;

  function Level.CheckGuardsKilled()
 
     local guards = { 'OH01', 'OH02' };

     for i = 1, 2 do

            -- PATCH
         local g = AI.FindNPC( guards[i] );

         if ( g != nil ) then

            if (AI.GetRoom(npc) != AI.ROOM_OUTDOOR) then
               return false;
            end;

         end;

     end;

     return true;

  end;

  function Level.ChangeKurierTask()

      Level.AddMissionTask( MissionText.Task_2, 'FREE', "levels\\posilka\\free_task.txt" ); 
      Level.RemoveMissionTask( 'GETK' );

      Level.PlayMenuSound("task_finish");
      Level.AddLargeMessage( MissionText.Message_1, 15.0, 255, 255, 255 );
      Level.EnableLevelMark( 'GETK' , false );
      Level.EnableLevelMark( 'FREE' , true );

      local kurier = Level.FindActor('PKUR');
      if ( kurier != nil ) then
         Actor.SetMapHidden( kurier, false ); 
         Actor.MarkAsTarget( kurier, true );
      end;

      Level.EnableLevelMark( 'OFFR' , true );

      -- patch
      Level.CheckKilledOfficers();

      Level.ShowTargetGuards();

      local diff = Level.GetDifficulty();
      if (diff == 0 or
          diff == 1 or
          diff == 2) then

         local cloth = Level.CreateWorldItem( "Wear:GermanWinterSoldieH" , "Equipment" ,
                                     -389.31, -39.41, -1323.47, 0.0, 0.0, 0.0, 'SOL1' );
         Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "SOL1" , "OnSoldierClothChange");

         local form = Level.FindItem( 'SOL1' );
         if (form != nil) then
           AI.RegisterWearForm( form, "SOL1" );          
         end;

      end;

      local diff = Level.GetDifficulty();

      if (diff == 3) then

         local sniper = Level.CreateWorldItem( "MosinCamo" , "Weapon" , 
                                      -395.26, -36.41, -1330.15, 75.0, 0.0, 0.0, 'MOSN' );
         AI.SetJob(AI.FindNPC('G234'), "babka");

      end;

      local diff = Level.GetDifficulty();
      if (diff == 1 or
          diff == 2) then

         AI.SetJob(AI.FindNPC('G235'), "default");

      end;

      local diff = Level.GetDifficulty();
      if (diff == 2) then

         AI.SetJob(AI.FindNPC('G233'), "babka");

      end;

  end;

  function Level.AddDocsTask()

      Level.AddMissionTask( MissionText.Task_3, 'DOCS', "levels\\posilka\\sh_task.txt" );

      local officer = Level.FindActor('PAUL');
      if ( officer != nil and Actor.IsDead( officer ) == false ) then
         Actor.MarkAsTarget( officer, true );
      end;

      Level.EnableLevelMark( 'DOCS', true );

  end;

  function Level.AddLeaveTask()

      Level.AddMissionTask( MissionText.Task_4, 'LEAV', "levels\\posilka\\leav_task.txt" );
      Level.EnableLevelMark( 'LEAV', true );

  end;

  function Level.CompleteTaskFree()

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if ( Level.DocsComplete == false ) then

      Level.AddDocsTask();

    else

      Level.AddLeaveTask();

    end;

    Level.PlayMenuSound("task_finish"); -- Liz Shaw
    Level.CompleteMissionTask( 'FREE', 15.0 );
    Level.AddLargeMessage( MissionText.Message_2, 15.0, 255, 255, 255 );
    Level.EnableLevelMark( 'FREE' , false );

    local kurier = Level.FindActor( 'PKUR' );
    if ( kurier != nil ) then
      Actor.MarkAsTarget( kurier, false );
    end;

    local c = AI.FindNPC('PKUR');
    if (c != nil) then
       local properties = Level.CreateCustomParams();
       Level.SetValue(properties, "CustomString_1", 'AN55');

       AI.RunScriptTask(c, "scripts:job\\AnchorJob_safe.lua", AI.LOGIC_NEUTRAL, properties);
    end


    Level.KurierFree = true;
    Level.AutoSave();

  end;

  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if ( trgname == 'BabkaTrigger' ) then

        if ( Level.KurierFree == false ) then

            local babka = AI.FindNPC('PG04' );
--            if (AI.IsDefault(babka) != false) then
--          babka must be default
            if (babka != nil) then
               local properties = Level.CreateCustomParams();
               Level.SetValue(properties, "CustomString_1", 'AN53');                               
               AI.RunScriptTask(babka, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
            end
            
            Level.ChangeKurierTask();     

        end;

        Level.UnregisterTrigger( Level.FindTrigger( trgname ) );      

    elseif ( trgname == 'KurierShow' ) then

          if ( Level.KurierFree == false and Level.HasMissionTask('FREE') == false ) then
             Level.ChangeKurierTask();
          end;

          Level.UnregisterTrigger( Level.FindTrigger( trgname ) );
   
    elseif ( trgname == 'FreeTrigger') then

        if ( Level.HasMissionTask( 'FREE' ) == true ) then

          if ( Level.KurierFree == false ) then
            if ( Level.CheckGuardsKilled() == true ) then
                 Level.CompleteTaskFree();
                 Level.UnregisterTrigger( Level.FindTrigger( trgname ) );
                 Level.RemoveTimer( 'CHEK' );
            else
                 Level.AddTimer( 'CHEK', "OnCheckFreeKurier", 0.5, true );
            end;
          else
            Level.UnregisterTrigger( Level.FindTrigger( trgname ) );
            Level.RemoveTimer( 'CHEK' );
          end;
       end;

    elseif ( trgname == 'LeaveTrigger' ) then

       if ( Level.DocsComplete == true and Level.KurierFree == true ) then
           -- $TODO: Check we are not fighting?
           Level.PlayMenuSound("task_finish"); -- Liz Shaw
           Level.CompleteMissionTask( 'LEAV', 15.0 );
       end;

    elseif ( trgname == 'TipTrigger' ) then

       Level.EnableLevelMark( 'TTIP', false );
       Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

    end;

  end;

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd )

       if ( trgname == 'FreeTrigger' ) then
           Level.RemoveTimer( 'CHEK' ); 
       end;

  end;  

  function Level.OnCheckFreeKurier()

      if ( Level.CheckGuardsKilled() == true ) then
                                     
          Level.CompleteTaskFree();
          Level.RemoveTimer('CHEK');
          Level.UnregisterTrigger( Level.FindTrigger( 'FreeTrigger' ) );
      end;

  end;

  function Level.OnInventoryChanged()

    local player = Level.GetPlayer();
    if ( player == nil or Level.DocsComplete == true ) then
       Level.RemoveActionHandler( Level.AH_PLAYER_INVENTORY );
       return;
    end;

    if ( Actor.HasCustomEquipment( player, 'ADOC' ) == true ) then

       if ( Level.HasMissionTask( 'DOCS' ) == false ) then
          Level.AddDocsTask();
       end;

       if ( Level.KurierFree == true ) then
          Level.AddLeaveTask();
       end;

       Level.PlayMenuSound("task_finish"); -- Liz Shaw
       Level.CompleteMissionTask('DOCS');
       Level.EnableLevelMark( 'DOCS', false );
       Level.DocsComplete = true;

       Level.RemoveActionHandler( Level.AH_PLAYER_INVENTORY );
       Level.AutoSave();

    end;

  end;
 
  function Level.OnFinishAlert( alertGroupId )
   
     AI.Debug(nil, "Level.OnFinishAlert", "group", alertGroupId);
     AI.SetLocalAlert( alertGroupId, false );

     Level.AddSmallMessage( MissionText.Message_AlarmFinished, 10.0, 255, 0, 0);
  end

  function Level.OnAlert( alertGroupId )

    AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

    Level.AddSmallMessage( MissionText.Message_Alarm, 10.0, 255, 0, 0);

    AI.SetLocalAlert(alertGroupId, true, AI.TransformAlertTime(300));

    if (alertGroupId == 1) then

       if (Level.Alarm[1] == false) then
         AI.Patrol(AI.FindNPC('GS87'), 'Path27', nil);
         AI.PatrolFollow(AI.FindNPC('GS88'), 'Path27', AI.FindNPC('GS87'),  0.0, -15.0, nil);
         AI.SetJob(AI.FindNPC('G234'), "alert");
         AI.SetJob(AI.FindNPC('GS86'), "alert");
         AI.SetJob(AI.FindNPC('G300'), "alert");

         Level.Alarm[1] = true;
       end

       AI.AddAlertValue(1);

       if (Level.Alarm[1] == true) then
         AI.SetForm(AI.FindNPC('GS86'), "SOL5");
         AI.SetForm(AI.FindNPC('GS87'), "SOL1");
         AI.SetForm(AI.FindNPC('GS88'), "SOL1");
         AI.SetForm(AI.FindNPC('G234'), "SOL6");
       end

    elseif (alertGroupId == 2) then

       if (Level.Alarm[2] == false) then

         local p = Level.CreateCustomParams();
         Level.SetValue(p, "Use walk", true);

         AI.Patrol(AI.FindNPC('S315'), 'Path28', patrolProp);

         local properties = Level.CreateCustomParams();
         Level.SetValue(properties, "Return spawn place", true);
         Level.SetValue(properties, "Animation name", "Relaxed_Idle_GuardLook");
         Level.SetValue(properties, "Can Patrol Point", false);
         Level.SetValue(properties, "Can Smoke", false);
         Level.SetValue(properties, "Can Speak", false);
         Level.SetValue(properties, "Restore spawn direction", true);
         Level.SetValue(properties, "Return place noise", 0.0);
         Level.SetValue(properties, "Can use anchors", false);
         Level.SetValue(properties, "Spawn place return limit", 0.0);

         Level.SetValue(properties, "Position", 333.0, -55.0, -944.0);
         Level.SetValue(properties, "Direction", 1.0, 0.0, 0.0);

         AI.Idle( AI.FindNPC('S316'), properties );
         AI.SetJob(AI.FindNPC('S309'), "alert");

         Level.Alarm[2] = true;
         AI.AddAlertValue(1);
       end

       if (Level.Alarm[2] == true) then
         AI.SetForm(AI.FindNPC('S309'), "SOL5");
         AI.SetForm(AI.FindNPC('S315'), "SOL1");
         AI.SetForm(AI.FindNPC('S316'), "SOL1");
       end
    end

  end
--------------------------------------------------------
-- Name: Level.OnTransformStats()
-- Desc:
--------------------------------------------------------
function Level.OnTransformStats(levelStats, aiStats)
end

--------------------------------------------------------
-- Name: Level.OnTransformStats()
-- Desc:
--------------------------------------------------------
function Level.OnTransformInputs(levelStats, aiStats, a, c, p, n, acc)
   p = Level.DefaultCalcProf(c, n, acc);
   return a, c, p, n;
end

--------------------------------------------------------
-- Name: Level.OnCalcScore()
-- Desc:
--------------------------------------------------------
function Level.OnCalcRateScore(rank, score, levelStats, aiStats, a, c, p, n, acc)
   return rank, score;
end

--------------------------------------------------------
-- Level.OnStopMove()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnStopMove(actorId, npc)
  if (npc == nil) then
    print("MoTmod.ERROR: Jagdpanther.OnStopMove() npc is null " .. tostring(actorId));
    return;
  end

  local npcForm = AI.GetForm(npc);
  local zone = AI.GetPrimaryPlayerZone(npc);
  local playerForm = AI.GetPlayerForm();

  if (zone == nil) then 
    return;
  end

  if (zone == "mmZoneA1" or
      zone == "mmZoneC1" or
      zone == "mmZoneC2" or
      zone == "mmZoneE1" or
      zone == "mmZoneE2") then
    if (playerForm == "CIV1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_CIV, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_06");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_SOL, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_20");
    end
  elseif (zone == "mmZoneA3" or
          zone == "mmZoneC4" or
          zone == "mmZoneE4") then
    Level.AddSmallMessage(MissionText.MM_StopMove_SOL, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_20");
  elseif (zone == "mmZoneA4" or
          zone == "mmZoneC5" or
          zone == "mmZoneE5") then
    if (npcForm == "SOL5") then
      Level.AddSmallMessage(MissionText.MM_StopMove_SOL, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_05");
    elseif (npcForm == "OFF1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_OFF, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_14");
    end
  elseif (zone == "mmZoneB1" or
          zone == "mmZoneD1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_KUR, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "mmZoneB2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_KUR, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_19");
  elseif (zone == "mmZoneF1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_GetOut, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_04");
  end
end

--------------------------------------------------------
-- Name: Level.OnDedClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnDedClothChange()
  Level.EnableLevelMark('CIV1', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'CIV1');
end

--------------------------------------------------------
-- Name: Level.OnSoldierClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnSoldierClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "mesh_helmet", false);
  end;
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'SOL1');
end
