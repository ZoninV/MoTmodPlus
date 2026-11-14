
Anchor = 
{
};

--------------------------------------------------------
-- Name: Anchor:Setup()
-- Desc:
--------------------------------------------------------
function Anchor:Setup( anchor, npc )
  AI.Debug(npc, "Anchor", "GutGunAnchor::Setup");

  NPC.Stand(npc);

  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_DEFAULT );
  NPC.SetFirePolicy( npc, NPC.FIRE_POLICY_NEUTRAL );

  local gun = Level.FindWeaponItem('LGSL');
  
  local pos = Level.GetEntityPosition(gun);
    
  local get = AI.GetAnchorCustomParam(anchor, 2);
  
  if (get == "true") then
  
     if (Level.GotLuger == false and
         Level.IsAtBBox( {-903.0315, 37.3342, 1319.5258, 
                          -900.0315, 40.3342, 1322.5258}, pos)) then

       local animation = AI.GetAnchorCustomParam(anchor, 1);

       if (animation != "") then
          AI.DoCustomAnimationEx( npc, animation );
       end

     else
       AI.DoCustomAnimationEx( npc, "Relaxed_Talk_Scratch2" );
     end
     
  else

     local animation = AI.GetAnchorCustomParam(anchor, 1);

     if (animation != "") then     
        AI.DoCustomAnimationEx( npc, animation );
     end
     
  end

  return true;
end

--------------------------------------------------------
-- Name: Anchor:Notify()
-- Desc:
--------------------------------------------------------
function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "GutGunAnchor::Notify");
  return true;
end

--------------------------------------------------------
-- Name: Anchor:Stop()
-- Desc:
--------------------------------------------------------
function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "GutGunAnchor::Stop");
  NPC.Stand(npc);

  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_DEFAULT );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );


  return true;
end

--------------------------------------------------------
-- Name: Anchor:Execute()
-- Desc:
--------------------------------------------------------
function Anchor:Execute( anchor, npc )
  AI.Debug(npc, "Anchor", "GutGunAnchor::Execute");

  local gun = Level.FindWeaponItem('LGSL');
  local pos = Level.GetEntityPosition(gun);


  local get = AI.GetAnchorCustomParam(anchor, 2);
  if (get == "true") then
  
     if (Level.GotLuger == false and
         Level.IsAtBBox( {-903.0315, 37.3342, 1319.5258, 
                          -900.0315, 40.3342, 1322.5258}, pos)) then
        
         Entity.SetHidden( gun, true );
         
         Level.EnableItemPickup( gun, false );
         
         -- Add gun to spy
         local pistol     = Level.CreateItem("NaganSilencer", "Weapon");         
         
         Entity.SetUniqueID( pistol, 'PIST' );
         Actor.PutWeapon( AI.GetActor(npc), Actor.WEAPON_SLOT_PISTOL , pistol );
        
     end
  
  else
  
     Entity.SetHidden( gun, false );
     
     Actor.RemoveWeapon(AI.GetActor(npc), 'PIST');
     
     Level.EnableItemPickup( gun, true );
  
  end

  return true;
end