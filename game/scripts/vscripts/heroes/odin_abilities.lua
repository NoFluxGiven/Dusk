function gungnir_deprecated(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition()

	local damage = keys.damage or 350
	local stunduration = keys.stunduration or 3

	local radius = keys.radius

	local gungnir_remove = true

	local passthrough = false

	if caster:HasScepter() then
		damage = keys.scepter_damage
		gungnir_remove = false
		passthrough = true
	end

	local cpos = caster:GetAbsOrigin()

	local distance = GetDistance(cpos,target)
	local direction = (target - cpos):Normalized()

	local time = 3

	local speed = distance/time

	if speed < 500 then
		speed = 500
		time = distance/speed
	end

	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,3)

	if not caster.gungnir_prop:IsNull() and gungnir_remove then caster.gungnir_prop:RemoveSelf() end

	if gungnir_remove then keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_gungnir_no_attack", {}) end

	local projectile = {
  --EffectName = "particles/test_particle/ranged_tower_good.vpcf",
  --EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
  EffectName = "particles/units/heroes/hero_odin/odin_gungnir.vpcf",
  --EeffectName = "",
  --vSpawnOrigin = hero:GetAbsOrigin(),
  vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
  fDistance = 99999,
  fStartRadius = 100,
  fEndRadius = 100,
  Source = caster,
  fExpireTime = time,
  vVelocity = direction * speed, -- RandomVector(1000),
  UnitBehavior = PROJECTILES_NOTHING,
  bMultipleHits = false,
  bIgnoreSource = true,
  TreeBehavior = PROJECTILES_NOTHING,
  bCutTrees = false,
  bTreeFullCollision = false,
  WallBehavior = PROJECTILES_NOTHING,
  GroundBehavior = PROJECTILES_NOTHING,
  fGroundOffset = 80,
  nChangeMax = 1,
  bRecreateOnChange = true,
  bZCheck = false,
  bGroundLock = true,
  bProvidesVision = true,
  iVisionRadius = 450,
  iVisionTeamNumber = caster:GetTeam(),
  bFlyingVision = true,
  fVisionTickTime = .1,
  fVisionLingerDuration = 2,
  draw = true,--             draw = {alpha=1, color=Vector(200,0,0)},
  --iPositionCP = 0,
  --iVelocityCP = 1,
  --ControlPoints = {[5]=Vector(100,0,0), [10]=Vector(0,0,1)},
  --ControlPointForwards = {[4]=hero:GetForwardVector() * -1},
  --ControlPointOrientations = {[1]={hero:GetForwardVector() * -1, hero:GetForwardVector() * -1, hero:GetForwardVector() * -1}},
  --[[ControlPointEntityAttaches = {[0]={
    unit = hero,
    pattach = PATTACH_ABSORIGIN_FOLLOW,
    attachPoint = "attach_attack1", -- nil
    origin = Vector(0,0,0)
  }},]]
  --fRehitDelay = .3,
  --fChangeDelay = 1,
  --fRadiusStep = 10,
  --bUseFindUnitsInRadius = false,
  UnitTest = function(self, unit) return true end,
  OnUnitHit = function(self, unit)
  	if passthrough then
  		DealDamage(v,caster,damage/3,DAMAGE_TYPE_MAGICAL)
  	end
  end,
  --OnTreeHit = function(self, tree) ... end,
  --OnWallHit = function(self, gnvPos) ... end,
  --OnGroundHit = function(self, groundPos) ... end,
  OnFinish = function(self, pos)
  	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          pos,
                          nil,
                        radius,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        DOTA_UNIT_TARGET_FLAG_NONE,
                        FIND_CLOSEST,
                        false)
  	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_odin/gungnir_explosion_model.vpcf", PATTACH_CUSTOMORIGIN, caster) --[[Returns:int
  	Creates a new particle effect
  	]]
  	ParticleManager:SetParticleControl(p, 0, pos) --[[Returns:void
  	Set the control point data for a control on a particle effect
  	]]

  	ScreenShake(pos, 50, 5, 4, 1500, 0, true) --[[Returns:void
  	Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
  	]]




  	for k,v in pairs(found) do
  		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
  		v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stunduration}) --[[Returns:void
  		No Description Set
  		]]
  	end
  end,
}

Projectiles:CreateProjectile(projectile)
end

