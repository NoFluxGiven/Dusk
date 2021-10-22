lupin_last_surprise = class({})

LinkLuaModifier("modifier_calling_card","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_calling_card_thinker","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_calling_card_buff","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_calling_card_debuff","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_calling_card_caster","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)

function lupin_last_surprise:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_calling_card_caster") then
		return "lupin_flashbang" -- placeholder
	end
	return "lupin_last_surprise"
end

function lupin_last_surprise:GetBehavior()
	if self:GetCaster():HasModifier("modifier_calling_card_caster") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return self.BaseClass.GetBehavior(self)
end

function lupin_last_surprise:GetManaCost(level)
	if self:GetCaster():HasModifier("modifier_calling_card_caster") then
		return 0
	end
	return self.BaseClass.GetManaCost(self, level)
end

function lupin_last_surprise:GetCastRange(location, target)
	if self:GetCaster():HasModifier("modifier_calling_card_caster") then
		return 0
	end
	return self.BaseClass.GetCastRange(self, location, target)
end

function lupin_last_surprise:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_calling_card_caster") then
		caster:EmitSound("Lupin.CallingCard.Slash")
	end
	return true
end

function lupin_last_surprise:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_calling_card_caster") then
		caster:StopSound("Lupin.CallingCard.Slash")
	end
	return true
end

function lupin_last_surprise:OnSpellStart()
	-- if IsServer() then

		-- sound
		local caster = self:GetCaster()
		local sourcepos = caster:GetCenter()
		local targetpos = self:GetCursorPosition() - Vector(0,0,50)
		local dir = (targetpos - sourcepos):Normalized()
		local range = (sourcepos - targetpos):Length2D()
		local speed = 1250

		if caster:HasModifier("modifier_calling_card_caster") then
			-- different behaviour with return
			caster:FindModifierByName("modifier_calling_card_caster"):Activate()
			-- self:RefundManaCost()
			return
		end

		
		local soundsource = caster
		local radius = 80
		-- local scepter_radius = self:GetSpecialValueFor("scepter_radius")

		-- sound

		local info = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_lupin/darting_shadow_projectile.vpcf",
	    	vSpawnOrigin = sourcepos,
	    	fDistance = range,
	    	fStartRadius = radius,
	    	fEndRadius = radius,
	    	Source = source,
	    	bHasFrontalCone = false,
	    	bReplaceExisting = false,
	    	iUnitTargetTeam = 0,
	    	iUnitTargetFlags = 0,
	    	iUnitTargetType = 0,
	    	fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = dir * speed,
			bProvidesVision = true,
			iVisionRadius = 275,
			iVisionTeamNumber = caster:GetTeamNumber(),
			-- ExtraData = extradata
		}
		ProjectileManager:CreateLinearProjectile(info) --[[Returns:int
		Creates a linear projectile and returns the projectile ID
		]]

		caster:EmitSound("Lupin.CallingCard.Throw")
end

function lupin_last_surprise:OnProjectileHit(target, location)
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	-- should have reached the end of its travel time

	if not target and caster:IsAlive() then
		self:EndCooldown()
		self.calling_card_thinker_position = location

		self.calling_card_thinker = CreateModifierThinker(caster, self, "modifier_calling_card_thinker", {}, location, caster:GetTeamNumber(), false)

		caster:AddNewModifier(caster, self, "modifier_calling_card_caster", {duration=duration-0.03})

		self:StartCooldown(0.3)

		self.calling_card_thinker_particle = CreateParticleWorld(location, "particles/units/heroes/hero_lupin/calling_card.vpcf")
		ParticleManager:SetParticleControl(self.calling_card_thinker_particle, 1, Vector(radius, 0,0))

		EmitSoundOn("Lupin.CallingCard.Land", self.calling_card_thinker)
		
	end
end

--------------------------------------------------------------------------------------------------------------

modifier_calling_card_thinker = class({})

function modifier_calling_card_thinker:IsHidden() return true end
function modifier_calling_card_thinker:IsPurgable() return false end

