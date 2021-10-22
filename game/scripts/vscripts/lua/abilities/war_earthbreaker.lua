war_earthbreaker = class({})

LinkLuaModifier("modifier_earthbreaker_arena","lua/abilities/war_earthbreaker",LUA_MODIFIER_MOTION_NONE)

function war_earthbreaker:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_war_4") or 0
	return base_cooldown - t_cooldown_reduction
end

function war_earthbreaker:OnSpellStart()
	local caster = self:GetCaster()
	local offset = caster:GetForwardVector()*150
	local extra_offset = caster:GetForwardVector()*450
	local start = caster:GetAbsOrigin()

	-- local max_count = 3

	local damage = self:GetSpecialValueFor("damage")

	local t_radius_bonus = caster:FetchTalent("special_bonus_war_2") or 0

	local radius = self:GetSpecialValueFor("radius") + t_radius_bonus
	local stun = self:GetSpecialValueFor("stun")
	local initial = true

	self:Slam(caster, start, offset, extra_offset, damage, t_radius_bonus, radius, stun, initial, 0, max_count)
end

function war_earthbreaker:Slam(caster, start, offset, extra_offset, damage, t_radius_bonus, radius, stun, initial, count, max_count)
	-- local unit = FastDummy(start + offset + extra_offset * count,caster:GetTeam(),2,0)
	local unit = FastDummy(start + offset,caster:GetTeam(),2,0)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_war/earthbreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

	ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0))

	-- if damage == 0 then damage = 200 end

	-- local dmg = (damage/100) * caster:GetAverageTrueAttackDamage(caster)
	
	local dmg = damage

	-- if not initial then dmg = damage / 2 end

	unit:EmitSound("War.Earthbreaker")
	--unit:EmitSoundParams("War.Earthbreaker", 1, volume, 0)

	local enemy_found = FindEnemies(caster,unit:GetAbsOrigin(),radius)

	ScreenShake(unit:GetCenter(), 1000, 3, 0.75, 1500, 0, true)

	-- self:CreateBlockers( start, offset, radius, t_radius_bonus )

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			DealDamage(v,caster,dmg,DAMAGE_TYPE_PHYSICAL)
			v:Stun( caster, nil, stun )
		end

		-- Timers:CreateTimer(0.06,function()
		-- 	FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
		-- end)
	end
end

function war_earthbreaker:CreateBlockers(start, offset, radius, t_radius_bonus)
	-- local block_duration = self:GetSpecialValueFor("block_duration")
	local block_duration = 5

	local blocker_width = 24

	-- Find clear space
	local found = FindEntities(self:GetCaster(), start + offset, radius + blocker_width * 1.25)

	for k,v in pairs(found) do
		Timers:CreateTimer(0.06,function()
			FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
		end)
	end
	--------------------

	local intervals = ( radius / blocker_width ) * 2
	local angle = 2 * math.pi / intervals

	for i=1,intervals do
		-- if i ~= 12 then
			local qangles = VectorAngles(self:GetCaster():GetForwardVector())

			local qy = qangles.y

			local angle_start = qy * (math.pi / 180)

			-- Create direction vector from the angle
			local direction =  Vector(math.cos(angle_start + angle * (i)), math.sin(angle_start + angle * (i)))
			-- Multiply the direction (length 1) with the desired radius of the circle
			local circlePoint = direction * ( radius + t_radius_bonus )

			-- Add the calculated green vector to the player position and do something
			local placement = start + offset + circlePoint

			local blocker = CreateModifierThinker(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_earthbreaker_arena", -- modifier name
				{ duration = block_duration }, -- kv
				placement,
				self:GetCaster():GetTeamNumber(),
				true
			)
			-- blocker:SetHullRadius( blocker_width )

			-- DebugDrawCircle(placement + Vector(0,0,5), Vector(255,255,255), 1, blocker_width, true, block_duration)
			-- DebugDrawText(placement + Vector(15,0,5), "["..i.."] "..angle*i, false, block_duration)
		-- end
	end

	DebugDrawCircle(self:GetCaster():GetAbsOrigin(), Vector(0,255,0), 1, self:GetCaster():GetHullRadius(), true, 5)
end

--------------------------------------------------------------------------------------------------------------

modifier_earthbreaker_arena = class({})

function modifier_earthbreaker_arena:IsHidden() return true end
function modifier_earthbreaker_arena:IsPurgable() return false end

function modifier_earthbreaker_arena:OnCreated(kv)
	if not IsServer() then return end
	self.spike_particle = CreateParticleWorld( self:GetParent():GetAbsOrigin(), "particles/units/heroes/hero_war/earthbreaker_arena_spikes.vpcf" )
	ParticleManager:SetParticleControl(self.spike_particle, 1, Vector(0,0,1))
	self:StartIntervalThink(0.7)
end

function modifier_earthbreaker_arena:OnIntervalThink()
	local hide_radius = 100
	local hide = 0

	self:GetParent():SetHullRadius(24)

	ParticleManager:SetParticleControl(self.spike_particle, 1, Vector(0,0,0))
end

function modifier_earthbreaker_arena:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.spike_particle, false)
end