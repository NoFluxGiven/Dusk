ironfist_gale_stance = class({})

GALE = 1
STONEWALL = 2
DRAGON = 3
PERFECT = 4

function ironfist_gale_stance:OnSpellStart()
	-- to access the ChangeStance() function:
	local ab = self:GetCaster():FindAbilityByName("ironfist_change_stance")

	ab:ChangeStance(self:GetCaster(),GALE)

	-- Particles
	local part_name = "gale"
	local part_path = "particles/units/heroes/hero_ironfist/enter_"..part_name.."_stance.vpcf"

	ParticleManager:CreateParticle(part_path,PATTACH_OVERHEAD_FOLLOW,self:GetCaster())
end