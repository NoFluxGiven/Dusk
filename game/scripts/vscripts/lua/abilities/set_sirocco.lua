set_sirocco = class({})

LinkLuaModifier("modifier_sirocco_thinker","lua/abilities/set_sirocco",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirocco_thinker_enemy","lua/abilities/set_sirocco",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirocco_aura_ally","lua/abilities/set_sirocco",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirocco_aura_enemy","lua/abilities/set_sirocco",LUA_MODIFIER_MOTION_NONE)

function set_sirocco:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local pos = caster:GetAbsOrigin()

		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")

		caster:AddNewModifier(caster, self, "modifier_sirocco_display", {Duration=duration})

		local thinker = CreateModifierThinker( caster, self, "modifier_sirocco_thinker", {Duration=duration}, pos, caster:GetTeamNumber(), false )
		CreateModifierThinker( caster, self, "modifier_sirocco_thinker_enemy", {Duration=duration}, pos, caster:GetTeamNumber(), false )

		thinker:EmitSound("Hero_Warlock.Upheaval")

		ScreenShake(pos, 200, 80, duration, 600, 0, true)

		local p = WorldParticle( "particles/units/heroes/hero_set/set_sinkhole.vpcf", pos, { Vector(radius,0,0) } )

		Timers:CreateTimer(duration-0.50,function()
			thinker:StopSound("Hero_Warlock.Upheaval")
			ParticleManager:DestroyParticle(p,false)
		end)
	end
end

modifier_sirocco_thinker = class({})

function modifier_sirocco_thinker:IsAura()
	return true
end

function modifier_sirocco_thinker:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_sirocco_thinker:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_sirocco_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_sirocco_thinker:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_sirocco_thinker:GetModifierAura()
	return "modifier_sirocco_aura_ally"
end

modifier_sirocco_thinker_enemy = class({})

function modifier_sirocco_thinker_enemy:IsAura()
	return true
end

function modifier_sirocco_thinker_enemy:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_sirocco_thinker_enemy:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_sirocco_thinker_enemy:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sirocco_thinker_enemy:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_sirocco_thinker_enemy:GetModifierAura()
	return "modifier_sirocco_aura_enemy"
end

modifier_sirocco_aura_ally = class({})

function modifier_sirocco_aura_ally:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_sirocco_aura_ally:OnIntervalThink()
	if IsServer() then
		local p = self:GetParent()
		local c = self:GetAbility():GetCaster()
		local heal = self:GetAbility():GetSpecialValueFor("damage") * 0.25

		if ( p == c ) or ( p:GetOwner() == c ) then
			p:Heal(heal, c)
		end
	end
end

function modifier_sirocco_aura_ally:IsHidden()
	return true
end

modifier_sirocco_aura_enemy = class({})

function modifier_sirocco_aura_enemy:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION
	}
	return func
end

function modifier_sirocco_aura_enemy:GetFixedDayVision()
	return self:GetAbility():GetSpecialValueFor("vision_change")
end

function modifier_sirocco_aura_enemy:GetFixedNightVision()
	return self:GetAbility():GetSpecialValueFor("vision_change")
end

function modifier_sirocco_aura_enemy:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_sirocco_aura_enemy:OnIntervalThink()
	if IsServer() then
		local p = self:GetParent()
		local c = self:GetAbility():GetCaster()
		if p:IsBuilding() then return end

		local damage = self:GetAbility():GetSpecialValueFor("damage") * 0.25
		self:GetAbility():InflictDamage(p,c,damage,DAMAGE_TYPE_MAGICAL)
	end
end

modifier_sirocco_display = class({})