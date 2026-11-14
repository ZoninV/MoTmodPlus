
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "OfficerCome::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  NPC.DoCustomAnimation( npc, "Relaxed_Idle2", NPC.ANIM_NO_WEAPON);

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "OfficerCome::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "OfficerCome::Stop");
  return true;
end


function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "OfficerCome::Execute");

  local officer = AI.FindNPC('GO04');
  -- Todo check officer room and see Spy fact...
  if (AI.IsDefault(officer)) then
     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AN91');
     AI.RunScriptTask(officer, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
  end

  -- Init idle to spy
  local spy = AI.FindNPC('GSPY');
  if (spy != nil) then
     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "Return spawn place", true);
     Level.SetValue(properties, "Animation name", "Relaxed_Idle_Guard");
     Level.SetValue(properties, "Can Patrol Point", false);
     Level.SetValue(properties, "Can Smoke", false);
     Level.SetValue(properties, "Can Speak", false);
     Level.SetValue(properties, "Restore spawn direction", true);
     Level.SetValue(properties, "Return place noise", 0.0);
     Level.SetValue(properties, "Can use anchors", false);
     Level.SetValue(properties, "Spawn place return limit", 0.0);
     Level.SetValue(properties, "Ignore attention", true);
     Level.SetValue(properties, "Idle sounds", false); -- Liz Shaw
     Level.SetValue(properties, "Idle talk sounds", false); -- Liz Shaw

     Level.SetValue(properties, "Position", -20.39, -5.0, 316.0);
     Level.SetValue(properties, "Direction", -1.0, 0.0, 0.0);
     AI.Idle( spy, properties );
  end        

  return true;
end