elena_guardian_bubble = class({})

LinkLuaModifier("modifier_guardian_bubble","lua/abilities/elena_guardian_bubble",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guardian_bubble_damage_cooldown","lua/abilities/elena_guardian_bubble",LUA_MODIFIER_MOTION_NONE)

function elena_guardian_bubble:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local t_block_bonus = self:GetCaster():FindTalentValue("special_bonus_elena_4") or 0
	local block = self:GetSpecialValueFor("block") + t_block_bonus

	local particle = "particles/units/heroes/hero_elena/guardian_bubble.vpcf"
	local sound = "Hero_TemplarAssassin.Refraction"

	if target then
		target:EmitSound(sound)
		local p = CreateParticleHitloc(target,particle)
		local mod = target:AddNewModifier(caster, self, "modifier_guardian_bubble", {Duration=duration, stack=block}) --[[Returns:void
		No Description Set
		]]
		mod:AddParticle( p, false, false, 10, false, false )
	end
end

modifier_guardian_bubble = class({})

function modifier_guardian_bubble:DeclareFunctions()
	local funcs = {

	}
	return funcs
end

function modifier_guardian_bubble:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}

	return state
end

if IsServer() then

	-- function modifier_guardian_bubble:OnTakeDamage(params)
	-- 	if params.unit ~= self:GetParent() then return end
	-- 	if not self:GetParent():HasModifier("modifier_guardian_bubble_damage_cooldown") then
	-- 		local sound = "Hero_TemplarAssassin.Refraction.Absorb"
	-- 		local particle = "particles/units/heroes/hero_elena/guardian_bubble_hit.vpcf"

	-- 		local damage = params.original_damage

	-- 		local attacker = params.attacker

	-- 		local block = self:GetAbility():GetSpecialValueFor("incoming_damage_block")

	-- 		local deal = block

	-- 		if damage < block then
	-- 			deal = damage
	-- 		end

	-- 		print("DAMAGE AND BLOCK:",damage,block)

	-- 		if attacker then
	-- 			if not attacker:IsBuilding() then
	-- 				--Particle
	-- 				self:GetAbility():InflictDamage(attacker,self:GetAbility():GetCaster(),deal,DAMAGE_TYPE_MAGICAL)
	-- 			end
	-- 		end

	-- 		CreateParticleHitloc(self:GetParent(),particle)
	-- 		self:GetParent():EmitSound(sound)

	-- 		self:SetStackCount(self:GetStackCount()-1)
	-- 		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_guardian_bubble_damage_cooldown", {Duration=0.1})
	-- 		if self:GetStackCount() <= 0 then
	-- 			self:Destroy()
	-- 		end
	-- 	end
	-- end

	-- function modifier_guardian_bubble:OnCreated(kv)
	-- 	if kv.stack then
	-- 		self:SetStackCount(kv.stack)
	-- 	end
	-- end

	-- function modifier_guardian_bubble:OnRefresh(kv)
	-- 	if kv.stack then
	-- 		self:SetStackCount(kv.stack+self:GetStackCount())
	-- 	end
	-- end

end

function modifier_guardian_bubble:IsPurgable()
	return true
end

modifier_guardian_bubble_damage_cooldown = class({})

function modifier_guardian_bubble_damage_cooldown:IsHidden()
	return true
end