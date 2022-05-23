phantom_nightmare = class({})

LinkLuaModifier("modifier_nightmare","lua/abilities/phantom_nightmare",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nightmare_caster","lua/abilities/phantom_nightmare",LUA_MODIFIER_MOTION_NONE)

function phantom_nightmare:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = 8--self:GetSpecialValueFor("duration")

	local t_aoe = caster:FindTalentValue("special_bonus_phantom_3")

	local enemies

	if t_aoe then
		enemies = FindEnemies( caster, target:GetAbsOrigin(), t_aoe )
	else
		enemies = {[0] = target}
	end

	for k,v in pairs(enemies) do
		v:AddNewModifier(caster, self, "modifier_nightmare", {Duration=duration})
		CreateParticleHitloc(v,"particles/units/heroes/hero_phantom/nightmare.vpcf")
	end

	caster:AddNewModifier(caster, self, "modifier_nightmare_caster", {Duration=duration})
	-- Sound

end

modifier_nightmare = class({})

function modifier_nightmare:OnCreated()
	-- particle
	-- sound

	-- effect
	-- self.stat_reduction = self:GetAbility():GetSpecialValueFor("stat_reduction")
	if IsServer() then
		self.parent_team = self:GetParent():GetTeam()
		local team_to_set = DOTA_TEAM_CUSTOM_1
		-- GameRules:SetCustomGameTeamMaxPlayers(team_to_set, 10)
		self:GetParent():ChangeTeam(team_to_set)
		self:GetParent():GetPlayerOwner():SetTeam(team_to_set)
		--self:GetParent():MakeVisibleToTeam(DOTA_TEAM_CUSTOM_1, self:GetDuration())
	end
end

function modifier_nightmare:OnDestroy()
	-- particle
	-- sound

	-- effect
	-- self.stat_reduction = self:GetAbility():GetSpecialValueFor("stat_reduction")
	if IsServer() then
		self:GetParent():ChangeTeam(self.parent_team)
		self:GetParent():GetPlayerOwner():SetTeam(self.parent_team)
	end
end

function modifier_nightmare:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		-- MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
		-- MODIFIER_EVENT_ON_ABILITY_START
	}
end

function modifier_nightmare:GetEffectName()
	return "particles/units/heroes/hero_phantom/nightmare_unit.vpcf"
end

-- function modifier_nightmare:OnAbilityStart(params)
-- 	if params.caster:IsHero() and params.caster:GetTeam() == self:GetParent():GetTeam() and params.unit == self:GetParent() then
-- 		-- Sound
-- 		-- Particle
-- 		-- Modifier to prevent particle/sound spamming
-- 		params.caster:Interrupt()
-- 	end
-- end

modifier_nightmare_caster = class({})