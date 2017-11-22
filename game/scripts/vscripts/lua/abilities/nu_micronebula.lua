nu_micronebula = class({})

LinkLuaModifier("modifier_micronebula","lua/abilities/nu_micronebula",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_micronebula_tracker","lua/abilities/nu_micronebula",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_micronebula_display","lua/abilities/nu_micronebula",LUA_MODIFIER_MOTION_NONE)

function nu_micronebula:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	if target:TriggerSpellAbsorb(self) then return end

	target:EmitSound("Fate.ChainsOfFate.Start")
	target:EmitSound("Fate.ChainsOfFate.Ambience")

	target:AddNewModifier(caster, self, "modifier_micronebula_tracker", {Duration=duration})
	target:AddNewModifier(caster, self, "modifier_micronebula_display", {Duration=duration})
end

modifier_micronebula_tracker = class({})

function modifier_micronebula_tracker:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return func
end

function modifier_micronebula_tracker:OnTakeDamage(params)
	if IsServer() then
		local attacker = params.attacker
		local unit = params.target or params.unit

		local t_pct_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_nu_1") or 0

		local pct = ( self:GetAbility():GetSpecialValueFor("damage") + t_pct_bonus ) / 100

		local damage = math.ceil(params.damage * pct)

		if unit == self:GetParent() then
			self:SetStackCount(self:GetStackCount()+damage)
		end
	end
end

function modifier_micronebula_tracker:OnCreated()
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/micronebula_full.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle( p, false, false, 10, false, false )
end

function modifier_micronebula_tracker:OnDestroy()
	if IsServer() then
		if not self:WasPurged() then
			local damage_duration = self:GetAbility():GetSpecialValueFor("damage_duration")
			local total_damage = self:GetStackCount()
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_micronebula", {Duration=damage_duration,damage=total_damage})
		end
	end
end

function modifier_micronebula_tracker:IsHidden()
	return true
end

modifier_micronebula = class({})

function modifier_micronebula:OnCreated(kv)
	if IsServer() then
		local duration = self:GetDuration()
		local interval = 0.1

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/micronebula_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle( p, false, false, 10, false, false )

		self:GetParent():EmitSound("Hero_TemplarAssassin.Trap")

		self.damage = math.ceil(( kv.damage / duration ) * interval)
		self:StartIntervalThink(interval)
	end
end

function modifier_micronebula:OnIntervalThink()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),radius)
		for k,v in pairs(enemies) do
			self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),self.damage,DAMAGE_TYPE_MAGICAL)
		end
		
	end
end

modifier_micronebula_display = class({})