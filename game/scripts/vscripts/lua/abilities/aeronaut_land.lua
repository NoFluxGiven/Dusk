aeronaut_land = class({})

function aeronaut_land:OnSpellStart()
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_upwind") then
		caster:RemoveModifierByName("modifier_upwind")
	end
end

function aeronaut_land:ProcsMagicStick()
	return false
end