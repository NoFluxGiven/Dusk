gemini_extraplanar_pact = class({})

LinkLuaModifier("modifier_extraplanar_pact_oog","lua/modifiers/modifier_extraplanar_pact_oog",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_extraplanar_pact","lua/modifiers/modifier_extraplanar_pact",LUA_MODIFIER_MOTION_NONE)

function gemini_extraplanar_pact:OnSpellStart()
	local mod = "modifier_extraplanar_pact_oog"
	local mod2 = "modifier_extraplanar_pact"

	local oog_dur = self:GetSpecialValueFor("out_of_game_duration")
	local dur = self:GetSpecialValueFor("duration")

	local hp_mana = self:GetSpecialValueFor("health_and_mana_loss")/100

	local part = "particles/units/heroes/hero_gemini/gemini_extraplanar_pact_oog.vpcf"

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local remove_health = hp_mana * target:GetHealth()
	local remove_mana = hp_mana * target:GetMana()

	target:AddNewModifier(caster, self, mod, {Duration = oog_dur}) --[[Returns:void
	No Description Set
	]]

	target:EmitSound("Voidwalker.ExtraplanarEmpowerment")

	Timers:CreateTimer(0.25,function()

		target:AddNoDraw()

		target:ModifyHealth(target:GetHealth()-remove_health, self, false, 0) --[[Returns:void
		Sets the health to a specific value, with optional flags or inflictors.
		]]
		target:ReduceMana(remove_mana) --[[Returns:void
		Remove mana from this unit, this can be used for involuntary mana loss, not for mana that is spent.
		]]

		target:AddNewModifier(caster, self, mod2, {Duration = dur}) --[[Returns:void
		No Description Set
		]]

	end)

	local unit = FastDummy(target:GetAbsOrigin(),caster:GetTeam(),oog_dur+1,175)

	local p = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	Timers:CreateTimer(oog_dur,function()
		ParticleManager:DestroyParticle(p,false)
		target:RemoveNoDraw()
	end)
end