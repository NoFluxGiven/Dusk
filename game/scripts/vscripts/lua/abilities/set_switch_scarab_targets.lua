set_switch_scarab_targets = class({})

function set_switch_scarab_targets:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		local ab = caster:FindAbilityByName("set_scarab_curse")

		local range = ab:GetSpecialValueFor("retarget_range")

		local enemies = FindEnemies(caster,Vector(0,0,0),FIND_UNITS_EVERYWHERE)
		for k,v in pairs(enemies) do
			local mod = v:FindModifierByName("modifier_scarab_curse")

			if mod then

				if v ~= target then

					target:EmitSound("Set.ScarabCurse.SwitchTarget")
					--Particle

					Timers:CreateTimer(0.5,function()

						print("Transferring mod from "..v:GetName().." to "..target:GetName())
						if v:GetRangeToUnit(target) < range then
							mod:TransferDebuff(v,target)
						end

					end)

				end
				
			end
		end
	end
end