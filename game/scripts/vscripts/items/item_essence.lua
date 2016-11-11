function EssenceStrength(keys)
	local caster = keys.caster
	local cattr = caster:GetBaseStrength()

	caster:SetBaseStrength(cattr+3)
	caster:CalculateStatBonus()
	local p = ParticleManager:CreateParticle("particles/items/essence_of_strength.vpcf", PATTACH_CUSTOMORIGIN, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetCenter(), true)

	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item then
			if item:GetName() == "item_essence_of_strength" then
				local charge = item:GetCurrentCharges()
				item:SetCurrentCharges(charge-1) --[[Returns:void
				Set the number of charges on this item
				]]
				if (charge-1) <= 0 then caster:RemoveItem(item) end
				break
			end
		end
	end
end

function EssenceAgility(keys)
	local caster = keys.caster
	local cattr = caster:GetBaseAgility()

	caster:SetBaseAgility(cattr+3)
	caster:CalculateStatBonus()
	local p = ParticleManager:CreateParticle("particles/items/essence_of_agility.vpcf", PATTACH_CUSTOMORIGIN, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetCenter(), true)

	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item then
			if item:GetName() == "item_essence_of_agility" then
				local charge = item:GetCurrentCharges()
				item:SetCurrentCharges(charge-1) --[[Returns:void
				Set the number of charges on this item
				]]
				if (charge-1) <= 0 then caster:RemoveItem(item) end
				break
			end
		end
	end
end

function EssenceIntelligence(keys)
	local caster = keys.caster
	local cattr = caster:GetBaseIntellect()

	caster:SetBaseIntellect(cattr+3)
	caster:CalculateStatBonus()
	local p = ParticleManager:CreateParticle("particles/items/essence_of_intelligence.vpcf", PATTACH_CUSTOMORIGIN, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetCenter(), true)

	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item then
			if item:GetName() == "item_essence_of_intelligence" then
				local charge = item:GetCurrentCharges()
				item:SetCurrentCharges(charge-1) --[[Returns:void
				Set the number of charges on this item
				]]
				if (charge-1) <= 0 then caster:RemoveItem(item) end
				break
			end
		end
	end
end