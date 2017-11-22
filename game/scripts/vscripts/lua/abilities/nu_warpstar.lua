nu_warpstar = class({})

LinkLuaModifier("modifier_warpstar","lua/abilities/nu_warpstar",LUA_MODIFIER_MOTION_NONE)

function nu_warpstar:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Warlock.FatalBondsPrecast")
	return true
end

function nu_warpstar:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	local delay = self:GetSpecialValueFor("delay")

	CreateModifierThinker( caster, self, "modifier_warpstar", {Duration=delay+1, delay=delay}, target, caster:GetTeamNumber(), false )

	self:CreateVisibilityNode(target, 600, delay+1)
end

modifier_warpstar = class({})

function modifier_warpstar:OnCreated(kv)
	if IsServer() then
		local delay = kv.delay

		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage = self:GetAbility():GetSpecialValueFor("damage")

		self:GetParent():EmitSound("Nu.Warpstar")

		self.entr_pos = self:GetParent():GetAbsOrigin()
		self.exit_pos = self:GetAbility():GetCaster():GetAbsOrigin()

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/warpstar.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(p, 0, self.entr_pos)
		local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/warpstar_exit_point.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(p2, 0, self.exit_pos)

		ScreenShake(self.entr_pos, 25, 2, 2, 800, 0, true)

		Timers:CreateTimer(self:GetDuration()*0.30,function()
			self:GetParent():EmitSound("Nu.Warpstar.Pre")
		end)

		Timers:CreateTimer(delay,function()
			ParticleManager:DestroyParticle(p,false)
			ParticleManager:DestroyParticle(p2,false)
		end)

		Timers:CreateTimer(delay+0.4,function()

			local units = FindEntities(self:GetAbility():GetCaster(),self.entr_pos,radius)

			self:GetParent():StopSound("Nu.Warpstar")
			self:GetParent():EmitSound("Nu.Warpstar.Teleport")

			ScreenShake(self.entr_pos, 90, 2, 2, 800, 0, true)
			ScreenShake(self.exit_pos, 90, 2, 2, 800, 0, true)

			for k,v in pairs(units) do
				v:Interrupt()

				if not v:IsMagicImmune() then

					FindClearSpaceForUnit(v, self.exit_pos, true)
					v:AddNewModifier(self:GetAbility():GetCaster(), nil, "modifier_phased", {Duration=0.4})

					if v:GetTeam() ~= self:GetAbility():GetCaster():GetTeam() then
						self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_PURE)
					end

				end
			end
		end)
	end
end