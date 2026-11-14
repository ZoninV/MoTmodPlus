
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "SendGuard::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.SetHeadPolicy(npc, NPC.HEAD_POLICY_DEFAULT);
  NPC.SetFirePolicy(npc, NPC.FIRE_POLICY_NEUTRAL);

  local guard = AI.FindNPC( 'GS66' );

  if (AI.IsDefault( guard ) ) then
     AI.DoCustomAnimationEx( npc, "Relaxed_Talk_Express1:male_ger_script_script_26:11" );
  else
     AI.DoCustomAnimationEx( npc, "Relaxed_Talk_Scratch2" );
  end

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "SendGuard::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "SendGuard::Stop");
  return true;
end


function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "SendGuard::Execute");

  local guard = AI.FindNPC( 'GS66' );

  if (AI.IsDefault( guard ) ) then
     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AN34');
     Level.SetValue(properties, "CustomString_2", 'AN35');
     Level.SetValue(properties, "CustomString_3", 'AN36');

     AI.RunScriptTask(guard, "scripts:job\\AnchorJob3_run.lua", AI.LOGIC_DEFAULT, properties);
  end

  return true;
end