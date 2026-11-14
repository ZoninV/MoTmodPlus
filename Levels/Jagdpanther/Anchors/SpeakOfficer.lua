
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "SpeakOfficer::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  local officer = AI.FindNPC('OF16');
  if (AI.IsDefault(officer)) then
     NPC.DoCustomAnimation( npc, "Relaxed_Talk_2", NPC.ANIM_NO_WEAPON);

     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AA33');
     AI.RunScriptTask(officer, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
  else
     NPC.DoCustomAnimation( npc, "Relaxed_Idle1", NPC.ANIM_NO_WEAPON);
  end

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "SpeakOfficer::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "SpeakOfficer::Stop");
  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "SpeakOfficer::Execute");
                                                                          
  return true;
end