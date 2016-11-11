function GainCharge(keys)
	local caster = keys.caster
	local target = keys.unit or keys.target

	local charges = 1

	local maxcharge = keys.maxcharge or 16

	if target:IsIllusion() then return end

	if target:IsRealHero() then
		charges = 8
	end
    
    for i=0, 5, 1 do
        local current_item = keys.caster:GetItemInSlot(i)
    	if current_item ~= nil and current_item:GetName() == "item_soul_vial" and current_item:GetCurrentCharges() < maxcharge then
    		if current_item:GetCurrentCharges() + charges < maxcharge then
				current_item:SetCurrentCharges(current_item:GetCurrentCharges() + charges)
			else
				current_item:SetCurrentCharges(maxcharge)
			end
       	end
    end
end

function LoseCharge(keys)
	local caster = keys.caster

	for i=0, 5, 1 do
        local current_item = keys.caster:GetItemInSlot(i)
    	if current_item ~= nil and current_item:GetName() == "item_soul_vial" then
			current_item:SetCurrentCharges(0)
       	end
    end
end

function Check(keys)
	local caster = keys.caster
	local n = -1
	--[[print("CHECKING!")
	for i=0, 5, 1 do
        local current_item = keys.caster:GetItemInSlot(i)
        if current_item ~= nil and current_item:GetName() == "item_soul_vial" then
            n = n+1
        end
    end

    print("n is at "..n)

    if n > -1 then
	    for i=0, 5, 1 do
	        local current_item = keys.caster:GetItemInSlot(i)
	        if current_item ~= nil and current_item:GetName() == "item_soul_vial" and current_item:GetCurrentCharges() == 0 then
	            current_item:RemoveItem()
	        end
	    end
    end]]
end

function RemoveDamage(keys)
	local caster = keys.caster
	--caster:RemoveModifierByName("modifier_item_vial_damage_lua")
	caster:RemoveModifierByName("modifier_item_vial_damage")
end

function Start(keys)
	local caster = keys.caster
	--caster:AddNewModifier(caster, keys.ability, "modifier_soul_vial_damage_lua", {})

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_vial_damage", {}) --[[Returns:void
	No Description Set
	]]
end

function Sync(keys)
	local caster = keys.caster

	local amount = 0

	for i=0, 5, 1 do
        local current_item = keys.caster:GetItemInSlot(i)
    	if current_item ~= nil and current_item:GetName() == "item_soul_vial" then
			amount = current_item:GetCurrentCharges()
			break
       	end
    end

    if amount < 1 then
    	caster:RemoveModifierByName("modifier_item_vial_damage")
    	return
    end

    local mod = caster:FindModifierByName("modifier_item_vial_damage")

    if mod ~= nil then

    	mod:SetStackCount(amount)

    else

    	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_vial_damage", {})

    end
end