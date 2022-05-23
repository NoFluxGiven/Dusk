aeronaut_aerial_ace = class({})

LinkLuaModifier("modifier_aerial_ace","lua/abilities/aeronaut_aerial_ace",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_aerial_ace_slow","lua/abilities/aeronaut_aerial_ace",LUA_MODIFIER_MOTION_NONE)

function aeronaut_aerial_ace:GetIntrinsicModifierName()
	return "modifier_aerial_ace"
end

modifier_aerial_ace = class({})

function modifier_aerial_ace:IsHidden()
	return true
end

function modifier_aerial_ace:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER
	}
	return func
end

function modifier_aerial_ace:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed") * self:GetStackCount()
end

function modifier_aerial_ace:GetModifierAttackSpeedBonus_Constant()
	local t_attack_speed_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_aeronaut_2") or 0
	return ( self:GetAbility():GetSpecialValueFor("bonus_attack_speed") + t_attack_speed_bonus ) * self:GetStackCount()
end

function modifier_aerial_ace:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_aerial_ace:OnIntervalThink()
	if IsServer() then
		if self:GetParent():HasFlyMovementCapability() then
			self:SetStackCount(1)
		else
			self:SetStackCount(0)
		end
	end
end

function modifier_aerial_ace:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local target = kv.target

		local slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")

		local t_bash = attacker:FindTalentValue("special_bonus_aeronaut_3")

		if attacker == self:GetParent() then
			if attacker:HasFlyMovementCapability() and not target:HasFlyMovementCapability() and not target:IsBuilding() then
				-- if the attacker is flying and the target is not:

				if target:IsMagicImmune() then return end
				
				target:AddNewModifier(attacker, self:GetAbility(), "modifier_aerial_ace_slow", {Duration=slow_duration})
				--self:GetAbility():InflictDamage(target,attacker,damage,DAMAGE_TYPE_PHYSICAL)

				target:EmitSound("Aeronaut.AerialAce.Hit")

				if t_bash then
					local r = RandomInt(0, 100)

					if r < t_bash then
						target:AddNewModifier(attacker, nil, "modifier_stunned", {Duration=0.15})
						target:EmitSound("DOTA_Item.SkullBasher")
					end
				end
			end
		end
	end
end

modifier_aerial_ace_slow = class({})

function modifier_aerial_ace_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_aerial_ace_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end