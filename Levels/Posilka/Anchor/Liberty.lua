
Anchor =
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "Liberty::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  
  -- Courier now looks the player into the face instead of staring out of the window. AHO, 29.09.2008
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_FROM_PLAYER_ALWAYS );  
  --
  
  NPC.DoCustomAnimation( npc, "Relaxed_Talk_Kivok1", NPC.ANIM_NO_WEAPON);

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "Liberty::Notify");

  if (AI.IsAnimating(npc) == false) then
    AI.DirtyMove(npc, -2240.0, -53.0, -1602.0);
  end

  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "Liberty::Stop");
  return true;
end


function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "Liberty::Execute");

  return true;
end