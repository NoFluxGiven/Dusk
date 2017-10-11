tek_mosquito_missiles = class({})

LinkLuaModifier("modifier_mosquito_missiles","lua/abilities/tek_mosquito_missiles",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mosquito_missiles_fire","lua/abilities/tek_mosquito_missiles",LUA_MODIFIER_MOTION_NONE)

function tek_mosquito_missiles:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mosquito_missiles", {})
end

function tek_mosquito_missiles:OnChannelFinish(interrupt)
	self:GetCaster():RemoveModifierByName("modifier_mosquito_missiles")
end

function tek_mosquito_missiles:OnProjectileHit(t)
	local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_tek_3") or 0
	local damage = self:GetSpecialValueFor("damage") + t_damage_bonus
	if t then
		self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
	end
end

modifier_mosquito_missiles = class({})

function modifier_mosquito_missiles:OnCreated(kv)
	if IsServer() then
		self.temp_targets = {}
		self.targets = {}
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
	end
end

function modifier_mosquito_missiles:OnIntervalThink()
	local caster = self:GetAbility():GetCaster()
	local radius = self:GetAbility():GetSpecialValueFor("range")

	if IsServer() then

		local enemy = FindEnemies(caster,caster:GetAbsOrigin(),radius,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE)
		local sound = "Tek.MosquitoMissiles.Acquire2"

		for k,v in pairs(enemy) do
			if not CheckTable(self.temp_targets, v) then
				table.insert(self.temp_targets,v)
				caster:EmitSound(sound)
				local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/targeting_reticule.vpcf", PATTACH_ROOTBONE_FOLLOW, v)

				if #self.temp_targets >= #enemy then
					for kk, vv in pairs(self.temp_targets) do
						table.insert(self.targets, vv)
					end
					self.temp_targets = {}
				end
				break -- stop the loop when we find a target
			end
		end

	end
end

function modifier_mosquito_missiles:OnDestroy()
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		local channel_time = (#self.targets * interval) + interval
		local mod = self:GetAbility():GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mosquito_missiles_fire", {Duration=channel_time})

		mod.targets = self.targets
	end
end

function modifier_mosquito_missiles:IsHidden()
	return true
end

modifier_mosquito_missiles_fire = class({})

function modifier_mosquito_missiles_fire:OnCreated(kv)
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
	end
end

function modifier_mosquito_missiles_fire:OnIntervalThink()
	if IsServer() then
		local t = self.targets
		local caster = self:GetAbility():GetCaster()

		if #self.targets > 0 then
			local target = table.remove(t,1)

			if IsValidEntity(target) then
				local info = 
				  {
				  Target = target,
				  Source = caster,
				  Ability = self:GetAbility(),  
				  EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
				  vSpawnOrigin = caster:GetAbsOrigin(),
				  fDistance = 9999,
				  fStartRadius = 64,
				  fEndRadius = 64,
				  bHasFrontalCone = false,
				  bReplaceExisting = false,
				  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				  fExpireTime = GameRules:GetGameTime() + 10.0,
				  bDeleteOnHit = true,
				  iMoveSpeed = 1600,
				  bProvidesVision = false,
				  iVisionRadius = 0,
				  iVisionTeamNumber = caster:GetTeamNumber(),
				  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
				  }
				if caster:IsAlive() and not caster:IsSilenced() then
					local projectile = ProjectileManager:CreateTrackingProjectile(info)
				  	caster:EmitSound("Hero_Leshrac.Pulse_Nova_Strike")
				end
			end
		else
			self:Destroy()
		end
	end
end