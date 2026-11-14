
  MissionText = 
  {
      --Mission text
      Message_GetTicket         = "ВЗЯТЬ КАРТОЧКУ";
      Message_Ticket            = "Карточка постояльца гостиницы";
      Failed_SpyOut             = "ДИПЛОМАТ ПОЛУЧИЛ ДОКУМЕНТЫ. ПРЕДАТЕЛЬ НЕ ВЫЯВЛЕН";
      Failed_DiplomatDied       = "ДИПЛОМАТ УБИТ";
      Failed_GadKilled          = "ПРЕДАТЕЛЬ НЕЙТРАЛИЗОВАН ДО ПЕРЕДАЧИ ДОКУМЕНТОВ";
      Failed_DiplomatBodyInfo   = "ДИПЛОМАТ УЗНАЛ О СМЕРТИ ПРЕДАТЕЛЯ";
      Failed_SeifOpened         = "ДИПЛОМАТ УЗНАЛ О ПРОНИКНОВЕНИИ В СЕЙФ";
      Failed_DiplomatGetDocs    = "ДИПЛОМАТ ПОКИДАЕТ ГОСТИНИЦУ С ДОКУМЕНТАМИ";
      Failed_DiplomatAlert      = "ДИПЛОМАТ ВСТРЕВОЖЕН - ВСТРЕЧА СОРВАНА";
      Failed_Alert              = "ВСТРЕЧА СОРВАНА";
      Message_CloseDoor         = "ЗАПЕРЕТЬ ДВЕРЬ";
      Message_ChangeDocs        = "ЗАМЕНИТЬ ДОКУМЕНТЫ";
      Message_StealTicket       = "УКРАСТЬ КАРТОЧКУ";
      Message_Registrate        = "ПОСЕЛИТЬСЯ В ОТЕЛЕ";
      Message_ShowTicket        = "ПОКАЗАТЬ КАРТОЧКУ";
      Message_OnlyForDinner     = "@ Я ожидаю свой обед. Не впускайте в номер никого, кроме официанта.";
      Message_GadWantPlumber    = "@ Постоялец в номере 114 ожидает, чтоб вы починили умывальник в его ванной. Ключ от номера получите у горничной в номере 113.";
      Message_MaidGiveKey       = "@ Держите ключ и ступайте. Раковина сама себя не починит.";
      Message_CheckDiplomatDocs = "Вы должны удостовериться что дипломат получил документы";
      Message_DocsChanging      = "Встреча началась. Поспешите в библиотеку";
      Message_GetsTicket        = "Карточка постояльца гостиницы получена";
      Message_AlarmCalled_1     = "В гостинице поднята тревога";
      Message_AlarmCalled_2     = "Охрана допломата усилена";
      Message_AlarmFinished     = "Охрана спокойна";
      Message_NeedKillGad       = "Предатель обезврежен. Необходимо ликвидировать предателя";
      Message_Info              = "В этом помещении нет посылок";
      Message_DiplomatGoGetDocs = "Дипломат вынужден забрать документы из сейфа";
      Key_Pool                  = "Ключ от бассейна";
      Key_Barn                  = "Ключ от подсобных помещений";
      Key_Number                = "Ключ от номера";
      Task_1                    = " Вычислить предателя";
      Task_2                    = " Найти оружие";
      Task_3                    = " Уничтожить предателя";
      Task_4                    = " Заменить документы";
      Task_5                    = " Покинуть отель";
      TaskChanged               = "Задания изменены";

      -- Liz Shaw
      MM_StopMove_Ticket        = "@ Могу я увидеть вашу карточку постояльца?";
      MM_StopMove_TicketClear   = "@ Все в порядке. Хорошего дня.";
      MM_StopMove_Staff         = "@ Только для персонала гостиницы!";
      MM_StopMove_Reception     = "@ Вам здесь делать нечего!";
      MM_StopMove_PoolWomen     = "@ Это дамская раздевалка! Убирайтесь немедленно!";
      MM_StopMove_Bar           = "@ Стойте, вход воспрещен!";
      MM_StopMove_Pianist       = "@ Прочь со сцены!";
      MM_StopMove_Barn          = "@ В кладовой вам делать нечего!";
      MM_StopMove_NearGenerator = "@ Доступ только для техперсонала!";
      MM_StopMove_Generator     = "@ Покиньте генераторную сейчас же!";
      MM_StopMove_Rooms         = "@ Вам здесь не место!";
      MM_StopMove_Gad           = "@ Что вы здесь делаете? Это моя комната!";
      MM_StopMove_NearDiplomat  = "@ Доступ в эту часть гостиницы закрыт. Вам сюда нельзя!";
      MM_StopMove_Diplomat      = "@ У меня приказ никого не впускать!";
      MM_StopMove_WhereIsEat    = "@ Разве вы не должны были принести обед?";
  };

  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_kabinet" 1' );

  end;

  function Level.OnSave()

     Stream.WriteBool   ( Level.RefrDoorBlocked );
     Stream.WriteBool   ( false ); 
     Stream.WriteString ( "" );
     Stream.WriteBool   ( Level.DocsInstalled ); 
     Stream.WriteBool   ( Level.DocsInSeif);
     Stream.WriteBool   ( Level.DocsDiplomat ); 
     Stream.WriteBool   ( Level.BlockLbrMessage );
     Stream.WriteBool   ( Level.DocsChanged );

     for i = 1, 3 do
        Stream.WriteBool( Level.BarnTriggerUnregistred[i] );
     end

     local n = table.getn(Level.CookFormId);
     Stream.WriteInt    ( n );
     for i = 1, n do
         Stream.WriteInt( Level.CookFormId[i] );
     end

     Stream.WriteBool   ( Level.MarkEnabled );
     Stream.WriteBool   ( Level.DiplomatInitialized );
     Stream.WriteBool   ( Level.AtHallTrigger );
     Stream.WriteBool   ( Level.UsedRegistrateTrigger );
     Stream.WriteString ( Level.ManagerTriggerName );

     Stream.WriteBool   ( Level.FirstDishTry );
     Stream.WriteBool   ( Level.WaiterEnteredDiplomatRoom );
     Stream.WriteBool   ( Level.PlayerHasDish );

     Stream.WriteBool   ( Level.TechiMessageReceived );
     Stream.WriteBool   ( Level.MaidKeyReceived );

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
  end
 
  function Level.OnLoad()

     Level.RefrDoorBlocked    = Stream.ReadBool( );
     local t                  = Stream.ReadBool( ); 
     local name               = Stream.ReadString( );
     Level.DocsInstalled      = Stream.ReadBool( ); 
     Level.DocsInSeif         = Stream.ReadBool( );
     Level.DocsDiplomat       = Stream.ReadBool( );
     Level.BlockLbrMessage    = Stream.ReadBool();
     Level.DocsChanged        = Stream.ReadBool();

     Level.BarnTriggerUnregistred = {};

     for i = 1, 3 do
        Level.BarnTriggerUnregistred[i] = Stream.ReadBool(  );
     end

     Level.CookFormId = {};
     local n                   = Stream.ReadInt();
     for i = 1, n do
         Level.CookFormId[i]   = Stream.ReadInt( );
     end

     Level.MarkEnabled                = Stream.ReadBool();
     Level.DiplomatInitialized        = Stream.ReadBool();
     Level.AtHallTrigger              = Stream.ReadBool();
     Level.UsedRegistrateTrigger      = Stream.ReadBool();
     Level.ManagerTriggerName         = Stream.ReadString();

     Level.FirstDishTry               = Stream.ReadBool();
     Level.WaiterEnteredDiplomatRoom  = Stream.ReadBool();
     Level.PlayerHasDish              = Stream.ReadBool();

     Level.TechiMessageReceived       = Stream.ReadBool();
     Level.MaidKeyReceived            = Stream.ReadBool();

     Level.OnLoad_Common(); -- forlik
     Level.AutoSaveSlot = Stream.ReadInt();
     if (Level.AutoSaveSlot == nil or Level.AutoSaveSlot < 0 or Level.AutoSaveSlot > 2) then
        Level.AutoSaveSlot = 0;
     end;
     Level.OnFinishLoad();

  end

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
     System:SaveGame( "_hotel_" .. tostring(nextSlot) .. ".asv" , false );
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

     System:LoadGame( "_hotel_" .. tostring(slot) .. ".asv" , true );

     return true;

  end;

  function Level.SetDoorKey(door, key)
     local d = Level.FindDoor(door);
     if (d != nil) then
        Level.SetDoorUnlockKey( d, key );
     end
  end

  function Level.OnFinishLoad()

     if (Level.OrigCompleteMissionTask == nil) then
        Level.OrigCompleteMissionTask = Level.CompleteMissionTask;
        Level.CompleteMissionTask = function(taskId, time)
           if (time != nil) then
              Level.OrigCompleteMissionTask(taskId, time);
           else
              Level.OrigCompleteMissionTask(taskId);
           end;
           if (taskId == 'DOCS') then
              Level.InstallSingleDpc("Level.AutoSave()", 0.1);
           end;
        end;
     end;

     -- forlik System:SetVar('r_glow', true );
     -- forlik System:SetVar('r_glow_r' , 1.5 );
     Level.OnFinishLoad_Common(); -- forlik
     Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik
     System:SetVar('ph_water_density', 0.05);
     System:SetVar('ph_water_wet_time', 6.0);


     Level.AddMusic( Level.MUSIC_MOOD_ATTENTION, "#0.50#sounds\\music\\danger.ogg");
     Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\sustain.ogg" );
     Level.AddMusic( Level.MUSIC_MOOD_DEFAULT, "#0.50#sounds\\music\\b_dark6.ogg" );
     Level.SetDefaultMusicPause( 180.0, 360.0, 20.0, 120.0 );

     local door = Level.FindDoor( 'RFDR' );

     if ( door != nil ) then
       Level.SetDoorNotifyScript( door, true );
     end;

     local seifDoor = Level.FindDoor( 'SFDR' );

     if ( seifDoor != nil ) then
       Level.SetDoorNotifyScript( seifDoor, true );
     end;

     Level.SeifTrigger      = nil;
     Level.CloseDoorTrigger = nil;

     Level.SetDoorKey('PLDR', 'PLKY' );
     Level.SetDoorKey('BRDR', 'BRKY' );
     Level.SetDoorKey('BRD2', 'BRKY' ); -- Liz Shaw
     Level.SetDoorKey('N1DR', 'N1KY' );
     Level.SetDoorKey('N2DR', 'N2KY' );
     Level.SetDoorKey('DPDR', 'DPKY' ); -- Liz Shaw

     Level.AddWaterZone(  0.8, -62.14, 266.1, 
                        184.1, -48.5,  330.9,
                        Level.F_WATER_ONLYWALK );

     -- patch
     local backpack = Level.FindContainer();
     if (backpack != nil) then
         Level.EnableItemPickup(backpack, true);
     end

  end;

  function Level.AddKey( actorId, keyId, name )
     local actor = Level.FindActor(actorId);

     if (actor != nil) then

        local key = Level.CreateItem( "Custom" , "Equipment" );
        if ( key != nil ) then
           Entity.SetUniqueID( key, keyId );

           Level.SetCustomItemName( key, name );
           Level.SetCustomItemIcon( key, "ammo_key" );
     
           Actor.PutPouch( actor, Actor.GetEmptyPouch(actor), key );
        else
           print("Warning. Can't create key " .. keyId);
        end;
     else 
        print("Warning. Can't find actor " .. actorId);
     end;
  end

  function Level.OnLoaded()

     Level.OnLoaded_Common(); -- forlik
     -- Add initial mission tasks
     Level.AddMissionTask( MissionText.Task_1, 'FNDS', "levels\\hotel\\find_spy_task.txt" );
     Level.AddMissionTask( MissionText.Task_2, 'WEPN', "levels\\hotel\\weapon_task.txt" );

     -- Setup level variables
     Level.RefrDoorBlocked           = false;
     Level.DocsInstalled             = false;
     Level.DocsInSeif                = false;
     Level.DocsDiplomat              = false;
     Level.BarnTriggerUnregistred    = { false, false, false };
     Level.BlockLbrMessage           = false;
     Level.DocsChanged               = false;
     Level.MarkEnabled               = true;
     Level.CookFormId                = {};
     Level.DiplomatInitialized       = false;
     Level.AtHallTrigger             = false;
     Level.UsedRegistrateTrigger     = false;
     Level.ManagerTriggerName        = "";
     Level.FirstDishTry              = true;
     Level.WaiterEnteredDiplomatRoom = false;
     Level.PlayerHasDish             = false;
     Level.TechiMessageReceived      = false;
     Level.MaidKeyReceived           = false;
     Level.CloseDoorTrigger          = nil;
 
     -- Add scenary action handles
     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "DPM1" , "OnKilledDiplomat");
     Level.AddActionHandler( Level.AH_ACTOR_HITTED , "DPM1" , "OnKilledDiplomat");
     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GAD1" , "OnKilledGad");
     Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GAD1" , "OnHittedGad");
     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "MC07" , "OnKilledMaid");
     Level.AddActionHandler( Level.AH_ACTOR_HITTED , "MC07" , "OnKilledMaid");

     Level.AddActionHandler( Level.AH_ACTOR_BODY_INFO, "DPM1", "OnDiplomatBodyInfo" );

     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "COOK" , "OnCookClothChange" );
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "TCCL" , "OnTechiClothChange" );
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "WTCL" , "OnWaiterClothChange" );

     Level.AddActionHandler( Level.AH_PLAYER_INVENTORY );

     local item = Level.FindItem( 'DISH' );
          
     if (item != nil) then
        Level.EnableEquipmentNotify( item, "drop", true );
        Level.EnableEquipmentNotify( item, "pickup", true );
     else
        print("Can't identify object DISH");
     end

     local diff = Level.GetDifficulty();
     if (diff == 3) then

         Level.InstallDpc( "Level.RunAnchorJob2( AI.FindNPC('HW08'), 'MM51', 'MM52', true )", 1.0 );
     end;

     if (Level.GetDifficulty() != 3) then
       Level.EnableLevelMark('FORC', true);
       Level.EnableLevelMark('FORP', true);
       Level.EnableLevelMark('FORW', true);
       Level.EnableLevelMark('PASH', true);
     end;

     --- init player
     local player     = Level.FindActor('PLYR');
     if ( player != nil ) then

       Actor.ChangeActorSkin( player, "WhiteHands" );

       Actor.SetActorTypeId(player, Actor.ACTOR_TYPE_CIVILIAN, Actor.ACTOR_NATION_BRITISH );
    
     end;

     -- Set ai flags
     AI.EnableGrenades( false );
     AI.EnableFloorRiskTest( true );

     Level.RegisterHotelVisitors();

     -- Mark diplomat as target
     local diplomat = Level.FindActor('DPM1' );
     if ( diplomat != nil ) then
       Actor.MarkAsTarget( diplomat, true );
       Actor.SetMarkAsFriend( diplomat, true );
     end;

     -- Init keys...
     Level.AddKey('HG12', 'PLKY', MissionText.Key_Pool );
     Level.AddKey('HG48', 'PLKY', MissionText.Key_Pool ); -- Liz Shaw
     Level.AddKey('HG49', 'PLKY', MissionText.Key_Pool ); -- Liz Shaw
     Level.AddKey('HW08', 'BRKY', MissionText.Key_Barn );
     Level.AddKey('MC06', 'N1KY', MissionText.Key_Number );
     Level.AddKey('MC07', 'N2KY', MissionText.Key_Number );
     Level.AddKey('GAD1', 'N2KY', MissionText.Key_Number ); -- Liz Shaw
     Level.AddKey('DPM1', 'DPKY', MissionText.Key_Number ); -- Liz Shaw
     Level.AddKey('HG46', 'DPKY', MissionText.Key_Number ); -- Liz Shaw

     -- Get cooks forms               
     local cooks = { 'BC02', 'BC07', 'BC04', 'BC06' };

     for i = 1, table.getn(cooks) do
         local cook = Level.FindActor( cooks[i] );
         Level.CookFormId[i] = Actor.GetWearFormId( cook );
     end

     if (player != nil) then
       AI.RebuildPlayerForm();
       AI.AddFormChangedValue();
     end

     AI.SetPlayerForm("Civilian");
     AI.SetPlayerDefaultForm("Civilian");

     AI.SetCustomGuarderBox( AI.FindNPC('HG46'), true, 773.7, -3.32, 337.8, 793.5, 13.1, 371.0 );

     Level.EnableItemPickup( Level.FindItem('PAS1'), false );

     NPC.SetFlag( AI.FindNPC('GAD1'), NPC.F_CANT_OPEN_LOCK_DOOR, true ); -- Liz Shaw
     NPC.SetFlag( AI.FindNPC('DPM1'), NPC.F_CANT_OPEN_LOCK_DOOR, true ); -- Liz Shaw
     NPC.SetFlag( AI.FindNPC('HW08'), NPC.F_CANT_OPEN_LOCK_DOOR, true ); -- Liz Shaw

     AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik
     Level.OnFinishLoad();
     Level.AutoSave();
  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  function Level.OnInventoryChanged()
      if (Level.MarkEnabled == false) then
         return;
      end

      local player = Level.GetPlayer();

      if ( Actor.HasCustomEquipment( player, 'TICK' ) ) then
         Level.EnableLevelMark('TICK', false);
         Level.EnableLevelMark('CIVL', false);
         Level.EnableLevelMark('RGST', false);
         Level.MarkEnabled = false;

         if (Level.AtHallTrigger != false) then
            Level.CheckDiplomatJob( true, false );
         end
      end

  end

  function Level.IsPlayerCook()
    local player = Level.GetPlayer();
    local playerFormId = Actor.GetWearFormId( player );

    if (Level.CookFormId == nil) then
       return false;
    end

    local n = table.getn(Level.CookFormId); 
    for i = 1, n do
       if (Level.CookFormId[i] == playerFormId) then
          return true;
       end
    end

    return false;
  end

  function Level.OnKilledDiplomat()
    -- If diplomat is dead fail mission always
    if (Level.IsMissionFailed() == false) then
       Level.FailedMission( MissionText.Failed_DiplomatDied );
    end

  end

  function Level.OnDiplomatBodyInfo( body )
 
     if (body == 'GAD1') then
        if (Level.IsMissionFailed() == false) then
           Level.FailedMission( MissionText.Failed_DiplomatBodyInfo );
        end
     end

  end

  function Level.OnHittedGad()

     if (Level.IsMissionTaskCompleted( 'FNDS' ) == false) then

        Level.FailedMission( MissionText.Failed_GadKilled );
        return;

     end

     Level.AddSmallMessage( MissionText.Message_NeedKillGad, 15.0, 255, 255, 255 );
     
  end

  function Level.SetupLeaveTask()

     Level.RemoveMissionTask('WEPN'); 
     Level.UninstallWeaponTask();

     Level.AddLargeMessage( MissionText.TaskChanged, 15.0 , 255, 255, 255 );
     Level.AddMissionTask( MissionText.Task_5, 'LEAV', "levels\\hotel\\leave_task.txt" );

     Level.EnableLevelMark('LEV1', true);
     Level.EnableLevelMark('LEV2', true); 

  end

  function Level.OnKilledGad()

     if (Level.IsMissionFailed() != false) then
        return;
     end

     if (Level.IsMissionTaskCompleted( 'FNDS' ) == false) then
        Level.FailedMission( MissionText.Failed_GadKilled );
        return;
     end                               

     if (Level.IsMissionTaskCompleted( 'DOCS' ) ) then
         Level.SetupLeaveTask();
     end

     Level.PlayMenuSound("task_finish"); -- Liz Shaw
     Level.CompleteMissionTask( 'KILL', 15.0 );
     Level.EnableLevelMark('POOL', false);
     Level.EnableLevelMark('KILL', false);
     Level.EnableLevelMark('TECH', false);
     Level.EnableLevelMark('N2KY', false);


     if (Level.IsPlayerAtLibrary()) then
         local gad = AI.FindNPC('HG42');
         if (gad != nil) then
            AI.SetGameFlag(gad, AI.F_ENABLE_ALWAYS, true);
         end
     end

     Level.AutoSave();

  end


  function Level.OnExplodeBrush( id )

    if (id == 'TR01' or
        id == 'TR02') then

       Level.EnableLevelMark('PLAT', false);

       local a1 = AI.FindNPC( 'BC04' );
       local a2 = AI.FindNPC( 'HW04' );

       if (AI.IsDefault( a1 )) then

          local properties = Level.CreateCustomParams();
          Level.SetValue(properties, "CustomString_1", 'AN51');

          AI.RunScriptTask(a1, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
       end

       if (AI.IsDefault( a2 )) then

          local properties = Level.CreateCustomParams();
          Level.SetValue(properties, "CustomString_1", 'AN52');

          AI.RunScriptTask(a2, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
       end
    end
 end


 function Level.OnRefregTriggerTimer()
     local player = Level.GetPlayer();
     if (player != nil) then
        Actor.RecieveDamage( player, 0.1 );
     end
 end


 function Level.OnOpenDoor( door )

    if ( door == 'RFDR' ) then

       Level.RefrDoorBlocked = false;

       Level.RemovePlayerAction("CLDR");

       local npc = AI.FindNPC( 'BC06' );
       if ( AI.IsScriptTask( npc ) ) then
          AI.FailTask( npc, AI.TASK_SCRIPT_NEUTRAL );
           
          NPC.SetFlag( npc, NPC.F_CANT_OPEN_DOOR, false );
       end

    elseif (door == 'SFDR') then

       AI.StartDecamouflage( 50.0, 150.0, 4.0 );

       if (Level.SeifTrigger != nil) then
          Level.SeifTrigger:OnEnterArea();
       end

    end;

 end;  


 function Level.OnCloseDoor( door )

    if ( door == 'RFDR' ) then

       if (Level.CloseDoorTrigger != nil and
           Level.RefrDoorBlocked == false) then

            Level.CloseDoorTrigger:OnEnterArea();

       end

    elseif (door == 'SFDR') then

       Level.RemovePlayerAction("DOCS");

    end;

 end;  


 function Level.IsPlayerAtLibrary()
     local room = AI.GetPlayerRoom();
     local library = Level.GetRoom('LIBR');

     return library == room;
 end


 function Level.OnGadTimer()
    local gad = AI.FindNPC('GAD1');

    if (AI.IsDefault(gad)) then

       local properties = Level.CreateCustomParams();
       Level.SetValue(properties, "Can use anchors", true);
       Level.SetValue(properties, "Use anchor interval", 0.0);
       Level.SetValue(properties, "Find anchor radius", 300.0);
       Level.SetValue(properties, "Don't repeat anchors", false);
       Level.SetValue(properties, "AnchorQueue0", 'A101');
       Level.SetValue(properties, "AnchorQueue1", 'A100');
       Level.SetValue(properties, "AnchorQueue2", 'A130');
       Level.SetValue(properties, "AnchorQueue3", 'MM55'); -- Liz Shaw
       Level.SetValue(properties, "AnchorQueue4", 'MM56'); -- Liz Shaw
       Level.SetValue(properties, "AnchorQueue5", 'MM57'); -- Liz Shaw
       Level.SetValue(properties, "AnchorQueue6", 'A104');
       Level.SetValue(properties, "AnchorQueue7", 'MM58'); -- Liz Shaw
       Level.SetValue(properties, "AnchorQueue8", 'MM59'); -- Liz Shaw
       Level.SetValue(properties, "AnchorQueue9", 'MM60'); -- Liz Shaw
       Level.SetValue(properties, "Can Patrol Point", false);
       Level.SetValue(properties, "Can Smoke", false);
       Level.SetValue(properties, "Can Speak", false);
       Level.SetValue(properties, "Return spawn place", false);
       Level.SetValue(properties, "Restore spawn direction", false);
       Level.SetValue(properties, "Can idle animation", false);
       Level.SetValue(properties, "Dont leeve room", false);
       Level.SetValue(properties, "Idle sounds", false);
       Level.SetValue(properties, "Idle talk sounds", false);

       -- #TODO 
       AI.SetForm( gad, "Gad");

       AI.Idle( gad, properties );

       Level.RemoveTimer( 'GDTM' );
    end
 end

  function Level.IsPlayerHotelVisitor()
     local player = Level.GetPlayer();
     if (player == nil) then
        return false;
     end

     return Actor.HasCustomEquipment( player, 'TICK' );
  end

  function Level.RegisterHotelVisitors()

     local visitors = {
          'SM21', 'M105', 'SM17', 'SM51', 'SM52', 'M118', 'SM11', 'SM13',
          'M104', 'M203', 'SM12', 'H105', 'H109', 'SM27', 'H101', 'M205',
          'SM24', 'SM25', 'SM35', 'SM50', 'SM49', 'SM31', 'SM30', 'SM34',
          'M113', 'M110', 'M111', 'SM44', 'SM45', 'M117', 'M116', 'M207',
          'M208', 'SM46', 'SM47', 'SM37', 'M114', 'SM18', 'SM19', 'SM22',
          'SM20', 'M106', 'M107', 'M109', 'M108', 'SM23', 'SM29', 'SM36',
          'SM38', 'SM39', 'SM40', 'SM42', 'SM43', 'M115', 'SM48', 'GAD1', 
          'SM53', 'SM54', 'M204', 'M112', 'H102', 'H103', 'H104', 'H107',
          'H108', 'M206', 'M209', 'HM04', 'HM05', 'HG37', 'HM06' };

     local n = table.getn(visitors);

     for i = 1, n do
         local docs = Level.CreateItem( "Custom" , "Equipment" );

         if (docs != nil) then

            Entity.SetUniqueID( docs, 'TICK' );
         
            Level.SetCustomItemName( docs, MissionText.Message_Ticket );
            Level.SetCustomItemIcon( docs, "ammo_doc" );

            local visitor = Level.FindActor( visitors[i] );
            if ( visitor != nil ) then 
               Actor.PutPouch( visitor, Actor.GetEmptyPouch(visitor), docs );
            end
         end
     end
  end

  function Level.OnGadIdentified()

     if (Level.IsMissionFailed() != false) then
        return;
     end

     -- $TODO Add new mission tasks
     Level.AddMissionTask( MissionText.Task_3, 'KILL', "levels\\hotel\\kill_task.txt" );
     Level.AddMissionTask( MissionText.Task_4, 'DOCS', "levels\\hotel\\docs_task.txt" );

     -- Complete mission task...
     Level.PlayMenuSound("task_finish"); -- Liz Shaw
     Level.CompleteMissionTask( 'FNDS', 15.0 );
     Level.EnableLevelMark( 'LIBR', false );

     -- Write information
     Level.AddLargeMessage( MissionText.TaskChanged, 15.0 , 255, 255, 255 );

     -- Mark gad
     local gad = AI.FindNPC( 'GAD1' );
     if (gad != nil) then
        Actor.MarkAsTarget( Level.FindActor('GAD1'), true );
     end

     if (Level.TechiMessageReceived == false) then
       Level.EnableLevelMark('TECH', true);
     end

     if (Level.GetDifficulty() != 3) then
       Level.EnableLevelMark('DISH', true);
     end;

     Level.EnableLevelMark('POOL', true);
     Level.EnableLevelMark('KILL', true);
     Level.AutoSave();
  end

  function Level.OnGadIdentifiedFailed()

     Level.FailedMission( MissionText.Failed_SpyOut );

  end

  function Level.UninstallWeaponTask()

       Level.EnableLevelMark('BRN1', false );
       Level.EnableLevelMark('BRN2', false );
       Level.EnableLevelMark('BRN3', false );

       local barns = { 'Barn1', 'Barn2', 'Barn3' };
       for i = 1, table.getn(barns) do

          local trg = Level.FindTrigger( barns[i] );

          if ((trg != nil) and 
              (Level.BarnTriggerUnregistred[i] == false)) then
             Level.UnregisterTrigger( trg );
             Level.BarnTriggerUnregistred[i] = true;
          end
       end
  end

  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if (Level.IsMissionFailed() != false) then
       return;
    end

    if  ( trgname == 'LibraryTrigger' ) then

--       local gad = Level.FindActor( 'GAD1' );
--       if (gad != nil) then
--          Actor.MarkAsTarget( gad, true );
--       end

       return;

    elseif (trgname == 'HallTrigger') then

        Level.AtHallTrigger = true;
        Level.CheckDiplomatJob( true, false );

    elseif (trgname == "DisableWaiterZone") then

       if (AI.GetPlayerForm() == "Waiter" and Level.PlayerHasDish == true) then
          Level.WaiterEnteredDiplomatRoom = true;
       end

       Level.UnregisterTrigger( Level.FindTrigger( "DisableWaiterZone" ) );

    elseif (trgname == "CheckOfficiantTrigger") then

       local guard = AI.FindNPC('HG46');

       local door = Level.FindDoor('DPDR');

       if (AI.IsDefault(guard) == true and
           AI.GetPlayerForm() == "Waiter" and
           Level.PlayerHasDish == true and
           (Level.WaiterEnteredDiplomatRoom == false or Level.IsDoorLocked(door) == true) and
           AI.HasPlayerInfo(guard, "knowposition")) then


           if (Level.IsDoorLocked(door) == true) then

               Level.RunAnchorJob2(guard, 'MM06', 'MM07', false);

           elseif (Level.IsDoorLocked(door) == false) then

               Level.RunAnchorJob(guard, 'MM07', false);

           end

       end

    elseif (trgname == 'StartDiplomatJob') then

        Level.CheckDiplomatJob( false, false );

    elseif (trgname == 'ExitKitchTrigger01' or
            trgname == 'ExitKitchTrigger02' or
            trgname == 'ExitKitchTrigger03') then

       if (Level.IsMissionTaskCompleted('WEAP')) then
           Level.EnableLevelMark('REFR', false);
           Level.EnableLevelMark('PLAT', false);
       end

    elseif (trgname == 'LeaveTrigger01' or
            trgname == 'LeaveTrigger02') then

       if (Level.IsMissionTaskCompleted('FNDS') and
           Level.IsMissionTaskCompleted('DOCS') and
           Level.IsMissionTaskCompleted('KILL') and
           Level.IsMissionTaskCompleted('LEAV') == false) then

           Level.PlayMenuSound("task_finish"); -- Liz Shaw
           Level.CompleteMissionTask('LEAV');                 
           Level.CompleteMissionTask('WEAP');

           Level.EnableLevelMark('LEV1', false);
           Level.EnableLevelMark('LEV2', false);
       end

       return;

    elseif ( trgname == 'Barn1') then

       if (Level.IsMissionTaskCompleted('WEPN') == false) then
          Level.AddSmallMessage( MissionText.Message_Info, 15.0, 255, 255, 255 );
       end

       Level.EnableLevelMark('BRN1', false );

       if (Level.BarnTriggerUnregistred[1] == false) then

           Level.BarnTriggerUnregistred[1] = true;
           Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

       end

       return;

    elseif (trgname == 'Barn3') then

       if (Level.IsMissionTaskCompleted('WEPN') == false) then
          Level.AddSmallMessage( MissionText.Message_Info, 15.0, 255, 255, 255 );
       end

       Level.EnableLevelMark('BRN3', false );

       if (Level.BarnTriggerUnregistred[3] == false) then

           Level.BarnTriggerUnregistred[3] = true;
           Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

       end

       return;

    elseif (trgname == 'Barn2') then

       Level.PlayMenuSound("task_finish"); -- Liz Shaw
       Level.CompleteMissionTask( 'WEPN', 15.0 );
       Level.UninstallWeaponTask();
       Level.AutoSave();

    elseif (trgname == 'DiplomatRoomTrigger') then

       if (Level.IsMissionTaskCompleted('FNDS') != false and
           Level.IsMissionTaskCompleted('DOCS') == false) then

           Level.EnableLevelMark('DOCS', true);
       end

    elseif ( trgname == "TechiMessage" ) then


       Level.AddSmallMessage(MissionText.Message_GadWantPlumber, 8.0, 175, 175, 175);
       Level.InstallDpc( "AI.SetJob( AI.FindNPC('HG21'), 'job_new')", 5.5 );
       Level.InstallDpc( "AI.SetJob( AI.FindNPC('HW07'), 'job_new')", 5.5 );

       if (Level.IsMissionTaskCompleted('KILL') == false and
           AI.IsDefault(AI.FindNPC('MC07')) != false and
           Level.MaidKeyReceived == false) then
          Level.EnableLevelMark('N2KY', true);
       end

       Level.EnableLevelMark('TECH', false);

       Level.TechiMessageReceived = true;
       Level.UnregisterTrigger( Level.FindTrigger( "TechiMessage" ) );

    elseif ( trgname == 'CheckTechiTrigger' ) then
        
      Level.InstallSingleSmartDpc( "Level.OnMaidGiveKey()", 1.0, "Level.CanMaidGiveKey()");

    end

  end

  function Level.OnLibrarySmallMessage()

    Level.RemoveTimer('LBSM');
    Level.BlockLbrMessage = false;

  end

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd )

    if (trgname == 'LibraryTrigger') then

      if (Level.IsMissionTaskCompleted( 'FNDS' ) == false) then

         local gad = Level.FindActor( 'GAD1' );
         if (gad != nil) then
            Actor.MarkAsTarget( gad, false );
         end

         return;
      end

    elseif (trgname == 'HallTrigger') then
      Level.AtHallTrigger = false; 
    end
  end

  function Level.OnFinishAlert( alertGroupId )
     
     AI.Debug(nil, "Level.OnFinishAlert", "group", alertGroupId);
     AI.SetLocalAlert( alertGroupId, false );

     for i = 1, 7 do
        if (AI.IsLocalAlert(i) != false) then 
           return;
        end
     end

     Level.AddSmallMessage( MissionText.Message_AlarmFinished, 15.0, 255, 255, 255 );

  end

  function Level.OnInitCallAlert( alertGroupId )

    if (alertGroupId == 2) then
       return false; 
    end

    return true;
  end

  function Level.OnAlert( alertGroupId )

    AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

    if (alertGroupId == 1) then

       AI.SetLocalAlert(1, 300);
       AI.SetLocalAlert(2, 300);
       AI.SetLocalAlert(3, 300);
       AI.SetLocalAlert(4, 300);

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "1", AI.ATTENTION_ALARM, true);

       Level.AddSmallMessage( MissionText.Message_AlarmCalled_1, 15.0, 255, 255, 255 );

    elseif (alertGroupId == 2) then

       AI.SetLocalAlert(2, 160);

    elseif (alertGroupId == 3) then

       AI.SetLocalAlert(3, 100);

    elseif (alertGroupId == 4) then

       AI.SetLocalAlert(4, 200);


    elseif (alertGroupId == 5) then

       AI.SetLocalAlert(5, 200);


    elseif (alertGroupId == 6) then

       AI.SetLocalAlert(6, 400);

       if (Level.IsMissionFailed() != false) then 
          return ;
       end 
 
       -- Diplomat alert script...
       if (Level.DocsInSeif != false) then

          local diplomat = AI.FindNPC('DPM1');

          if (diplomat != nil) then
             local properties = Level.CreateCustomParams();
             Level.SetValue(properties, "CustomString_1", 'A113');
  
             AI.RunScriptTask(diplomat, "scripts:job\\AnchorJob_safe_run.lua", AI.LOGIC_DEFAULT, properties);

             Level.AddSmallMessage( MissionText.Message_DiplomatGoGetDocs, 15.0, 255, 255, 255 );
          end

       end

       if (Level.DocsDiplomat != false and
           Level.DocsChanged == false) then
                                                                     
           Level.FailedMission( MissionText.Failed_DiplomatGetDocs );
           return;
       end

       if (Level.DocsDiplomat == false and
           Level.DocsInSeif == false) then

           Level.FailedMission( MissionText.Failed_DiplomatAlert );
           return;

       end

    elseif (alertGroupId == 7) then

       AI.SetLocalAlert(7, 300);

       -- Add additional guards...
       local guard = AI.FindNPC( 'HG38' );

       if (guard != nil) then
          local properties = Level.CreateCustomParams();
 
          Level.SetValue(properties, "Return spawn place", true);
          Level.SetValue(properties, "Animation name", "Relaxed_Idle_Guard2_Look"); -- Liz Shaw
          Level.SetValue(properties, "Can Patrol Point", false);
          Level.SetValue(properties, "Can Smoke", false);
          Level.SetValue(properties, "Can Speak", false);
          Level.SetValue(properties, "Restore spawn direction", true);
          Level.SetValue(properties, "Return place noise", 0.0);
          Level.SetValue(properties, "Can use anchors", false);
          Level.SetValue(properties, "Dont leeve room", false);
          Level.SetValue(properties, "Position", 783.0, -1.54, 330.4);
          Level.SetValue(properties, "Direction", -1.0, 0.0, 0.0);
          Level.SetValue(properties, "Return place waypoint", '7742');

          AI.Idle( guard, properties );
       end

       Level.AddSmallMessage( MissionText.Message_AlarmCalled_2, 15.0, 255, 255, 255 );
    end
  end

  function Level.GiveTicket()
     local docs = Level.CreateItem( "Custom" , "Equipment" );

     if ( docs != nil ) then

         Entity.SetUniqueID( docs, 'TICK' );
         
         Level.SetCustomItemName( docs, MissionText.Message_Ticket );
         Level.SetCustomItemIcon( docs, "ammo_doc" );

         local player = Level.GetPlayer();
         if ( player != nil ) then 
            Actor.PutPouch( player, Actor.GetEmptyPouch(player), docs );
         end

         Level.EnableLevelMark('TICK', false);
     end
  end


  function Level.CheckDiplomatJob( checkPass, restart )
     if (checkPass != false) then
        local player = Level.GetPlayer(); 
        if (Actor.HasCustomEquipment( player, 'TICK' ) == false) then
           return;
        end
     end

     if (restart == false) then
        if (Level.DiplomatInitialized != false) then
           return;
        end
     end

     if (Level.IsMissionTaskCompleted( 'FNDS' ) == false and
         Level.IsMissionFailed() == false) then

        local npc = AI.FindNPC('DPM1');

        if (npc != nil) then

           if (AI.IsDefault(npc) == false) then
              return;
           end

            -- Create new idle for diplomat...
           local properties = Level.CreateCustomParams();
 
           Level.SetValue(properties, "Can use anchors", true);
           Level.SetValue(properties, "Use anchor interval", 0.0);
           Level.SetValue(properties, "Ignore attention", false);
           Level.SetValue(properties, "Find anchor radius", 300.0);
           Level.SetValue(properties, "Don't repeat anchors", false);
           Level.SetValue(properties, "AnchorQueue0", 'AN91');
           Level.SetValue(properties, "AnchorQueue1", 'AN92');
           Level.SetValue(properties, "AnchorQueue2", 'AN90');
           Level.SetValue(properties, "Can Patrol Point", false);
           Level.SetValue(properties, "Can Smoke", false);
           Level.SetValue(properties, "Can Speak", false);
           Level.SetValue(properties, "Return spawn place", false);
           Level.SetValue(properties, "Restore spawn direction", false);
           Level.SetValue(properties, "Can idle animation", false);
           Level.SetValue(properties, "Dont leeve room", false);
           Level.SetValue(properties, "Idle sounds", false);
           Level.SetValue(properties, "Idle talk sounds", false);
      
           AI.Idle( npc, properties );

           Level.DiplomatInitialized = true;
        end
     end
  end
                           
  function Level.FinishFindGadTask( failed )

     if (Level.IsMissionFailed() == false) then
        if (failed != false) then
           Level.OnGadIdentifiedFailed();
        else
           Level.OnGadIdentified();
        end
     end

     local npc = AI.FindNPC('DPM1');

     if (npc != nil) then
         -- Create new idle for diplomat...
        local properties = Level.CreateCustomParams();
 
        Level.SetValue(properties, "Can use anchors", true);
        Level.SetValue(properties, "Use anchor interval", 0.0);
        Level.SetValue(properties, "Find anchor radius", 300.0);
        Level.SetValue(properties, "Don't repeat anchors", false);
        Level.SetValue(properties, "AnchorQueue0", 'A107');
        Level.SetValue(properties, "AnchorQueue1", 'A106');
        Level.SetValue(properties, "AnchorQueue2", 'MM02'); -- Liz Shaw
        Level.SetValue(properties, "AnchorQueue3", 'MM03'); -- Liz Shaw
        Level.SetValue(properties, "AnchorQueue4", 'A110');
        Level.SetValue(properties, "AnchorQueue5", 'A102');
        Level.SetValue(properties, "AnchorQueue6", 'A105');
        Level.SetValue(properties, "AnchorQueue7", 'MM04'); -- Liz Shaw
        Level.SetValue(properties, "AnchorQueue8", 'MM01'); -- Liz Shaw
        Level.SetValue(properties, "Can Patrol Point", false);
        Level.SetValue(properties, "Can Smoke", false);
        Level.SetValue(properties, "Can Speak", false);
        Level.SetValue(properties, "Return spawn place", false);
        Level.SetValue(properties, "Restore spawn direction", false);
        Level.SetValue(properties, "Can idle animation", false);
        Level.SetValue(properties, "Dont leeve room", false);
        Level.SetValue(properties, "Idle sounds", false);
        Level.SetValue(properties, "Idle talk sounds", false);
      
        AI.Idle( npc, properties );
      
        -- Create new script job for diplomat
        local prop3 = Level.CreateCustomParams();
        Level.SetValue(prop3, "CustomString_1", 'A109');
        Level.SetValue(prop3, "CustomString_2", 'MM01'); -- Liz Shaw
        Level.SetValue(prop3, "CustomString_3", 'A108');
        AI.RunScriptTask(npc, "scripts:job\\AnchorJob3_safe.lua", AI.LOGIC_DEFAULT, prop3);
     end
 
     -- Setup gad timer
     Level.AddTimer( 'GDTM', "OnGadTimer", 60, true );

     Level.DocsDiplomat = true;
     Level.DocsInstalled = false;
     Level.DocsInSeif = false;
  end

  function Level.OnHotelManagerTimer()
    local manager = AI.FindNPC('HM03');

    if (Level.ManagerTriggerName == "") then
       return;
    end

    if (Level.IsPlayerHotelVisitor() == false) then
       if (AI.IsDefault(manager) != false) then
          if (Level.HasPlayerAction('VTHT') == false) then                 
             Level.AddPlayerAction("VTHT", MissionText.Message_Registrate, Level.ManagerTriggerName, false);
          end
       else
          if (Level.HasPlayerAction('VTHT') != false) then
             Level.RemovePlayerAction('VTHT');
          end
       end
    end
  end


  function Level.CheckCanCloseDoor()

       local npc = AI.FindNPC('BC06');

       if (npc != nil) then

         if (AI.GetRoom(npc) != Level.GetRoom('VA45')) then
            return false;
         end

         local n = Entity.GetNode(Level.FindActor('BC06') );
         local pos = {}; 
         pos.x, pos.y, pos.z = node.GetPosition( n );

         if (pos.x > 358.0) then
            return false;
         end

         return true;
       end

       return false;
  end

  function Level.OnAttentionCheckTimer()
     local spy = AI.FindNPC('GAD1');
     local diplomat = AI.FindNPC('DPM1');

     if (spy == nil or
         diplomat == nil) then

        Level.RemoveTimer('ACTR');

        if (Level.IsMissionFailed() == false) then
           Level.FailedMission(MissionText.Failed_Alert);
        end
     end

     if (AI.GetAttention(spy) == AI.ATTENTION_ALARM or
         AI.GetAttention(diplomat) == AI.ATTENTION_ALARM) then

        Level.RemoveTimer('ACTR');

        if (Level.IsMissionFailed() == false) then
           Level.FailedMission(MissionText.Failed_Alert);
        end
     end

  end

  function Level.EnableAttentionCheckTimer( bOnOff )

     if (bOnOff != false) then
        Level.AddTimer( 'GDTM', "OnAttentionCheckTimer", 0.5, true );
     else
        Level.RemoveTimer('ACTR');
     end
  end