function modifier_calling_card_thinker:OnCreated(kv)
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
	AddFOWViewer(self:GetAbility():GetCaster():GetTeamNumber(), self:GetAbility().calling_card_thinker_position, self:GetAbility():GetSpecialValueFor("radius"), 0.12, false)
end

function modifier_calling_card_thinker:OnIntervalThink()
	if not IsServer() then return end
	AddFOWViewer(self:GetAbility():GetCaster():GetTeamNumber(), self:GetAbility().calling_card_thinker_position, self:GetAbility():GetSpecialValueFor("radius"), 0.12, false)
end

function modifier_calling_card_thinker:OnDestroy()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------------------------------------

modifier_calling_card_caster = class({})

function modifier_calling_card_caster:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	else
		return true
	end

	
end
function modifier_calling_card_caster:IsPurgable() return false end

function modifier_calling_card_caster:OnCreated(kv)
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("debuff_duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.radius_increase_per_stack = self:GetAbility():GetSpecialValueFor("radius_increase_per_stack")
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.armor_steal_per_stack = self:GetAbility():GetSpecialValueFor("armor_steal_per_stack")
	self.damage_steal_per_stack = self:GetAbility():GetSpecialValueFor("damage_steal_per_stack")

	if self:GetAbility():GetCaster():HasScepter() then
		self.interval = self:GetAbility():GetSpecialValueFor("scepter_interval")
		self.max_stacks = self:GetAbility():GetSpecialValueFor("scepter_max_stacks")
	end

	self:SetStackCount(0)

	self:StartIntervalThink(self.interval)
end

function modifier_calling_card_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
	return funcs
end

function modifier_calling_card_caster:OnTooltip()
	return self:GetStackCount() * self.armor_steal_per_stack
end
function modifier_calling_card_caster:OnTooltip2()
	return self:GetStackCount() * self.damage_steal_per_stack
end

function modifier_calling_card_caster:OnIntervalThink()
	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()

		if not IsServer() then return end

		local inc = 254 / 6
		self:GetAbility().calling_card_thinker:EmitSoundParams("Lupin.CallingCard.Pulse."..self:GetStackCount(), 1, 0.8 + self:GetStackCount() * 0.1, 0)

		local radius = self.radius + self.radius_increase_per_stack * self:GetStackCount()
		if self:GetAbility().calling_card_thinker_particle ~= nil then
			ParticleManager:SetParticleControl(self:GetAbility().calling_card_thinker_particle, 1, Vector(radius, 0,0))
		end
	end
end

function modifier_calling_card_caster:OnDestroy()
	if not IsServer() then return end
	
	local t = self:GetAbility().calling_card_thinker

	if IsValidEntity(t) then
		t:Destroy()
	end

	self:GetAbility():UseResources(false, false, true)
	
	if self:GetAbility().calling_card_thinker_particle ~= nil then
		ParticleManager:DestroyParticle(self:GetAbility().calling_card_thinker_particle, false)
	end
end

---@func Activate
---@desc Teleports the caster to the location of the Calling Card thinker, damaging enemies in an AoE, and stealing their Gold, damage and Armor.
function modifier_calling_card_caster:Activate()
	if not IsServer() then return end

	local caster = self:GetAbility():GetCaster()
	local thinker= self:GetAbility().calling_card_thinker
	local buffer = 10
	local radius = self.radius + self.radius_increase_per_stack * self:GetStackCount() + buffer
	local thinker_pos = thinker:GetAbsOrigin()
	local found = FindEnemies(caster,thinker_pos,radius)

	-- self.damage_per_stack = 40

	local total_gold = 0
	local cast_sound = "DOTA_Item.Hand_Of_Midas"

	-- local beneath_the_mask_ability = self:GetAbility():GetCaster():FindAbilityByName("lupin_beneath_the_mask")

	-- beneath_the_mask_ability:EndCooldown()

	-- DebugDrawCircle(thinker_pos, Vector(255,255,255), 0.5, radius, false, 20)

	for k,v in pairs(found) do

		print(v:GetName())

		if v:IsRealHero() then
			local gold_steal = self:GetAbility():GetSpecialValueFor("gold_steal_per_stack") * self:GetStackCount()
			total_gold = total_gold + gold_steal

			v:AddNewModifier(caster, self:GetAbility(), "modifier_calling_card_debuff", {duration=self.debuff_duration, stacks=self:GetStackCount()})
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_calling_card_buff", {duration=self.debuff_duration, stacks=self:GetStackCount()})
			-- local particleName = "particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf"
			-- local particle1 = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_ABSORIGIN, caster, player)
			-- ParticleManager:SetParticleControl(particle1, 0, v:GetCenter())
			-- ParticleManager:SetParticleControl(particle1, 1, caster:GetCenter())

			v:ModifyGold(-gold_steal, false, DOTA_ModifyGold_Unspecified)
		end
		CreateParticleHitloc(v, "particles/units/heroes/hero_lupin/calling_card_unit.vpcf")
		DealDamage(v,caster,self.damage_per_stack * self:GetStackCount(),self:GetAbility():GetAbilityDamageType(),self:GetAbility(),DOTA_DAMAGE_FLAG_BYPASSES_BLOCK+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	end

	ScreenShake(caster:GetCenter(), 100, 4, 0.4, 600, 0, true)

	local player = PlayerResource:GetPlayer(caster:GetPlayerID())
	caster:ModifyGold(total_gold, false, DOTA_ModifyGold_Unspecified)
	caster:EmitSound(cast_sound)

	SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, caster, total_gold, nil)

	CreateParticleWorld(caster:GetAbsOrigin(), "particles/units/heroes/hero_lupin/ephemera.vpcf")

	FindClearSpaceForUnit(caster, self:GetAbility().calling_card_thinker:GetAbsOrigin(), true)

	ProjectileManager:ProjectileDodge(caster)

	Timers:CreateTimer(0.03, function()

		CreateParticleWorld(caster:GetAbsOrigin(), "particles/units/heroes/hero_lupin/ephemera.vpcf")

		local p2 = CreateParticleWorld(caster:GetAbsOrigin(), "particles/units/heroes/hero_lupin/calling_card_ring_activate.vpcf")
		ParticleManager:SetParticleControl(p2, 1, Vector(radius, 0,0))

		GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), radius, false)
	end)

	-- self:GetAbility():UseResources(true, true, true)
	self:Destroy()
