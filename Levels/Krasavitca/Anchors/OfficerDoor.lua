
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "OfficerDoor::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  NPC.DoCustomAnimation( npc, "Relaxed_Idle3", NPC.ANIM_NO_WEAPON);

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "OfficerDoor::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "OfficerDoor::Stop");
  return true;
end


function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "OfficerDoor::Execute");

  -- Init idle to spy
  local uid = { 'GRD1', 'GRD2' };
  local pos = {};
  pos[1] = {};
  pos[2] = {};

  pos[1].x =  12.52;
  pos[1].y = -4.82;
  pos[1].z =  296.43;

  pos[2].x =  13.61;
  pos[2].y = -4.82;
  pos[2].z =  327.6;

  for i = 1, 2 do
     local guard = AI.FindNPC( uid[i] );

     if (guard != nil) then
        AI.FailTask( guard, AI.TASK_FOLLOW_ACTOR );

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

        Level.SetValue(properties, "Position", pos[i].x, pos[i].y, pos[i].z);
        Level.SetValue(properties, "Direction", 1.0, 0.0, 0.0);

        AI.Idle( guard, properties );
        AI.SetGameFlag( guard, AI.F_GUARDER_MOOD, false );
      end
  end

  AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "1", AI.ATTENTION_RELAX, true);
  Level.SpyCheckGuards = false;

  AI.EnableZone("InterrogationRoom_GSpy", true);
  AI.EnableZone("InterrogationRoom_Near", true);
                                                                          
  return true;
end