--------------------------------------------------------
-- Name: Level.OnAnchor_MMAnchor04()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
  function Level.OnAnchor_MMAnchor04()
     Level.VoiceMessage(AI.FindNPC('DPM1'), "", "Message_OnlyForDinner");
     Level.InstallDpc("Level.RunAnchorJob(AI.FindNPC('HG46'), 'MM05', false)", 4.0);
  end

--------------------------------------------------------
-- Name: Level.OnCheckShowPass()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnCheckShowPass()
   local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");

   if (npc == nil) then
      Level.SafeRemoveLevelPlayerAction('SHT1');
      Level.SafeRemoveLevelPlayerAction('SHT2');
      Level.SafeRemoveLevelPlayerAction('SHT3');
      Level.SafeRemoveLevelPlayerAction('SHT4');
      Level.RemoveTimer('PSTM');
   end
end

--------------------------------------------------------
-- Name: Level.RestorePoolAreaZones()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestorePoolAreaZones()
   AI.EnableZone("PoolArea",           true);
   AI.EnableZone("PoolAreaEnter",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreLibraryAreaZones()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreLibraryAreaZones()
   AI.EnableZone("LibraryArea",           true);
   AI.EnableZone("LibraryAreaEnter",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreFirstFloorZones()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreFirstFloorZones()
   AI.EnableZone("FirstFloor",         true);
   AI.EnableZone("FirstFloorEnter",    true);
end

--------------------------------------------------------
-- Name: Level.RestoreSecondFloorZones()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreSecondFloorZones()
   AI.EnableZone("SecondFloor",        true);
   AI.EnableZone("SecondFloorEnter",   true);
end

--------------------------------------------------------
-- Name: Level.OnReadDocs()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnReadDocs()
   Level.AddSmallMessage( MissionText.MM_StopMove_TicketClear, 5.0, 175, 175, 175 );

   local job = AI.GetScriptJob("TASK_SCRIPT_READ_DOCS");
   if (job != nil) then
      local npc = Job.GetNPC( job );
      if (npc != nil) then
         AI.HandleVoice(npc, "male_eng_script_script_24");
      end
   end
end

--------------------------------------------------------
-- Name: Level:OnPlayerAction()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level:OnPlayerAction(id)

   if (id == 'SHT1' or id == 'SHT2' or id == 'SHT3' or id == 'SHT4') then

      -- get show stop move bot...
      local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");
      if (npc == nil) then
         Level.SafeRemoveLevelPlayerAction(id);
         Level.RemoveTimer('PSTM');
         return;
      end

      Level.SafeRemoveLevelPlayerAction(id);

      local properties = Level.CreateCustomParams();

      Level.SetValue(properties, "CustomString_1", "Level.OnReadDocs()" );

      AI.RunScriptTask(npc, "scripts:job\\ReadDocsTask.lua", AI.LOGIC_DEFAULT, properties);

      if (id == 'SHT1') then

         Level.DisablePoolAreaZone();

      elseif (id == 'SHT2') then

         Level.DisableLibraryAreaZone();

      elseif (id == 'SHT3') then

         Level.DisableFirstFloorZone();

      elseif (id == 'SHT4') then

         Level.DisableSecondFloorZone();

      end

      local player = Level.GetPlayer();

      if (Actor.GetPickupItem(player) == nil) then 
         Level.PlayerShowDocsAnim();
      else
         Actor.DropPickupItem(player, false);
         Level.InstallDpc("Level.PlayerShowDocsAnim()", 0.8);
      end

      Level.RemoveTimer('PSTM');
   end
end

--------------------------------------------------------
-- Name: Level.PlayerShowDocsAnim()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.PlayerShowDocsAnim()
   Level.StartPlayerCustomAnim("Custom_PassticketShow", 0, true, true);
end

--------------------------------------------------------
-- Name: Level.DisablePoolAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisablePoolAreaZone()
   AI.EnableZone("PoolArea",           false);
   AI.EnableZone("PoolAreaEnter",      false);

   Level.AddTimer( 'RPZN', "RestorePoolAreaZones", 5.0 * 60.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableLibraryAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableLibraryAreaZone()
   AI.EnableZone("LibraryArea",           false);
   AI.EnableZone("LibraryArea_Pass",      false);
   AI.EnableZone("LibraryAreaEnter",      false);

   Level.InstallDpc( "AI.EnableZone('LibraryArea_Pass', true)", 12.0 );

   Level.AddTimer( 'RLZN', "RestoreLibraryAreaZones", 5.0 * 60.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableFirstFloorZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableFirstFloorZone()
   AI.EnableZone("FirstFloor",         false);
   AI.EnableZone("FirstFloorEnter",    false);

   Level.AddTimer( 'R1ZN', "RestoreFirstFloorZones", 5.0 * 60.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableSecondFloorZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableSecondFloorZone()
   AI.EnableZone("SecondFloor",        false);
   AI.EnableZone("SecondFloorEnter",   false);

   Level.AddTimer( 'R2ZN', "RestoreSecondFloorZones", 5.0 * 60.0, false );
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
-- Name: Level.OnNotifyPickupItem()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnNotifyPickupItem( objectId, object, actor )

   if (objectId == 'DISH' and (actor == Level.GetPlayer())) then
   
      if (Level.FirstDishTry == true) then
         Level.FirstDishTry = false;
         
         if (AI.GetPlayerForm() != "Waiter") then
            AI.StartDecamouflage( 50.0, 100.0, 2.0 );
         end
         
         Level.EnableLevelMark('DISH', false);
      end
      
      AI.EnableZone("WaiterZone", false);
      AI.EnableZone("Room230_Near2", false);
      
      Level.PlayerHasDish = true;

   end;
end

--------------------------------------------------------
-- Name: Level.OnNotifyDropItem()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnNotifyDropItem( objectId, object, actor )
   
   if (objectId == 'DISH' and (actor == Level.GetPlayer())) then
      
      if (Level.WaiterEnteredDiplomatRoom == false) then
         AI.EnableZone("WaiterZone", true);
         AI.EnableZone("Room230_Near2", true);
      end
      
      Level.PlayerHasDish = false;      
   end
end

--------------------------------------------------------
-- Name: Level.OnCookClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnCookClothChange()
  Level.EnableLevelMark('FORC', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'COOK');
end

--------------------------------------------------------
-- Name: Level.OnTechiClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTechiClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "mesh_cap", false);
  end
  Level.EnableLevelMark('FORP', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'TCCL');
end

--------------------------------------------------------
-- Name: Level.OnWaiterClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnWaiterClothChange()
  Level.EnableLevelMark('FORW', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'WTCL');
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
  local class = AI.GetClass(npc);

  if (zone == nil) then 
    return;
  end

  if (zone == "FirstFloor" or
      zone == "FirstFloorEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Ticket, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_06");
    if (Level.IsPlayerHotelVisitor() == true) then
      if (Level.HasPlayerAction('SHT3') == false) then
         --Level.AddPlayerAction('SHT3', MissionText.Message_ShowTicket, "Level", false );
         Level.SafeAddLevelPlayerAction('SHT3', MissionText.Message_ShowTicket);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "SecondFloor" or
          zone == "SecondFloorEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Ticket, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_06");
    if (Level.IsPlayerHotelVisitor() == true) then
      if (Level.HasPlayerAction('SHT4') == false) then
         --Level.AddPlayerAction('SHT4', MissionText.Message_ShowTicket, "Level", false );
         Level.SafeAddLevelPlayerAction('SHT4', MissionText.Message_ShowTicket);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "SecondFloor_NearDiplomat") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearDiplomat, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "Reception") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Reception, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop_02");
  elseif (zone == "PoolArea" or
          zone == "PoolAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Ticket, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_06");
    if (Level.IsPlayerHotelVisitor() == true) then
      if (Level.HasPlayerAction('SHT1') == false) then
         --Level.AddPlayerAction('SHT1', MissionText.Message_ShowTicket, "Level", false );
         Level.SafeAddLevelPlayerAction('SHT1', MissionText.Message_ShowTicket);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "PoolArea_Women") then
    Level.AddSmallMessage(MissionText.MM_StopMove_PoolWomen, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
  elseif (zone == "LibraryArea" or
          zone == "LibraryAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Ticket, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_06");
    if (Level.IsPlayerHotelVisitor() == true) then
      if (Level.HasPlayerAction('SHT2') == false) then
         --Level.AddPlayerAction('SHT2', MissionText.Message_ShowTicket, "Level", false );
         Level.SafeAddLevelPlayerAction('SHT2', MissionText.Message_ShowTicket);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "StaffArea") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Staff, 5.0, 175, 175, 175);
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      AI.HandleVoice(npc, "female_eng_stopmove_stopmove_02");
    else
      AI.HandleVoice(npc, "male_eng_ohers_stop_02");
    end
  elseif (zone == "StaffAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Staff, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "BistroBar") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Bar, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop_02");
  elseif (zone == "BistroStage") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pianist, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop_03");
  elseif (zone == "Barn03") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Barn, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop_03");
  elseif (zone == "GeneratorRoom_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearGenerator, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "GeneratorRoom") then
    if (npcForm == "Plumber") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Generator, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_09");
    elseif (npcForm == "Guardian") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Generator, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
    end
  elseif (zone == "FirstFloor_Nums" or
          zone == "Room113" or
          zone == "Room219" or
          zone == "Room224" or
          zone == "Room225" or
          zone == "Room234" or
          zone == "Room235" or
          zone == "Room236") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Rooms, 5.0, 175, 175, 175);
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      AI.HandleVoice(npc, "female_eng_stopmove_stopmove_02");
    else
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_05");
    end
  elseif (zone == "Room114") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Gad, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_07");
  elseif (zone == "Room230_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Diplomat, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "Room230_Near2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_WhereIsEat, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  end
end

--------------------------------------------------------
-- Name: Level.ChangePoolAreaJobs()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangePoolAreaJobs()
   AI.Debug(npc, "Script", "Level.ChangePoolAreaJobs()");

   if (Level.GetDifficulty() != 3) then
      if (AI.IsDefault(AI.FindNPC('SM49')) != false) then
         AI.SetJob(AI.FindNPC('SM49'), "job_1");
      end
   end

   if (Level.GetDifficulty() == 0) then
      if (AI.IsDefault(AI.FindNPC('HG49')) != false) then
         AI.SetJob(AI.FindNPC('HG49'), "job_1");
      end
   end

   if (Level.GetDifficulty() == 1 or Level.GetDifficulty() == 2) then
      if (AI.IsDefault(AI.FindNPC('HG49')) != false) then
         AI.SetJob(AI.FindNPC('HG49'), "job_2");
      end
   end

   if (Level.GetDifficulty() == 1 or Level.GetDifficulty() == 2) then
      if (AI.IsDefault(AI.FindNPC('SM48')) != false) then
         AI.SetJob(AI.FindNPC('SM48'), "job_1");
      end
   end

   if (Level.GetDifficulty() != 0) then
      if (AI.IsDefault(AI.FindNPC('SM54')) != false) then
         AI.SetJob(AI.FindNPC('SM54'), "job_1");
      end
   end

   if (Level.GetDifficulty() == 2) then
      if (AI.IsDefault(AI.FindNPC('HG48')) != false) then
         AI.SetJob(AI.FindNPC('HG48'), "job_1");
      end
   end
end

--------------------------------------------------------
-- Name: Level.OnKilledMaid()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnKilledMaid()
   Level.EnableLevelMark('N2KY', false);
   Level.EnableLevelMark('TECH', false);
end

--------------------------------------------------------
-- Name: Level.OnChangePashJobsTrigger()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTrigger_ChangePashJobs()
   Level.EnableLevelMark('PASH', false);
   Level.InstallDpc("Level.ChangePashJobs()", 10.0);
end

--------------------------------------------------------
-- Name: Level.ChangePashJobs()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangePashJobs()
   AI.SetJob(AI.FindNPC('M105'), "post_pash");
   AI.SetJob(AI.FindNPC('SM15'), "post_pash");
end

--------------------------------------------------------
-- Name: Level.GiveKey()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.GiveKey()
   local key = Level.CreateItem( "Custom" , "Equipment" );

   if ( key != nil ) then

       Entity.SetUniqueID( key, 'N2KY' );

       Level.SetCustomItemName( key, MissionText.Key_Number );
       Level.SetCustomItemIcon( key, "ammo_key" );

       local player = Level.GetPlayer();
       if ( player != nil ) then 
          Actor.PutPouch( player, Actor.GetEmptyPouch(player), key );
       end
   end
end

--------------------------------------------------------
-- Name: Level.OnMaidGiveKey()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnMaidGiveKey()

   local maid = AI.FindNPC('MC07');
   if (AI.IsDefault(maid)) then

      if ( Actor.HasCustomEquipment( AI.GetActor(maid), 'N2KY' ) ) then
         Level.GiveKey();
         Actor.RemoveCustomEquipment( AI.GetActor(maid), 'N2KY' );
      end
   end

   if (Level.TechiMessageReceived == false) then
     Level.EnableLevelMark('TECH', false);
   end

   Level.AddSmallMessage( MissionText.Message_MaidGiveKey, 5.0, 175, 175, 175 );
   Level.EnableLevelMark('N2KY', false);
   Level.MaidKeyReceived = true;
end

--------------------------------------------------------
-- Name: Level.CanMaidGiveKey()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.CanMaidGiveKey()
   if (Level.MaidKeyReceived != false) then
      return false;
   end
   
   local npc = AI.FindNPC('MC07');
   if (AI.IsDefault(npc) == false) then
      return false;
   end
   
   if (AI.HasPlayerInfo(npc, "see") == false) then
      return false;
   end
   
   if (AI.GetPlayerForm() != "Plumber") then
      return false;
   end
   
   return true;
end