end

--------------------------------------------------------------------------------------------------------------

modifier_calling_card_debuff = class({})

function modifier_calling_card_debuff:IsPurgable() return false end

function modifier_calling_card_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_calling_card_debuff:OnCreated(kv)
	--sound
	--particle
	self.armor_steal_per_stack = self:GetAbility():GetSpecialValueFor("armor_steal_per_stack")
	self.damage_steal_per_stack = self:GetAbility():GetSpecialValueFor("damage_steal_per_stack")

	self.interval = self:GetAbility():GetSpecialValueFor("interval")

	self:SetStackCount(kv.stacks)

	--- server block
	if not IsServer() then return end

	-- if self:GetAbility():GetCaster():HasScepter() then
		-- self:GetParent():Purge(true, false, false, false, false)
	-- end
end

function modifier_calling_card_debuff:GetModifierPhysicalArmorBonus()
	return -self:GetStackCount() * self.armor_steal_per_stack
end

function modifier_calling_card_debuff:GetModifierPreAttack_BonusDamage()
	return -self:GetStackCount() * self.damage_steal_per_stack
end

function modifier_calling_card_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -40
end

--------------------------------------------------------------------------------------------------------------

modifier_calling_card_buff = class({})

function modifier_calling_card_buff:IsPurgable() return false end

function modifier_calling_card_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_calling_card_buff:OnCreated(kv)
	--sound
	--particle
	self.armor_steal_per_stack = self:GetAbility():GetSpecialValueFor("armor_steal_per_stack")
	self.damage_steal_per_stack = self:GetAbility():GetSpecialValueFor("damage_steal_per_stack")

	if not IsServer() then return end

	self:SetStackCount(kv.stacks)

	-- if self:GetAbility():GetCaster():HasScepter() then
		self:GetParent():Purge(false, true, false, true, false)
	-- end
end

function modifier_calling_card_buff:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_steal_per_stack
end

function modifier_calling_card_buff:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.damage_steal_per_stack
end