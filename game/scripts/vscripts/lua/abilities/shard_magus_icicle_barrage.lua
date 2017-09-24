shard_magus_icicle_barrage = class({})

LinkLuaModifier("modifier_icicle_barrage","lua/abilities/shard_magus_icicle_barrage",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_icicle_barrage_scepter_slow","lua/abilities/shard_magus_icicle_barrage",LUA_MODIFIER_MOTION_NONE)

function shard_magus_icicle_barrage:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local c = self:GetCaster()
	local t = self:GetCursorPosition()
	local d = (self:GetCursorPosition() - c:GetAbsOrigin()):Normalized()
	local u = CreateModifierThinker( c, self, "modifier_icicle_barrage",
		{Duration=duration+1.35},
		t, c:GetTeamNumber(), false)

	u:EmitSound("Hero_Lich.FrostArmor") --[[Returns:void
	 
	]]

	u:SetForwardVector(d)
end

function shard_magus_icicle_barrage:OnProjectileHit(t,l)
	local damage = self:GetSpecialValueFor("damage")
	local scepter_damage = self:GetSpecialValueFor("scepter_damage")

	local t_mana_burn = self:GetCaster():FetchTalent("special_bonus_shard_magus_3") or 0

	if t then
		-- local r = RandomInt(0,100)
		-- if r < self:GetSpecialValueFor("ministun_chance") then
		-- 	t:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration=0.1}) --[[Returns:void
		-- 	No Description Set
		-- 	]]
		-- end

		t:EmitSound("Hero_Ancient_Apparition.ColdFeetTick")

		if self:GetCaster():HasScepter() then
			damage = scepter_damage
			t:AddNewModifier(self:GetCaster(), self, "modifier_icicle_barrage_scepter_slow", {Duration=self:GetSpecialValueFor("scepter_slow_duration")}) --[[Returns:void
			No Description Set
			]]
		end

		self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)

		if t_mana_burn > 0 then
			t:ReduceMana(t_mana_burn)
		end

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/icicle_hit.vpcf", PATTACH_POINT_FOLLOW, t)

		ParticleManager:SetParticleControlEnt(p,0,t,PATTACH_POINT_FOLLOW,"attach_hitloc",t:GetCenter(),true)

		return false
	end
end

modifier_icicle_barrage = class({})

function modifier_icicle_barrage:OnCreated()
	if IsServer() then
		local amt = self:GetAbility():GetSpecialValueFor("icicles")
		local duration = self:GetDuration() - 1.35

		self.dir = self:GetParent().dir

		local int = duration/amt

		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_phased", {}) --[[Returns:void
		No Description Set
		]]

		Timers:CreateTimer(1, function()

			self:StartIntervalThink(int)

		end)

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/barrage_portal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
			Creates a new particle effect
			]]

		Timers:CreateTimer(duration+1,function()
			ParticleManager:DestroyParticle(p,false)
		end)
	end
end

function modifier_icicle_barrage:OnIntervalThink()
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local dir = self:GetParent():GetForwardVector()

		local caster = self:GetAbility():GetCaster()

		local d = dir + Vector(RandomFloat(-0.12,0.12),RandomFloat(-0.12,0.12),0)
		local speed = 2000
		local range = self:GetAbility():GetSpecialValueFor("range")
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local start_radius,end_radius = radius,radius

		local sound = "Hero_Ancient_Apparition.Attack"
		local particle = "particles/units/heroes/hero_shard_magus/icicle.vpcf"

		local data = {
			Ability = self:GetAbility(),
			Source = caster,
			EffectName = particle,
			vSpawnOrigin = self:GetParent():GetAbsOrigin()+Vector(0,0,75),
			vVelocity = d * speed,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			bHasFrontalCone = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = 0,
			bProvidesVision = false,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iVisionRadius = 0,
			bDrawsOnMinimap = false,
			bVisibleToEnemies = true,
			fExpireTime = GameRules:GetGameTime()+10,
			bDeleteOnHit = true
		}

		caster:EmitSound(sound)

		ProjectileManager:CreateLinearProjectile(data)
	end
end

modifier_icicle_barrage_scepter_slow = class({})

function modifier_icicle_barrage_scepter_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_icicle_barrage_scepter_slow:GetModifierMoveSpeedBonus_Percentage()
	local stack = self:GetStackCount()
	return -self:GetAbility():GetSpecialValueFor("scepter_slow") * stack
end

function modifier_icicle_barrage_scepter_slow:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_icicle_barrage_scepter_slow:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end