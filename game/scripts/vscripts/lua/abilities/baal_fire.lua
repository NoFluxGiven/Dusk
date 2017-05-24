baal_fire = class({})

function baal_fire:OnSpellStart()
	local caster = self:GetCaster()
	local unit = nil

	local ab1 = caster:FindAbilityByName("baal_compress")
	local ab2 = self

	if not caster.compress_active then
		ab1:SetHidden(false)
		ab2:SetHidden(true)
		return
	end

	unit = table.remove(caster.compress_active,#caster.compress_active)

	local mod = unit:FindModifierByName("modifier_compress")

	mod:Destroy()

	if caster.compress_active == nil then
		ab1:SetHidden(false)
		ab2:SetHidden(true)
	end
end