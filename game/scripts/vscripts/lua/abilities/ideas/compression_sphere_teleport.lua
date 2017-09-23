-- if IsServer() then

	-- function modifier_compression_sphere_thinker:OnCollision(unit)
	-- 	local radius = self:GetAbility():GetSpecialValueFor("radius")+125
	-- 	local pos = unit:GetAbsOrigin()
	-- 	local cpnt = self:GetParent():GetAbsOrigin()

	-- 	local vx = cpnt.x - pos.x
	-- 	local vy = cpnt.y - pos.y

	-- 	local dir = (cpnt - pos):Normalized()

	-- 	local l = math.sqrt(vx*vx + vy*vy)

	-- 	local fpnt = Vector(0,0,0)

	-- 	fpnt.x = vx / l * radius + cpnt.x
	-- 	fpnt.y = vy / l * radius + cpnt.y

	-- 	FindClearSpaceForUnit(unit, fpnt, true)
	-- 	unit:Interrupt()
	-- 	unit:SetForwardVector(dir)
	-- end

	-- function modifier_compression_sphere_thinker:OnCreated()
	-- 	self:StartIntervalThink(0.1)
	-- end

	-- function modifier_compression_sphere_thinker:OnIntervalThink()
	-- 	local radius = self:GetAbility():GetSpecialValueFor("radius")
	-- 	local f = FindEnemies(self:GetParent(),self:GetParent():GetAbsOrigin(),radius)

	-- 	for k,v in pairs(f) do
	-- 		if not v:HasModifier("modifier_compression_sphere_cooldown") then
	-- 			CreateParticleHitloc(v,"particles/units/heroes/hero_baal/baal_compression_sphere_explosion.vpcf")
	-- 			self:OnCollision(v)
	-- 			v:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_compression_sphere_cooldown", {Duration=6})
	-- 		end
	-- 	end
	-- end

-- end