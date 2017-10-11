item_grim_gauntlet = class({})

LinkLuaModifier("modifier_grim_gauntlet","lua/items/item_grim_gauntlet",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_grim_gauntlet_slow","lua/items/item_grim_gauntlet",LUA_MODIFIER_MOTION_NONE)

function item_grim_gauntlet:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	self:Capture(caster,target)
end

function item_grim_gauntlet:GetIntrinsicModifierName()
	return "modifier_grim_gauntlet"
end

function item_grim_gauntlet:Capture(caster, target)
	if IsServer() then
		local caster = caster
		local target = target
		local damage = self:GetSpecialValueFor("damage")
		local maxcharge = self:GetSpecialValueFor("maxcharge")
		local charges = 0
		local health_perc = self:GetSpecialValueFor("health_perc")/100
		local mana_perc = self:GetSpecialValueFor("mana_perc")/100

		if target:IsAncient() then return end

		if target:IsHero() or CheckClass(target,"npc_dota_roshan") then
			charges = self:GetCurrentCharges()
			if charges > 0 then
				target:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Target")
				ParticleManager:CreateParticle("particles/items/grim_gauntlet_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
				local final_dmg = charges*damage
				Timers:CreateTimer(0.75,function()
					DealDamage(target,caster,final_dmg/5,DAMAGE_TYPE_MAGICAL)

				end)
				local n = 0
				Timers:CreateTimer(0.75,function()
					target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
					ParticleManager:CreateParticle("particles/items/grim_gauntlet_hero_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
					n = n+1
					DealDamage(target,caster,final_dmg/5,DAMAGE_TYPE_MAGICAL)
					if n < 4 then
						return 0.25
					end
				end
				)
				target:AddNewModifier(caster, self, "modifier_grim_gauntlet_slow", {Duration=charges*0.75}) --[[Returns:void
				No Description Set
				]]
				local mod = target:FindModifierByName("modifier_grim_gauntlet_slow")

				mod:SetStackCount(charges)

				self:SetCurrentCharges(0)
			else
				self:RefundManaCost()
				self:EndCooldown()
				return
			end
		else
			charges = self:GetCurrentCharges()
			local hp = target:GetHealth()
			local amt_health = hp*health_perc
			local amt_mana = hp*mana_perc

			target:EmitSound("Hero_Warlock.FatalBonds")

			caster:Heal(amt_health, caster)
			caster:GiveMana(amt_mana)

			target:Kill(self, caster)

			ParticleManager:CreateParticle("particles/items/grim_gauntlet.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]

			if charges < maxcharge then

				self:SetCurrentCharges(charges+1)

			end
		end
	end
end

modifier_grim_gauntlet = class({})

function modifier_grim_gauntlet:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return func
end

function modifier_grim_gauntlet:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_grim_gauntlet:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_grim_gauntlet:IsHidden()
	return true
end

modifier_grim_gauntlet_slow = class({})

function modifier_grim_gauntlet_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_grim_gauntlet_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow") * self:GetStackCount()
end