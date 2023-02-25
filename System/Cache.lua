local _, br = ...

local caches = {}
local persistentCaches = {}
local pairs, select, wipe, tinsert, tostring, concat = pairs, select, wipe, tinsert, tostring, table.concat
local SafePack, SafeUnpack = SafePack, SafeUnpack

local function clearCache()
	for _, v in pairs(caches) do
		wipe(v)
	end
end

local function clearPersistentCache()
	for _, v in pairs(persistentCaches) do
		wipe(v)
	end
end

local function tostringall(...)
	local out = {}
	local n = select("#", ...)
	for i = 1, n do
		local var = select(i, ...)
		tinsert(out, tostring(var))
	end
	return concat(out, '\0')
end

local cachedObjectExists = function(o) return false end
local createCachedFunction = function(func, style, cachePersistence)
	if style == 1 then -- ObjectExists
		return function(obj)
			return cachedObjectExists(obj)
		end
	end
	if style == 2 then -- Single Param / Single Return
		local exists = {}
		local values = {}
		if cachePersistence then
			persistentCaches[#persistentCaches + 1] = exists
			persistentCaches[#persistentCaches + 1] = values
		else
			caches[#caches + 1] = exists
			caches[#caches + 1] = values
		end
		return function(param1)
			if param1 == nil then
				return func(param1)
			elseif exists[param1] then
				return values[param1]
			else
				values[param1] = func(param1)
				exists[param1] = true
				return values[param1]
			end
		end
	end
	if style == 3 then -- single param / multiple returns
		local exists = {}
		local values = {}
		if cachePersistence then
			persistentCaches[#persistentCaches + 1] = exists
			persistentCaches[#persistentCaches + 1] = values
		else
			caches[#caches + 1] = exists
			caches[#caches + 1] = values
		end
		return function(param1)
			if param1 == nil then return func() end
			if exists[param1] then
				return SafeUnpack(values[param1])
			else
				values[param1] = SafePack(func(param1))
				exists[param1] = true
				return SafeUnpack(values[param1])
			end
		end
	end
	if style == 4 then -- multiple params / multiple returns
		local exists = {}
		local values = {}
		if cachePersistence then
			persistentCaches[#persistentCaches + 1] = exists
			persistentCaches[#persistentCaches + 1] = values
		else
			caches[#caches + 1] = exists
			caches[#caches + 1] = values
		end
		return function(...)
			local param1 = tostringall(...)
			if exists[param1] then
				return SafeUnpack(values[param1])
			else
				values[param1] = SafePack(func(...))
				exists[param1] = true
				return SafeUnpack(values[param1])
			end
		end
	end
end

local cached = false

local function createCache()
	local b = br._G

	-- print '[BR] Creating Cache'

	b.ObjectExists = createCachedFunction(b.ObjectExists, 1)
	b.UnitExists = createCachedFunction(b.UnitExists, 1)
	-- b.UnitIsVisible = createCachedFunction(b.UnitIsVisible, 1)
	-- b.ObjectIsVisible = createCachedFunction(b.ObjectIsVisible, 1)

	b.ObjectPointer = createCachedFunction(b.ObjectPointer, 2)
	b.GetUnitSpeed = createCachedFunction(b.GetUnitSpeed, 2)
	b.UnitGUID = createCachedFunction(b.UnitGUID, 2)
	b.UnitIsDeadOrGhost = createCachedFunction(b.UnitIsDeadOrGhost, 2)
	b.UnitHealthMax = createCachedFunction(b.UnitHealthMax, 2)
	b.UnitHealth = createCachedFunction(b.UnitHealth, 2)
	b.ObjectIsUnit = createCachedFunction(b.ObjectIsUnit, 2)
	b.ObjectID = createCachedFunction(b.ObjectID, 2)
	b.UnitName = createCachedFunction(b.UnitName, 2)
	b.ObjectName = createCachedFunction(b.ObjectName, 2)
	b.UnitIsPlayer = createCachedFunction(b.UnitIsPlayer, 2)
	b.UnitAffectingCombat = createCachedFunction(b.UnitAffectingCombat, 2)
	b.UnitTarget = createCachedFunction(b.UnitTarget, 2)
	b.UnitCombatReach = createCachedFunction(b.UnitCombatReach, 2, true)
	b.UnitBoundingRadius = createCachedFunction(b.UnitBoundingRadius, 2, true)
	b.UnitPhaseReason = createCachedFunction(b.UnitPhaseReason, 2, true)
	b.UnitCreator = createCachedFunction(b.UnitCreator, 2, true)
	b.UnitCreatureType = createCachedFunction(b.UnitCreatureType, 2, true)

	b.UnitCastingInfo = createCachedFunction(b.UnitCastingInfo, 3)
	b.UnitChannelInfo = createCachedFunction(b.UnitChannelInfo, 3)
	b.UnitCastID = createCachedFunction(b.UnitCastID, 3)

	b.ObjectPosition = createCachedFunction(b.ObjectPosition, 3)

	cached = true
end

local function update()
	if br.unlocked and not cached then
		cachedObjectExists = createCachedFunction(br._G.ObjectExists, 2)
		createCache()
	end
	C_Timer.After(4, update)
	C_Timer.After(3, clearPersistentCache)
end
C_Timer.After(0, update)
C_Timer.NewTicker(0, clearCache)
