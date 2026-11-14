----------------------------------------------------------------------- 
--  Jagdpanther Dietrich Meltzer idle task
--  Sergey Gvozdev
----------------------------------------------------------------------- 


ScriptJob = 
{
-- Main internal data
-- Dynamic data. Serializable
-- Current state
   sjState = 0, 
-- logic mutex for safe logic executing
   dAlertState = false,

-- state delegates table
   sjStateDelegates = {},
-- alert attention state delegate
   sjStateAlertDelegate = nil,
};
                        
AI.DoFile( "scripts:Job\\CommonActions.lua", false );

function ScriptJob:Initialize()
   AI.Debug(self.NPC, "ScriptJob:Initialize", "");

-- Install main data
   self.sjStateDelegates[0]  = self.DoInvestigateDeapot;
   self.sjStateDelegates[1]  = self.DoInvestigateAngar1;
   self.sjStateDelegates[2]  = self.DoInvestigateAngar2;
   self.sjStateDelegates[3]  = self.DoInvestigateTanks;
   self.sjStateDelegates[4]  = self.DoInvestigateAngar3;
   self.sjStateAlertDelegate = self.DoPanic;

-- Register serialize data
   Job.RegisterData( self.Object, "sjState" );
   Job.RegisterData( self.Object, "dAlertState" );
end

function ScriptJob:DoPanic()
    AI.Debug(self.NPC, "ScriptJob:DoPanic", "");

    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_ATTENTIVE );
    Job.TakeAnchor_UID( self.Object, 'ANPN', NPC.MOVE_POLICY_RUN);
    AI.FailTask( AI.FindNPC('OFGR'), AI.TASK_FOLLOW_ACTOR);
end

function ScriptJob:DoInvestigateDeapot()
    AI.Debug(self.NPC, "ScriptJob:DoInvestigateDeapot", "");

    self:OrderFollow();
    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_NEUTRAL );
    Job.TakeAnchor_UID( self.Object, 'ANDP');
end

function ScriptJob:DoInvestigateAngar1()
    AI.Debug(self.NPC, "ScriptJob:DoInvestigateAngar1", "");

    self:OrderFollow();
    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_NEUTRAL );
    Job.TakeAnchor_UID( self.Object, 'AA10');
    Job.TakeAnchor_UID( self.Object, 'AA11');
end

function ScriptJob:DoInvestigateAngar2()
    AI.Debug(self.NPC, "ScriptJob:DoInvestigateAngar2", "");

    self:OrderFollow();
    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_NEUTRAL );
    Job.TakeAnchor_UID( self.Object, 'AA21');
end

function ScriptJob:DoInvestigateAngar3()
    AI.Debug(self.NPC, "ScriptJob:DoInvestigateAngar3", "");

    self:OrderFollow();
    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_NEUTRAL );
    Job.TakeAnchor_UID( self.Object, 'AA30');
end

function ScriptJob:DoInvestigateTanks()
    AI.Debug(self.NPC, "ScriptJob:DoInvestigateTanks", "");

    self:OrderFollow();
    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_NEUTRAL );
    Job.TakeAnchor_UID( self.Object, 'ANTN');
end

function ScriptJob:DoWait()
    AI.Debug(self.NPC, "ScriptJob:DoWait", "");

    self:ResetNPC();
    NPC.SetFirePolicy( self.NPC, NPC.FIRE_POLICY_NEUTRAL );
    self:ActAnimate(100, 15, "Relaxed_Talk_Scratch2" );
end

-- Change state logic. Executes after end of prev state
function ScriptJob:ChangeStates()
    AI.Debug(self.NPC, "ScriptJob:ChangeStates", "alertState: ", self.dAlertState);

    if (Level.PlayerAtDitrihPlace != -1 and
        Level.ExecutedDitrihHack == false) then

       if (self.sjState != 4) then

           self.sjState = Level.PlayerAtDitrihPlace;
           Level.ExecutedDitrihHack = true;
           return;
       end

    end

    self.sjState = self.sjState + 1;
    if (self.sjState > 4) then
      self.sjState = 0;
    end
