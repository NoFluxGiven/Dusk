faust_dark_shard = class({})

LinkLuaModifier("modifier_dark_shard_thinker","lua/abilities/faust_dark_shard",LUA_MODIFIER_MOTION_NONE)

function faust_dark_shard:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	CreateModifierThinker( caster, self, "modifier_dark_shard_thinker", {Duration=0.4}, target, caster:GetTeamNumber(), false )

end

modifier_dark_shard_thinker = class({})

if IsServer() then

	function modifier_dark_shard_thinker:OnCreated()
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_faust/dark_shard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		local radius = self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		self:AddParticle( p, false, false, 10, false, false )

		self:GetParent():EmitSound("Faust.DarkShard")

		local damage = self:GetAbility():GetSpecialValueFor("damage") --[[Returns:table
		No Description Set
		]]

		local en = FindEnemies(self:GetAbility():GetCaster(), self:GetParent():GetAbsOrigin(), radius)

		for k,v in pairs(en) do
			self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)

			local mods = v:FindAllModifiers()

			for kk,vv in pairs(mods) do
				if vv:GetCaster() == self:GetAbility():GetCaster() then
					print(vv:GetName().." is a debuff!")
					vv:ForceRefresh()
				end
			end
		end

		ScreenShake(self:GetParent():GetAbsOrigin(), 1200, 170, 0.25, 1200, 0, true)
	end

end