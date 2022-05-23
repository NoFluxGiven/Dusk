bloodwarrior_blood_rain = class({})

LinkLuaModifier("modifier_blood_rain","lua/abilities/bloodwarrior_blood_rain",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blood_rain_thinker","lua/abilities/bloodwarrior_blood_rain",LUA_MODIFIER_MOTION_NONE)

function bloodwarrior_blood_rain:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")

	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_bloodwarrior_1") or 0

	local duration = self:GetSpecialValueFor("rain_duration") + t_duration_bonus

	CreateModifierThinker( caster, self,
		"modifier_blood_rain_thinker", {Duration=duration+0.25}, point, caster:GetTeamNumber(), false )

	local fx = CreateModifierThinker( caster, self,
		"modifier_truesight", {Duration=duration+1.25}, point, caster:GetTeamNumber(), false )

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/blood_rain.vpcf", PATTACH_ABSORIGIN_FOLLOW, fx) --[[Returns:int
		Creates a new particle effect
		]]

	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	Timers:CreateTimer(duration,function()
		ParticleManager:DestroyParticle(p,false)
	end)
end

modifier_blood_rain_thinker = class({})

if IsServer() then

	function modifier_blood_rain_thinker:OnCreated()
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.damage = self:GetAbility():GetSpecialValueFor("damage") -- per second
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self.mod = "modifier_blood_rain"

		self:GetParent():EmitSound("Bloodwarrior.BloodRain")

		self:StartIntervalThink(0.1)
	end

	function modifier_blood_rain_thinker:OnIntervalThink()
		local radius = self.radius
		local damage = self.damage*0.1
		local mod = self.mod
		local duration = self.duration

		local f = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),radius)

		for k,v in pairs(f) do
			self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
			v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), mod, {Duration=duration})
		end
	end

end

modifier_blood_rain = class({})

function modifier_blood_rain:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_blood_rain:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_blood_rain:OnAttackLanded(params)
	local attacker = params.attacker
	local target = params.target

	if target ~= self:GetParent() then return end

	local lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")/100

	local damage = params.damage

	local amt = lifesteal*damage

	attacker:Heal(amt, self:GetAbility():GetCaster())

	GenericParticle(attacker,"LIFESTEAL")
end