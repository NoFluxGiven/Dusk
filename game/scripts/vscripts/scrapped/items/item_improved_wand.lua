item_improved_wand = class({})

LinkLuaModifier("modifier_improved_wand","lua/items/item_improved_wand",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_improved_wand_oncast","lua/items/item_improved_wand",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_improved_wand_cooldown","lua/items/item_improved_wand",LUA_MODIFIER_MOTION_NONE)

function item_improved_wand:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		local charges = self:GetCurrentCharges()

		local cooldown = self:GetCooldownTimeRemaining()

		local restore = self:GetSpecialValueFor("restore_per_charge")
		local percent = self:GetSpecialValueFor("percent_per_charge") / 100

		local hp = target:GetMaxHealth()
		local mp = target:GetMaxMana()

		local hp_amt = ( hp * ( percent * charges ) ) + ( restore * charges )
		local mp_amt = ( mp * ( percent * charges ) ) + ( restore * charges )

		--Sound
		ParticleManager:CreateParticle("particles/items/improved_magic_wand.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

		self:SetCurrentCharges(0)

		if not target:HasModifier("modifier_improved_wand_cooldown") then

			target:Heal(hp_amt, caster)
			target:GiveMana(mp_amt)

			target:AddNewModifier(caster, self, "modifier_improved_wand_cooldown", {Duration=cooldown})

		end
	end
end

function item_improved_wand:GetIntrinsicModifierName()
	return "modifier_improved_wand"
end

modifier_improved_wand = class({})

function modifier_improved_wand:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_improved_wand:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return func
end

function modifier_improved_wand:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_improved_wand:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_improved_wand:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_improved_wand:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_improved_wand:OnCreated(kv)
	if IsServer() then
		self:CreateSubModifier("modifier_improved_wand_oncast",{})
	end
end

function modifier_improved_wand:OnDestroy(kv)
	if IsServer() then
		self:DestroySubModifiers()
	end
end

function modifier_improved_wand:IsHidden()
	return true
end

modifier_improved_wand_oncast = class({})

function modifier_improved_wand_oncast:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return func
end


function modifier_improved_wand_oncast:OnAbilityFullyCast(params)
	if IsServer() then
		local caster = params.unit
		local parent = self:GetParent()

		local range = self:GetAbility():GetSpecialValueFor("range")

		local ability = params.ability
		local name = ability:GetName()
		local procs = ability:ProcsMagicStick()
		local in_range = caster:GetRangeToUnit(parent) <= range
		local is_enemy = caster:GetTeam() ~= parent:GetTeam()

		if procs and in_range and is_enemy then
			local charges = self:GetAbility():GetCurrentCharges()
			local max_charges = self:GetAbility():GetSpecialValueFor("max_charges")

			if charges < max_charges then
				self:GetAbility():SetCurrentCharges(charges+1)
			end

			local ignore_list = {
			"item_magic_stick",
			"item_magic_wand"
			}

			for i=0,5 do
				local item = parent:GetItemInSlot(i)

				if item then
					local item_name = item:GetName()
					for k,v in pairs(ignore_list) do
						if v == item_name then
							item:SetCurrentCharges(item:GetCurrentCharges()-1)
						end
					end
				end
			end
		end
	end
end

function modifier_improved_wand_oncast:IsHidden()
	return true
end

modifier_improved_wand_cooldown = class({})
