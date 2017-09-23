ironfist_change_stance = class({})

GALE_M = "modifier_gale_stance"
STONEWALL_M = "modifier_stonewall_stance"
DRAGON_M = "modifier_dragon_stance"
PERFECT_M = "modifier_perfect_stance"

GALE_A = "ironfist_gale_stance"
STONEWALL_A = "ironfist_stonewall_stance"
DRAGON_A = "ironfist_dragon_stance"
PERFECT_A = "ironfist_perfect_stance"

GALE = 1
STONEWALL = 2
DRAGON = 3
PERFECT = 4
ALL = 5

LinkLuaModifier(GALE_M,"lua/abilities/ironfist_change_stance",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(STONEWALL_M,"lua/abilities/ironfist_change_stance",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(DRAGON_M,"lua/abilities/ironfist_change_stance",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(PERFECT_M,"lua/abilities/ironfist_change_stance",LUA_MODIFIER_MOTION_NONE)

modifier_gale_stance = class({})
function modifier_gale_stance:IsHidden() return true end
function modifier_gale_stance:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_stonewall_stance = class({})
function modifier_stonewall_stance:IsHidden() return true end
function modifier_stonewall_stance:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_dragon_stance = class({})
function modifier_dragon_stance:IsHidden() return true end
function modifier_dragon_stance:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_perfect_stance = class({})
function modifier_perfect_stance:IsHidden() return true end
function modifier_perfect_stance:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function ironfist_change_stance:CheckStance()
	local p = self:GetCaster()

	local r
	local n = 0

	if p:HasModifier(GALE_M) then r = GALE n = n + 1 end
	if p:HasModifier(STONEWALL_M) then r = STONEWALL n = n + 1 end
	if p:HasModifier(DRAGON_M) then r = DRAGON n = n + 1 end
	if p:HasModifier(PERFECT_M) then r = PERFECT n = n + 1 end

	if n > 1 then Warning("WARNING: Parent ".. p:GetUnitName() .. " has more than one Stance modifier.") end

	-- if r == nil then ToolsPrint("STANCE IS NIL") else ToolsPrint("STANCE: "..r) end

	return r
end

function ironfist_change_stance:ChangeStance(caster,stance)

	-- SETUP ====================================================

	local debug = false

	local selectors = {
		[GALE] = GALE_A,
		[STONEWALL] = STONEWALL_A,
		[DRAGON] = DRAGON_A,
		[PERFECT] = PERFECT_A
	}
	local mods = {
		[GALE] = GALE_M,
		[STONEWALL] = STONEWALL_M,
		[DRAGON] = DRAGON_M,
		[PERFECT] = PERFECT_M
	}
	local sounds = {
		[GALE] = "Ironfist.GaleStance",
		[STONEWALL] = "Ironfist.StonewallStance",
		[DRAGON] = "Ironfist.DragonStance",
		[PERFECT] = ""
	}
	local abs = {
		[GALE] = {
			"ironfist_lightning_strike",
			"ironfist_typhoon"
		},
		[STONEWALL] = {
			"ironfist_quake",
			"ironfist_boulder_throw"
		},
		[DRAGON] = {
			"ironfist_dragon_fist",
			"ironfist_reversal"
		},
		[PERFECT] = {
			"ironfist_hurricane_fist",
			"ironfist_hissatsu"
		},
		[ALL] = {
			"ironfist_focus"
		}
	}

	local currentStance = self:CheckStance()

	-- Hide all abilities first, and grab their levels
	for k,v in pairs(abs) do
		for kk,vv in pairs(v) do
			local ab = caster:FindAbilityByName(vv)
			if ab then
				ab:SetHidden(true)

			end
		end
	end

	-- Hide selectors
	for k,v in pairs(selectors) do
		local ab = caster:FindAbilityByName(v)
		if ab then
			ab:SetHidden(true)
		end
	end
	
	if not stance then -- DISPLAYING STANCE OPTIONS
		self:SetActivated(false)
		-- Show selectors; that's all we need to do
		-- the user will come back here when they cast one, this time with a stance defined
		for k,v in pairs(selectors) do
			local ab = caster:FindAbilityByName(v)
			if ab then
				ab:SetHidden(false)
				ab:SetLevel(1)
			end
		end

		-- No cooldown when we haven't actually changed stance yet
		local cd = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self:RefundManaCost()

		self.storedCooldown = cd

	else -- SWITCHING TO A SPECIFIC STANCE
		-- Show the Stance abilities

		self:SetActivated(true)

		for k,v in pairs(abs[stance]) do
			local ab = caster:FindAbilityByName(v)
			if ab then
				ab:SetHidden(false)
			end
		end

		-- Show Focus and other Abilities that apply to all Stances:

		for k,v in pairs(abs[ALL]) do
			local ab = caster:FindAbilityByName(v)
			if ab then
				ab:SetHidden(false)
			end
		end

		-- Remove old stance modifiers
		for k,v in pairs(mods) do
			caster:RemoveModifierByName(v) --[[Returns:void
			Removes a modifier
			]]
		end

		-- Apply correct stance modifier
		caster:AddNewModifier(caster, self, mods[stance], {})

		if currentStance ~= stance then
			self:PayManaCost()
		end

		-- Emit Sounds

		caster:EmitSound(sounds[stance])

		-- Start cooldown
		if self.storedCooldown then
			if currentStance ~= stance and not caster:HasScepter() then
				self:StartCooldown(self.storedCooldown)
			end
		end
	end
end

function ironfist_change_stance:ShowStances(caster)
	self:ChangeStance(caster,nil)
end

function ironfist_change_stance:RevertStances(caster)
	-- this function runs ChangeStance with the current stance, checking whatever modifier they have
	-- to determine it

	local mods = {
		[GALE] = GALE_M,
		[STONEWALL] = STONEWALL_M,
		[DRAGON] = DRAGON_M,
		[PERFECT] = PERFECT_M
	}

	local stance

	for k,v in pairs(mods) do
		if caster:HasModifier(v) then
			stance = k
			break
		end
	end

	if not stance then return end

	self:ChangeStance(caster, stance)
end

function ironfist_change_stance:OnSpellStart()
	if self.changingStances then
		self:RefundManaCost()
		self:RevertStances(self:GetCaster())
	else
		self:ShowStances(self:GetCaster())
	end
end

function ironfist_change_stance:OnOwnerDied( )
	-- if the caster dies while in the changing stances dialog, we want to revert to the last used
	if self.changingStances then
		self:RevertStances( self:GetCaster() )
	end
end