function gungnir(keys)
  local caster = keys.caster
  local target = caster:GetCursorPosition()

  local damage = keys.damage or 350
  local stunduration = keys.stunduration or 3

  local radius = keys.radius

  local gungnir_remove = true

  local passthrough = false

  if caster:HasScepter() then
    damage = keys.scepter_damage
    gungnir_remove = false
    passthrough = true
  end

  local cpos = caster:GetAbsOrigin()

  local distance = GetDistance(cpos,target)
  local direction = (target - cpos):Normalized()

  local time = 2

  keys.ability:CreateVisibilityNode(target, radius, time*2) --[[Returns:void
  No Description Set
  ]]

  local unit = FastDummy(target, caster:GetTeam(), time*2, 0)

  local p = ParticleManager:CreateParticle("particles/units/heroes/hero_odin/odin_gungnir_throw_spear_model.vpcf", PATTACH_ABSORIGIN, caster) --[[Returns:int
    Creates a new particle effect
    ]]

  --caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2)

  if gungnir_remove then removePropFromUnit(caster,"odin_spear") end

  if gungnir_remove then keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_gungnir_no_attack", {}) end

  Timers:CreateTimer(time, function()

    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_odin/odin_gungnir_land.vpcf", PATTACH_CUSTOMORIGIN, unit) --[[Returns:int
    Creates a new particle effect
    ]]
    ParticleManager:SetParticleControl(p, 0, target) --[[Returns:void
      Set the control point data for a control on a particle effect
      ]]
  end)
  Timers:CreateTimer(time+0.2, function()
    ScreenShake(target, 50, 5, 4, 1500, 0, true) --[[Returns:void
      Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
      ]]

    EmitSoundOnLocationWithCaster(target,"Hero_Phoenix.SuperNova.Explode",caster)
    --EmitSoundOnLocationWithCaster(target,"Ability.FrostNova",caster)
    local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                        radius,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        DOTA_UNIT_TARGET_FLAG_NONE,
                        FIND_CLOSEST,
                        false)

    for k,v in pairs(found) do
      DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
      v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stunduration}) --[[Returns:void
      No Description Set
      ]]
    end
  end)
end

function Rearm(keys)
	local caster = keys.caster

  attachPropToUnit(caster, "attach_attack1", "models/items/phantom_lancer/sunspear/sunspear.vmdl", 1.2,"odin_spear")
end

function GodEye(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition()

	local radius = keys.radius

	local duration = keys.duration

	local true_sight = keys.true_sight == 1

	keys.ability:CreateVisibilityNode(target, radius, duration) --[[Returns:void
	No Description Set
	]]

	local unit = FastDummy(target, caster:GetTeam(), duration, 0)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_odin/odin_godseye.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 0, target) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_godseye_aura", {})

	if true_sight then
    --keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_godseye_truesight", {})
		--[[
    local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                        radius,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        DOTA_UNIT_TARGET_FLAG_NONE,
                        FIND_CLOSEST,
                        false)

		for k,v in pairs(found) do
			v:AddNewModifier(caster, nil, "modifier_truesight", {Duration=duration*2})
		end
    ]]
	end
end

function CheckInvisible(keys)
  local caster = keys.caster
  local target = keys.target

  if target:IsInvisible() then
    keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_godseye_invis_punish", {}) --[[Returns:void
    No Description Set
    ]]
    target:AddNewModifier(caster, nil, "modifier_truesight", {Duration=0.2, IsHidden=true}) --[[Returns:void
    No Description Set
    ]]
  end

  if target:IsIllusion() then
    target:Kill(keys.ability, caster) --[[Returns:void
    Kills this NPC, with the params Ability and Attacker
    ]]
  end
end

function oppression_increment(keys)
	local caster = keys.caster
	local target = keys.attacker

	if target:IsMagicImmune() then return end
	if CheckClass(target,"npc_dota_roshan") or CheckClass(target,"npc_dota_building") then return end
  if target:IsInvulnerable() then return end
  if caster:PassivesDisabled() then return end

	local mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_oppression_effect", {}) --[[Returns:void
	No Description Set
	]]

	if not mod then
		mod = target:FindModifierByName("modifier_oppression_effect")
	end

	if not mod then return end

	mod:IncrementStackCount()
end