end

-- Execute internal task logic
function ScriptJob:RunLogic()
    AI.Debug(self.NPC, "ScriptJob:RunLogic", "");

    -- Resolve attention
    local attention = AI.GetAttention( self.NPC );

    Job.ResetActions( self.Object );

    -- Execute main logic mechanic
    local delegate = nil;
    if ((attention == AI.ATTENTION_RELAX) and (self.dAlertState == false)) then
      delegate = self.sjStateDelegates[self.sjState];
    else
      self.dAlertState = true;
      delegate = self.sjStateAlertDelegate;
    end

    if (delegate != nil) then
      (delegate)( self );
    else
      AI.Debug(self.NPC, "ScriptJob:ERROR", "Can't find delegate for: sjState: ", self.sjState);
    end

end

-- Common default methods...

function ScriptJob:OnActionScheduleOver( success )
    AI.Debug(self.NPC, "ScriptJob:OnActionScheduleOver", "state: ", self.sjState);

    self.dAlertState = false;

    if (success == false) then
       Job.ResetActions( self.Object );
       self:DoWait();
       return;
    end

    self:ChangeStates();
    self:RunLogic();
end

function ScriptJob:OrderFollow()
   local difficultLevel = Level.GetDifficulty();

   if (difficultLevel > 0) then
      local guard = AI.FindNPC('OFGR');
      local yazik = Level.FindActor('YAZK');

      if (guard != nil and
          yazik != nil) then

         if (AI.IsFollowingActor(guard, yazik) == false) then
            local properties = Level.CreateCustomParams();
            Level.SetValue(properties, "DistanceRun", true);
            Level.SetValue(properties, "ParentPolicy", true);

            AI.FollowActor(guard, yazik, 0.0, -25.0, properties);
         end
      end
   end
end

function ScriptJob:OnStart()
   AI.Debug(self.NPC, "ScriptJob:OnStart", "");
   self:RunLogic();
   self:OrderFollow();
end

function ScriptJob:OnResume()
    AI.Debug(self.NPC, "ScriptJob:OnResume", "state: ", self.sjState);
    self:RunLogic();
--    self:OrderFollow();
    NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
end

function ScriptJob:OnDie()
   AI.Debug(self.NPC, "ScriptJob:OnDie", "bad place: ");

   AI.FailTask( AI.FindNPC('OFGR'), AI.TASK_FOLLOW_ACTOR);  
end

function ScriptJob:OnPause()
   AI.Debug(self.NPC, "ScriptJob:OnPause", "bad place: ");

   -- I think there is no ability to execute this method 
   -- Do it on over task
--   AI.FailTask( AI.FindNPC('OFGR'), AI.TASK_FOLLOW_ACTOR);  

   self:ResetNPC();
   Job.ResetActions( self.Object );
   NPC.SetHeadPolicy( self.NPC, NPC.HEAD_POLICY_DEFAULT );
end

function ScriptJob:OnPathBlocked()
    -- Use internal tasks block path analysis to protect static collisions
    if (Job.ProcessPathBlock( self.Object )) then
      AI.Debug(self.NPC, "ScriptJob:OnPathBlocked", "state: ", self.sjState);
      self:ResetNPC();
      self:RunLogic();
    end
end

function ScriptJob:OnChangedAttention( att )
    AI.Debug(self.NPC, "ScriptJob:OnChangedAttention", "att: ", att);
    -- Start this method only when NPC has just changed his attention
    self:RunLogic();
end

function ScriptJob:OnPathDynamicObstacle()
    AI.Debug(self.NPC, "ScriptJob:OnPathDynamicObstacle", "");

    if (AI.DynamicObstacle(self.NPC) == false) then
       Job.ResetActions( self.Object );
       self:DoWait();
    end
end

