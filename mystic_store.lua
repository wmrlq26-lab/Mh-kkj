-- MYSTIC STORE | Cosmetics & Visuals Panel V3 (Final Otimizado, Anti-Lag, Nick RGB & Spinbot)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

local AUTO_EXEC_URL = "https://raw.githubusercontent.com/wmrlq26-lab/Mh-kkj/refs/heads/main/mystic_store.lua"
local CONFIG_FILE = "mystic_store_config.txt"

local factory = RS:WaitForChild("StumbleOriginal056Factory", 15)

local function safeRequireModule(parent, name)
	if not parent then return nil end
	local m = parent:FindFirstChild(name) or parent:WaitForChild(name, 8)
	if m and m:IsA("ModuleScript") then
		local ok, res = pcall(require, m)
		if ok then return res end
	end
	return nil
end

local catalog = safeRequireModule(factory, "CharacterCatalog")
local appearance = safeRequireModule(factory, "CharacterAppearance")

if type(catalog) ~= "table" then
	catalog = { skins = {}, colors = {} }
end
if type(appearance) ~= "table" then
	appearance = { Build = function() end }
end

local function safeRequire(parent, name)
	local m = parent and parent:FindFirstChild(name)
	if m and m:IsA("ModuleScript") then
		local ok, res = pcall(require, m)
		if ok then return res end
	end
	return nil
end

local punchCatalog = safeRequire(RS, "PunchCatalog")
local punchSkinFx  = safeRequire(RS, "PunchSkinFx")
local trailCatalog = safeRequire(RS, "TrailCatalog")

local function buildListFromItems(catTbl, fallback)
	if type(catTbl) ~= "table" or type(catTbl.Items) ~= "table" then
		return fallback
	end
	local out = {}
	for _, item in ipairs(catTbl.Items) do
		if type(item) == "table" and item.id then
			out[#out + 1] = {
				id   = tostring(item.id),
				name = tostring(item.name or item.id),
				fx   = item.fx and tostring(item.fx) or tostring(item.id),
			}
		end
	end
	return (#out > 0) and out or fallback
end

local SKIN_THUMBS = {
	BonecoNoob             = "rbxassetid://118862627495693",
	Noob                   = "rbxassetid://118862627495693",
	BonecoNoobListrado     = "rbxassetid://123665214738883",
	NoobListrado           = "rbxassetid://123665214738883",
	BonecoNoobMacacao      = "rbxassetid://81011195574652",
	NoobMacacao            = "rbxassetid://81011195574652",
	BonecoNoobMoleton      = "rbxassetid://74327146599508",
	BonecoNoobMoletom      = "rbxassetid://74327146599508",
	NoobMoleton            = "rbxassetid://74327146599508",
	NoobMoletom            = "rbxassetid://74327146599508",
	Noob_Moleton           = "rbxassetid://74327146599508",
	Noob_Moletom           = "rbxassetid://74327146599508",
	Boneco_Noob_Moleton    = "rbxassetid://74327146599508",
	Boneco_Noob_Moletom    = "rbxassetid://74327146599508",

	BonecoLencoBranco      = "rbxassetid://73534313721213",
	LencoBranco            = "rbxassetid://73534313721213",
	BonecoLencoVermelho    = "rbxassetid://73534313721213",
	LencoVermelho          = "rbxassetid://73534313721213",
	Vermelho               = "rbxassetid://73534313721213",
	BonecoLencoPreto       = "rbxassetid://99316488557407",
	LencoPreto             = "rbxassetid://99316488557407",
	BonecoLencoFina        = "rbxassetid://128097782503860",
	LencoFina              = "rbxassetid://128097782503860",
	Fina                   = "rbxassetid://128097782503860",

	BonecoRegata           = "rbxassetid://99523890013382",
	Regata                 = "rbxassetid://99523890013382",
	BonecoCj               = "rbxassetid://99523890013382",
	Cj                     = "rbxassetid://99523890013382",

	BonecoTubaraoSelvagem  = "rbxassetid://82680508471835",
	BonecoTubarao          = "rbxassetid://72759977600957",
	Tubarao                = "rbxassetid://72759977600957",

	BonecoSurfistaMulher   = "rbxassetid://82027486949934",
	SurfistaGarota         = "rbxassetid://82027486949934",
	BonecoSurfista         = "rbxassetid://126552756172125",
	Surfista               = "rbxassetid://126552756172125",

	BonecoMergulhador      = "rbxassetid://111462560382365",
	Mergulhador            = "rbxassetid://111462560382365",

	BonecoGuardaVidas      = "rbxassetid://124221411864523",
	GuardaVidas            = "rbxassetid://124221411864523",

	BonecoNadador          = "rbxassetid://74448258557733",
	Nadador                = "rbxassetid://74448258557733",

	BonecoNinja            = "rbxassetid://89432289655302",
	Ninja                  = "rbxassetid://89432289655302",
	BonecoNinjaRelampago   = "rbxassetid://129238776540496",
	NinjaRelampago         = "rbxassetid://129238776540496",
	Ninja_Relampago        = "rbxassetid://129238776540496",
	BonecoNinjaSombras     = "rbxassetid://131093549072285",
	NinjaSombras           = "rbxassetid://131093549072285",

	BonecoSamurai          = "rbxassetid://78123448519700",
	Samurai                = "rbxassetid://78123448519700",

	BonecoPiloto           = "rbxassetid://93324803701908",
	Piloto                 = "rbxassetid://93324803701908",

	BonecoPalhaco          = "rbxassetid://88085886598135",
	Palhaco                = "rbxassetid://88085886598135",

	BonecoHomemCorvo       = "rbxassetid://109925176493321",
	HomemCorvo             = "rbxassetid://109925176493321",

	BonecoCraque           = "rbxassetid://114408052876048",
	BonecoCraque10         = "rbxassetid://114408052876048",
	Craque10               = "rbxassetid://114408052876048",

	BonecoTungTungSahur    = "rbxassetid://116340072271737",
	TungTungSahur          = "rbxassetid://116340072271737",

	BonecoGhostyface       = "rbxassetid://92816297410366",
	Ghostyface             = "rbxassetid://92816297410366",

	BonecoMascarado        = "rbxassetid://93456843850862",
	Mascarado              = "rbxassetid://93456843850862",

	BonecoBoxeador         = "rbxassetid://100918705396649",
	Boxeador               = "rbxassetid://100918705396649",

	BonecoMumia            = "rbxassetid://76159099371538",
	Mumia                  = "rbxassetid://76159099371538",
}

local function normalizeText(str)
	local s = string.lower(tostring(str or ""))
	s = s:gsub("[áàâãä]", "a"):gsub("[éèêë]", "e"):gsub("[íìîï]", "i")
	     :gsub("[óòôõö]", "o"):gsub("[úùûü]", "u"):gsub("[ç]", "c")
	     :gsub("[%s_%-]+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	return s
end

local SKIN_THUMBS_COMPACT = {}
for k, v in pairs(SKIN_THUMBS) do
	local compactKey = normalizeText(k):gsub("%s+", "")
	if compactKey ~= "" and not SKIN_THUMBS_COMPACT[compactKey] then
		SKIN_THUMBS_COMPACT[compactKey] = v
	end
end

local function findSkinThumbRaw(item)
	if not item then return "" end
	local id = tostring(item.id or "")
	local name = tostring(item.name or "")
	local combined = normalizeText(name) .. " " .. normalizeText(id)

	if string.find(combined, "molet", 1, true) or string.find(combined, "hood", 1, true) then
		return "rbxassetid://74327146599508"
	end

	if SKIN_THUMBS[id] and SKIN_THUMBS[id] ~= "" then
		return SKIN_THUMBS[id]
	end
	if SKIN_THUMBS[name] and SKIN_THUMBS[name] ~= "" then
		return SKIN_THUMBS[name]
	end
	local cId = normalizeText(id):gsub("%s+", "")
	if cId ~= "" and SKIN_THUMBS_COMPACT[cId] then
		return SKIN_THUMBS_COMPACT[cId]
	end
	local cName = normalizeText(name):gsub("%s+", "")
	if cName ~= "" and SKIN_THUMBS_COMPACT[cName] then
		return SKIN_THUMBS_COMPACT[cName]
	end
	return ""
end

local THUMB_CACHE = {}
local function resolveThumbAsset(rawId)
	if type(rawId) ~= "string" or rawId == "" then return "" end
	if THUMB_CACHE[rawId] then return THUMB_CACHE[rawId] end

	local numericId = rawId:match("(%d+)$")
	local resolved = numericId and ("rbxassetid://" .. numericId) or rawId
	THUMB_CACHE[rawId] = resolved
	return resolved
end

local RARITIES = {
	"COMUM", "RARO", "EPICO", "LENDARIO", "MITICO",
	"13TH FRIDAY", "BETA", "SUMMER 1", "SUMMER 2",
}

local RARITY_MATCHERS = {
	COMUM = {
		"noob", "noob listrado", "noob macacao", "noob moleton", "noob moletom",
		"moleton", "moletom", "hoodie", "boneconoob", "boneconooblistrado",
		"boneconoobmacacao", "boneconoobmoleton", "boneconoobmoletom",
	},
	RARO = {
		"ninja relampago", "ninja vermelho", "samurai",
		"boneconinjarelampago", "boneconinjavermelho",
		"boneconinjasombras", "bonecosamurai",
	},
	EPICO = {
		"piloto", "boxeador", "lenco preto", "lenco vermelho", "vermelho",
		"lenco fina", "fina", "bonecopiloto", "bonecoboxeador",
		"bonecolencopreto", "bonecolencovermelho",
		"bonecolencobranco", "bonecolencofina",
	},
	LENDARIO = { "homem corvo", "bonecohomemcorvo" },
	MITICO = { "craque 10", "craque", "bonecocraque" },
	["13TH FRIDAY"] = {
		"ghostyface", "mascarado", "mumia",
		"bonecoghostyface", "bonecomascarado", "bonecomumia",
	},
	BETA = { "tung tung sahur", "tung tung", "regata", "ninja", "tungtungsahur" },
	["SUMMER 1"] = {
		"tubarao", "mergulhador", "guarda-vidas", "guarda vidas",
		"bonecotubaraoselvagem", "bonecomergulhador", "bonecoguardavidas",
	},
	["SUMMER 2"] = {
		"surfista", "surfista garota", "nadador",
		"bonecosurfista", "bonecosurfistamulher", "boneconadador",
	},
}

local function getRarityForSkin(item)
	if not item then return nil end
	local combined = normalizeText(item.name) .. " " .. normalizeText(item.id)
	if string.find(combined, "molet", 1, true) or string.find(combined, "hood", 1, true) then
		return "COMUM"
	end
	if string.find(combined, "lenco", 1, true)
		or string.find(combined, "preto", 1, true)
		or string.find(combined, "vermelho", 1, true)
		or string.find(combined, "fina", 1, true) then
		return "EPICO"
	end
	if string.find(combined, "ninja", 1, true) and string.find(combined, "vermelho", 1, true) then
		return "RARO"
	end
	for rarityName, keys in pairs(RARITY_MATCHERS) do
		for _, k in ipairs(keys) do
			if string.find(combined, k, 1, true) then
				return rarityName
			end
		end
	end
	return "EPICO"
end

local TRAIL_THUMBS = {
	Fumaca       = "",
	Agua         = "rbxassetid://94743147904396",
	AreiaDourada = "rbxassetid://125909782299675",
}

local PUNCH_THUMBS = {
	Padrao = "rbxassetid://117364043582315",
	Agua   = "rbxassetid://104106399301450",
}

local COLOR_MAP_BY_NAME = {
	laranja = Color3.fromRGB(249, 115, 22),
	verde   = Color3.fromRGB(34, 197, 94),
	preto   = Color3.fromRGB(24, 24, 27),
	azul    = Color3.fromRGB(59, 130, 246),
	rosa    = Color3.fromRGB(236, 72, 153),
	vermelho= Color3.fromRGB(239, 68, 68),
	roxo    = Color3.fromRGB(168, 85, 247),
	branco  = Color3.fromRGB(244, 244, 245),
	amarelo = Color3.fromRGB(250, 204, 21),
	marrom  = Color3.fromRGB(122, 62, 24),
	escuro  = Color3.fromRGB(122, 62, 24),
	claro   = Color3.fromRGB(210, 174, 128),
	bege    = Color3.fromRGB(210, 174, 128),
	padrao  = Color3.fromRGB(178, 114, 68),
}

local function formatColorDisplayName(item)
	if not item then return "" end
	local raw = tostring(item.name or item.id or "")
	local norm = normalizeText(raw)
	if norm == "escuro" then
		return "Marrom"
	end
	return raw
end

local function resolveColorValue(item)
	if not item then return Color3.fromRGB(178, 114, 68) end
	if typeof(item.value) == "Color3" then return item.value end
	local rawName = normalizeText(item.name or item.id)
	for key, col in pairs(COLOR_MAP_BY_NAME) do
		if string.find(rawName, key, 1, true) then return col end
	end
	return Color3.fromRGB(178, 114, 68)
end

local function deduplicateById(list)
	local out, seen = {}, {}
	for _, item in ipairs(list or {}) do
		local id = tostring(item.id or "")
		if id ~= "" and not seen[id] then
			seen[id] = true
			out[#out + 1] = item
		end
	end
	return out
end

local REQUIRED_LENCOS = {
	{ id = "BonecoLencoBranco",   name = "LENCO BRANCA",   matchKeys = { "lenco branco", "bonecolencobranco", "lencobranco" } },
	{ id = "BonecoLencoVermelho", name = "LENCO VERMELHO", matchKeys = { "lenco vermelho", "lenco vermelha", "bonecolencovermelho", "lencovermelho", "vermelho" } },
	{ id = "BonecoLencoPreto",    name = "LENCO PRETO",    matchKeys = { "lenco preto", "lenco preta", "bonecolencopreto", "lencopreto" } },
	{ id = "BonecoLencoFina",     name = "LENCO FINA",     matchKeys = { "lenco fina", "bonecolencofina", "lencofina", "fina" } },
}

local function matchLencoSlot(item)
	if not item then return nil end
	local c = normalizeText(item.name) .. " " .. normalizeText(item.id)
	local compact = c:gsub("%s+", "")
	for slotIdx, slot in ipairs(REQUIRED_LENCOS) do
		for _, k in ipairs(slot.matchKeys) do
			local kCompact = normalizeText(k):gsub("%s+", "")
			if string.find(c, k, 1, true) or string.find(compact, kCompact, 1, true) then
				return slotIdx
			end
		end
	end
	return nil
end

local function buildSkinsByRarityOrder(rawSkins)
	local deduped = deduplicateById(rawSkins or { { id = "BonecoNoob", name = "NOOB" } })
	local buckets = {}
	for _, rName in ipairs(RARITIES) do
		buckets[rName] = {}
	end

	local foundLencos = {}
	for _, item in ipairs(deduped) do
		local slotIdx = matchLencoSlot(item)
		if slotIdx then
			if not foundLencos[slotIdx] then
				local stdName = REQUIRED_LENCOS[slotIdx].name
				foundLencos[slotIdx] = {
					id = tostring(item.id),
					name = stdName,
				}
			end
		else
			local rName = getRarityForSkin(item) or "EPICO"
			if not buckets[rName] then buckets[rName] = {} end
			table.insert(buckets[rName], item)
		end
	end

	if not buckets.EPICO then buckets.EPICO = {} end
	for slotIdx, def in ipairs(REQUIRED_LENCOS) do
		table.insert(buckets.EPICO, foundLencos[slotIdx] or { id = def.id, name = def.name })
	end

	local orderedOut = {}
	local seenIds = {}
	local seenNormNames = {}
	for _, rName in ipairs(RARITIES) do
		for _, item in ipairs(buckets[rName] or {}) do
			local normN = normalizeText(item.name or item.id)
			if item.id and not seenIds[item.id] and (normN == "" or not seenNormNames[normN]) then
				seenIds[item.id] = true
				if normN ~= "" then seenNormNames[normN] = true end
				table.insert(orderedOut, item)
			end
		end
	end

	for rName, list in pairs(buckets) do
		local inStandard = false
		for _, stdR in ipairs(RARITIES) do
			if stdR == rName then inStandard = true break end
		end
		if not inStandard then
			for _, item in ipairs(list) do
				local normN = normalizeText(item.name or item.id)
				if item.id and not seenIds[item.id] and (normN == "" or not seenNormNames[normN]) then
					seenIds[item.id] = true
					if normN ~= "" then seenNormNames[normN] = true end
					table.insert(orderedOut, item)
				end
			end
		end
	end

	return orderedOut
end

local skinList  = buildSkinsByRarityOrder(catalog.skins)
local colorList = deduplicateById(catalog.colors or { { id = "COLOR12", name = "Amarelo", value = Color3.fromRGB(250, 204, 21) } })
local trailList = deduplicateById(buildListFromItems(trailCatalog, {
	{ id = "Fumaca", name = "FUMACA", fx = "Fumaca" },
	{ id = "Agua", name = "PEGADAS D'AGUA", fx = "Agua" },
	{ id = "AreiaDourada", name = "AREIA DOURADA", fx = "AreiaDourada" },
}))
local punchList = deduplicateById(buildListFromItems(punchCatalog, {
	{ id = "Padrao", name = "SOCO PADRAO", fx = "Padrao" },
	{ id = "Agua", name = "SOCO D'AGUA", fx = "Agua" },
}))

local rgbSkinPool = {}
do
	local seen = {}
	for _, item in ipairs(skinList) do
		if item and item.id and not seen[item.id] then
			seen[item.id] = true
			rgbSkinPool[#rgbSkinPool + 1] = item
		end
	end
end

local state = {
	skinId = skinList[1] and skinList[1].id or "BonecoNoob",
	colorId = colorList[1] and colorList[1].id or "COLOR12",
	trailId = trailList[1] and trailList[1].id or "Fumaca",
	punchId = punchList[1] and punchList[1].id or "Padrao",
	rarityIdx = 1, tab = "skin", hideNames = false, autoExec = false, skinsRgb = false, minimized = false,
	nickRgb = false, spinBot = false, spinSpeed = 14,
	posX = 4, posYScale = 0, posYOffset = 100,
}

local function escapeLuaStr(val)
	local s = tostring(val or "")
	s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "")
	return '"' .. s .. '"'
end

local cachedSessionCfg = nil

local function saveConfigToFile()
	local cfg = {
		skinId = tostring(state.skinId ~= "" and state.skinId or "BonecoNoob"),
		colorId = tostring(state.colorId ~= "" and state.colorId or "COLOR12"),
		trailId = tostring(state.trailId ~= "" and state.trailId or "Fumaca"),
		punchId = tostring(state.punchId ~= "" and state.punchId or "Padrao"),
		hideNames = state.hideNames and true or false,
		autoExec = state.autoExec and true or false,
		minimized = state.minimized and true or false,
		nickRgb = state.nickRgb and true or false,
		spinBot = state.spinBot and true or false,
		spinSpeed = tonumber(state.spinSpeed) or 14,
		posX = tonumber(state.posX) or 4,
		posYScale = tonumber(state.posYScale) or 0,
		posYOffset = tonumber(state.posYOffset) or 100,
	}
	cachedSessionCfg = cfg
	if type(writefile) == "function" then
		pcall(writefile, CONFIG_FILE, table.concat({
			cfg.skinId,
			cfg.colorId,
			cfg.trailId,
			cfg.punchId,
			cfg.hideNames and "1" or "0",
			cfg.autoExec and "1" or "0",
			cfg.minimized and "1" or "0",
			tostring(cfg.posX),
			tostring(cfg.posYScale),
			tostring(cfg.posYOffset),
			cfg.nickRgb and "1" or "0",
			cfg.spinBot and "1" or "0",
			tostring(cfg.spinSpeed),
		}, "|"))
	end
	return cfg
end

local function loadSavedConfig()
	if type(isfile) == "function" and type(readfile) == "function" then
		local okExists, exists = pcall(isfile, CONFIG_FILE)
		if okExists and exists then
			local okRead, raw = pcall(readfile, CONFIG_FILE)
			if okRead and type(raw) == "string" and raw ~= "" then
				local parts = raw:split("|")
				if #parts >= 4 and parts[1] ~= "" and parts[2] ~= "" and parts[3] ~= "" and parts[4] ~= "" then
					return {
						skinId = parts[1],
						colorId = parts[2],
						trailId = parts[3],
						punchId = parts[4],
						hideNames = (parts[5] == "1"),
						autoExec = (parts[6] == "1"),
						minimized = (parts[7] == "1"),
						posX = tonumber(parts[8]) or 4,
						posYScale = tonumber(parts[9]) or 0,
						posYOffset = tonumber(parts[10]) or 100,
						nickRgb = (parts[11] == "1"),
						spinBot = (parts[12] == "1"),
						spinSpeed = tonumber(parts[13]) or 14,
					}
				end
			end
		end
	end
	if type(cachedSessionCfg) == "table" then
		return cachedSessionCfg
	end
	return nil
end

local function getEnvFn(names)
	local envTables = { _G }
	if type(getgenv) == "function" then
		local ok, g = pcall(getgenv)
		if ok and type(g) == "table" then table.insert(envTables, g) end
	end
	if type(getrenv) == "function" then
		local ok, r = pcall(getrenv)
		if ok and type(r) == "table" then table.insert(envTables, r) end
	end

	for _, name in ipairs(names) do
		if type(_G[name]) == "function" then return _G[name] end
		for _, tbl in ipairs(envTables) do
			if type(tbl[name]) == "function" then return tbl[name] end
		end
	end

	for _, tbl in ipairs(envTables) do
		for _, subName in ipairs({ "syn", "fluxus", "krnl", "delta" }) do
			local sub = tbl[subName]
			if type(sub) == "table" then
				for _, name in ipairs(names) do
					if type(sub[name]) == "function" then
						return sub[name]
					end
				end
			end
		end
	end
	return nil
end

local function getQueueTeleportFn()
	return getEnvFn({ "queue_on_teleport", "queueteleport", "queueonteleport" })
end

local function buildAutoExecPayload()
	local qUrl = escapeLuaStr(AUTO_EXEC_URL)
	return table.concat({
		"if not game:IsLoaded() then game.Loaded:Wait() end",
		"task.wait(2.2)",
		"task.spawn(function()",
		"  local ok, err = pcall(function()",
		"    loadstring(game:HttpGet(" .. qUrl .. ", true))()",
		"  end)",
		"  if not ok then",
		"    warn('[MYSTIC STORE] Auto Execute falhou: ' .. tostring(err))",
		"  end",
		"end)",
	}, "\n")
end

local function buildSavedConfigPayload(cfg)
	if type(cfg) ~= "table" then return nil end
	local qSkin = escapeLuaStr(cfg.skinId or "BonecoNoob")
	local qColor = escapeLuaStr(cfg.colorId or "COLOR12")
	local qTrail = escapeLuaStr(cfg.trailId or "Fumaca")
	local qPunch = escapeLuaStr(cfg.punchId or "Padrao")
	local hideBoolStr = cfg.hideNames and "true" or "false"

	return table.concat({
		"if not game:IsLoaded() then game.Loaded:Wait() end",
		"local Players = game:GetService('Players')",
		"local RS = game:GetService('ReplicatedStorage')",
		"local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal('LocalPlayer'):Wait() and Players.LocalPlayer",
		"task.spawn(function()",
		"  task.wait(1.1)",
		"  pcall(function() lp:SetAttribute('SGCharacterVisual', " .. qSkin .. "); lp:SetAttribute('SGCharacterColor', " .. qColor .. "); lp:SetAttribute('SGTrail', " .. qTrail .. "); lp:SetAttribute('SGPunch', " .. qPunch .. "); lp:SetAttribute('SGPunchFx', " .. qPunch .. "); lp:SetAttribute('SGHideAllNames', " .. hideBoolStr .. ") end)",
		"  local factory = RS:FindFirstChild('StumbleOriginal056Factory') or RS:WaitForChild('StumbleOriginal056Factory', 25)",
		"  local appMod = nil",
		"  if factory then local m = factory:FindFirstChild('CharacterAppearance') or factory:WaitForChild('CharacterAppearance', 10); if m and m:IsA('ModuleScript') then local ok, res = pcall(require, m); if ok and type(res) == 'table' then appMod = res end end end",
		"  local function applyChar(c) if not c then return end pcall(function() c:SetAttribute('CharacterVisual', " .. qSkin .. "); c:SetAttribute('CharacterColor', " .. qColor .. "); c:SetAttribute('SGTrail', " .. qTrail .. "); c:SetAttribute('SGPunch', " .. qPunch .. "); c:SetAttribute('SGPunchFx', " .. qPunch .. ") end); if appMod and type(appMod.Build) == 'function' then pcall(appMod.Build, c, {skin=" .. qSkin .. ",color=" .. qColor .. "}) end end",
		"  applyChar(lp.Character)",
		"  lp.CharacterAdded:Connect(function(c) task.wait(0.9); applyChar(c) end)",
		"end)",
	}, "\n")
end

local lastQueuedSignature = nil
local function queueTeleportActions(force)
	local qFn = getQueueTeleportFn()
	if type(qFn) ~= "function" then
		return false
	end

	local savedCfg = loadSavedConfig()
	local autoPayload = state.autoExec and buildAutoExecPayload() or ""
	local cfgPayload = (type(savedCfg) == "table") and buildSavedConfigPayload(savedCfg) or ""
	local sig = tostring(state.autoExec) .. "::" .. tostring(#autoPayload) .. "::" .. tostring(#cfgPayload) .. "::" .. tostring(savedCfg and savedCfg.skinId or "")

	if not force and sig == lastQueuedSignature then
		return true
	end

	local okAll = true
	if autoPayload ~= "" then
		local ok1 = pcall(qFn, autoPayload)
		if not ok1 then okAll = false end
	end

	if cfgPayload ~= "" then
		local ok2 = pcall(qFn, cfgPayload)
		if not ok2 then okAll = false end
	end

	if okAll then
		lastQueuedSignature = sig
	end
	return okAll
end

lp.OnTeleport:Connect(function()
	if state.autoExec or type(loadSavedConfig()) == "table" then
		queueTeleportActions(true)
	end
end)

local function findItemById(list, id)
	for _, item in ipairs(list) do
		if item.id == id then return item end
	end
	return list[1]
end

local function applyPunchFx(punchId, punchFxName, char)
	if type(punchSkinFx) == "table" then
		for _, fnName in ipairs({ "style", "Style", "setStyle", "SetStyle", "apply", "Apply", "setPunch", "SetPunch" }) do
			local fn = punchSkinFx[fnName]
			if type(fn) == "function" then
				pcall(fn, punchFxName); pcall(fn, punchId)
				pcall(fn, punchSkinFx, punchFxName); pcall(fn, punchSkinFx, punchId)
				if char then pcall(fn, char, punchFxName); pcall(fn, char, punchId) end
			end
		end
	end
end

local isApplyingCosmetics = false
local function applyCosmetics(charOverride)
	if isApplyingCosmetics then return end
	isApplyingCosmetics = true
	pcall(function()
		local skin = findItemById(skinList, state.skinId)
		local color = findItemById(colorList, state.colorId)
		local trail = findItemById(trailList, state.trailId)
		local punch = findItemById(punchList, state.punchId)
		local skinId = skin and skin.id or "BonecoNoob"
		local colorId = color and color.id or "COLOR12"
		local trailId = trail and trail.id or "Fumaca"
		local punchId = punch and punch.id or "Padrao"
		local punchFx = punch and punch.fx or punchId

		pcall(function()
			lp:SetAttribute("SGCharacterVisual", skinId)
			lp:SetAttribute("SGCharacterColor", colorId)
			lp:SetAttribute("SGTrail", trailId)
			lp:SetAttribute("SGPunch", punchId)
			lp:SetAttribute("SGPunchFx", punchFx)
			lp:SetAttribute("SGHideAllNames", state.hideNames)
		end)

		local char = charOverride or lp.Character
		if char and char.Parent then
			pcall(function()
				char:SetAttribute("CharacterVisual", skinId)
				char:SetAttribute("CharacterColor", colorId)
				char:SetAttribute("SGTrail", trailId)
				char:SetAttribute("SGPunch", punchId)
				char:SetAttribute("SGPunchFx", punchFx)
			end)
			if type(appearance.Build) == "function" then
				pcall(appearance.Build, char, { skin = skinId, color = colorId })
			end
			applyPunchFx(punchId, punchFx, char)
		else
			applyPunchFx(punchId, punchFx, nil)
		end
	end)
	isApplyingCosmetics = false
end

local lastRgbBuildClock = 0
local function applyRgbSkinFast(skinId, char)
	if type(skinId) ~= "string" or skinId == "" then return end
	state.skinId = skinId
	local colorId = state.colorId or "COLOR12"

	pcall(function()
		if lp then
			lp:SetAttribute("SGCharacterVisual", skinId)
		end
	end)

	if char and char.Parent then
		pcall(function()
			char:SetAttribute("CharacterVisual", skinId)
		end)
		local now = os.clock()
		if (now - lastRgbBuildClock) >= 0.75 and type(appearance) == "table" and type(appearance.Build) == "function" then
			lastRgbBuildClock = now
			pcall(appearance.Build, char, { skin = skinId, color = colorId })
		end
	end
end

-- ══ NICK RGB & SPINBOT (VISUAL / LOCAL) ══
local cachedNameLabels = {}
local lastNameScanClock = 0

local function refreshNameLabels(char)
	table.clear(cachedNameLabels)
	if not char or not char.Parent then return end
	pcall(function()
		for _, desc in ipairs(char:GetDescendants()) do
			if desc:IsA("TextLabel") and desc:FindFirstAncestorOfClass("BillboardGui") then
				cachedNameLabels[#cachedNameLabels + 1] = desc
			end
		end
	end)
end

local function applyNickRgbColor(char, col)
	if not char or not char.Parent then return end
	local now = os.clock()
	if (now - lastNameScanClock) >= 1.5 or #cachedNameLabels == 0 then
		lastNameScanClock = now
		refreshNameLabels(char)
	end

	pcall(function()
		for i = #cachedNameLabels, 1, -1 do
			local lbl = cachedNameLabels[i]
			if lbl and lbl.Parent then
				lbl.TextColor3 = col
			else
				table.remove(cachedNameLabels, i)
			end
		end
	end)
end

local function restoreHumanoidAutoRotate(char)
	if not char then return end
	pcall(function()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and not hum.AutoRotate then
			hum.AutoRotate = true
		end
	end)
end

local rgbHue = 0
local worldStepAcc = 0
local worldConn = nil

local function startWorldEffectsLoop()
	if worldConn then return end
	worldConn = RunService.Heartbeat:Connect(function(dt)
		if not state.nickRgb and not state.spinBot then
			return
		end
		worldStepAcc += dt
		if worldStepAcc < 0.03 then
			return
		end
		local step = worldStepAcc
		worldStepAcc = 0

		local char = lp and lp.Character
		if not char or not char.Parent then
			return
		end

		if state.nickRgb then
			rgbHue = (rgbHue + step * 0.45) % 1
			applyNickRgbColor(char, Color3.fromHSV(rgbHue, 0.85, 1))
		end

		if state.spinBot then
			pcall(function()
				local hum = char:FindFirstChildOfClass("Humanoid")
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if hum and hrp and hum.Health > 0 then
					if hum.AutoRotate then
						hum.AutoRotate = false
					end
					local speed = tonumber(state.spinSpeed) or 14
					hrp.CFrame = hrp.CFrame * CFrame.Angles(0, speed * step, 0)
				end
			end)
		end
	end)
end

local function stopWorldEffectsLoopIfIdle()
	if not state.nickRgb and not state.spinBot then
		if worldConn then
			worldConn:Disconnect()
			worldConn = nil
		end
		restoreHumanoidAutoRotate(lp and lp.Character)
	end
end

-- ══ UI ══
pcall(function()
	local g = CG:FindFirstChild("MysticStorePanelV3")
	if g then g:Destroy() end
end)
pcall(function()
	local lg = CG:FindFirstChild("MysticPanelV3")
	if lg then lg:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "MysticStorePanelV3"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() gui.Parent = CG end) then
	pcall(function()
		gui.Parent = lp:WaitForChild("PlayerGui")
	end)
end

local T = {
	bg = Color3.fromRGB(13, 14, 22), header = Color3.fromRGB(20, 22, 35),
	card = Color3.fromRGB(26, 29, 46), cardSel = Color3.fromRGB(38, 44, 72),
	btn = Color3.fromRGB(38, 44, 68), accent = Color3.fromRGB(99, 102, 241),
	accentD = Color3.fromRGB(55, 58, 160), text = Color3.fromRGB(240, 243, 255),
	muted = Color3.fromRGB(140, 148, 180), danger = Color3.fromRGB(180, 40, 55),
	tabBg = Color3.fromRGB(18, 20, 32), tabSel = Color3.fromRGB(99, 102, 241),
	preview = Color3.fromRGB(18, 20, 34), imgBg = Color3.fromRGB(20, 23, 40),
}

local function corner(inst, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = inst
end
local function stroke(inst, color, thickness)
	local s = Instance.new("UIStroke"); s.Color = color or T.accent; s.Thickness = thickness or 1.5; s.Parent = inst
end

local PANEL_W, PANEL_H = 304, 286
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
main.Position = UDim2.new(0, state.posX, state.posYScale, state.posYOffset)
main.BackgroundColor3 = T.bg; main.BorderSizePixel = 0; main.Active = true; main.Parent = gui
corner(main, 11); stroke(main, Color3.fromRGB(50, 55, 90), 1)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 30); header.BackgroundColor3 = T.header; header.BorderSizePixel = 0; header.Parent = main
corner(header, 11)

local abar = Instance.new("Frame")
abar.Size = UDim2.new(0, 4, 0, 16); abar.Position = UDim2.new(0, 9, 0.5, -8)
abar.BackgroundColor3 = T.accent; abar.BorderSizePixel = 0; abar.Parent = header; corner(abar, 2)

local function textLabel(parent, size, pos, text, font, textSize, color, xAlign)
	local l = Instance.new("TextLabel")
	l.Size = size; l.Position = pos; l.BackgroundTransparency = 1; l.Text = text
	l.Font = font or Enum.Font.GothamBold; l.TextSize = textSize or 11; l.TextColor3 = color or T.text
	l.TextXAlignment = xAlign or Enum.TextXAlignment.Left; l.Parent = parent
	return l
end

textLabel(header, UDim2.new(0, 150, 1, 0), UDim2.new(0, 17, 0, 0), "MYSTIC STORE", Enum.Font.GothamBlack, 11, T.text)

local function headerBtn(xOff, txt, bg)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 22, 0, 22); b.Position = UDim2.new(1, xOff, 0.5, -11)
	b.BackgroundColor3 = bg or T.btn; b.BorderSizePixel = 0; b.Text = txt; b.TextColor3 = T.text
	b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.Parent = header; corner(b, 6)
	return b
end

local minBtn = headerBtn(-52, "-")
local closeBtn = headerBtn(-26, "X", T.danger)

local body = Instance.new("Frame")
body.Name = "Body"; body.Size = UDim2.new(1, -10, 1, -36); body.Position = UDim2.new(0, 5, 0, 33)
body.BackgroundTransparency = 1; body.Parent = main

local function safeSetProp(inst, propName, value)
	pcall(function()
		if inst then
			inst[propName] = value
		end
	end)
end

local updatePreview

local function applyMinimizeState(minimized, persist)
	state.minimized = minimized and true or false
	safeSetProp(body, "Visible", not state.minimized)
	safeSetProp(main, "Size", state.minimized and UDim2.new(0, PANEL_W, 0, 30) or UDim2.new(0, PANEL_W, 0, PANEL_H))
	safeSetProp(minBtn, "Text", state.minimized and "+" or "-")
	if persist then
		saveConfigToFile()
	end
	if not state.minimized and type(updatePreview) == "function" then
		updatePreview()
	end
end

local dragging = false
local dragInput = nil
local dragStartPos = Vector2.zero
local startMainPos = main.Position

local function clampMainPosition(targetPos)
	local vpSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	local curH = state.minimized and 30 or PANEL_H
	local maxX = math.max(0, vpSize.X - PANEL_W)
	local maxY = math.max(0, vpSize.Y - curH)
	local absX = math.clamp(targetPos.X.Scale * vpSize.X + targetPos.X.Offset, 0, maxX)
	local absY = math.clamp(targetPos.Y.Scale * vpSize.Y + targetPos.Y.Offset, 0, maxY)
	return UDim2.new(0, math.floor(absX + 0.5), 0, math.floor(absY + 0.5))
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local pos2 = input.Position
		local function hitBtn(btn)
			local ok, hit = pcall(function()
				local p = btn.AbsolutePosition
				local s = btn.AbsoluteSize
				return pos2.X >= p.X and pos2.X <= p.X + s.X and pos2.Y >= p.Y and pos2.Y <= p.Y + s.Y
			end)
			return ok and hit
		end
		if hitBtn(minBtn) or hitBtn(closeBtn) then return end

		dragging = true
		dragInput = input
		dragStartPos = input.Position
		startMainPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End and dragInput == input then
				dragging = false
				dragInput = nil
				state.posX = main.Position.X.Offset
				state.posYScale = 0
				state.posYOffset = main.Position.Y.Offset
				saveConfigToFile()
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging and not dragInput then
			dragInput = input
		end
	end
end)

UIS.InputChanged:Connect(function(input)
	if not dragging or input ~= dragInput then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStartPos
		local nextPos = UDim2.new(
			startMainPos.X.Scale,
			startMainPos.X.Offset + delta.X,
			startMainPos.Y.Scale,
			startMainPos.Y.Offset + delta.Y
		)
		local clamped = clampMainPosition(nextPos)
		safeSetProp(main, "Position", clamped)
		state.posX = clamped.X.Offset
		state.posYScale = 0
		state.posYOffset = clamped.Y.Offset
	end
end)

local tabBar = Instance.new("ScrollingFrame")
tabBar.Size = UDim2.new(1, 0, 0, 24); tabBar.BackgroundColor3 = T.tabBg; tabBar.BorderSizePixel = 0
tabBar.ScrollBarThickness = 2; tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X; tabBar.ScrollingDirection = Enum.ScrollingDirection.X; tabBar.Parent = body
corner(tabBar, 7)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.Padding = UDim.new(0, 3)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; tabLayout.Parent = tabBar

local tabPad = Instance.new("UIPadding")
tabPad.PaddingLeft = UDim.new(0, 3); tabPad.PaddingRight = UDim.new(0, 3); tabPad.Parent = tabBar

local rarityBar = Instance.new("ScrollingFrame")
rarityBar.Size = UDim2.new(1, -92, 0, 22); rarityBar.Position = UDim2.new(0, 0, 0, 27)
rarityBar.BackgroundColor3 = T.tabBg; rarityBar.BorderSizePixel = 0; rarityBar.ScrollBarThickness = 2
rarityBar.CanvasSize = UDim2.new(0, 0, 0, 0); rarityBar.AutomaticCanvasSize = Enum.AutomaticSize.X
rarityBar.ScrollingDirection = Enum.ScrollingDirection.X; rarityBar.Parent = body; corner(rarityBar, 6)

local rarityLayout = Instance.new("UIListLayout")
rarityLayout.FillDirection = Enum.FillDirection.Horizontal; rarityLayout.Padding = UDim.new(0, 3)
rarityLayout.VerticalAlignment = Enum.VerticalAlignment.Center; rarityLayout.Parent = rarityBar

local rarityPad = Instance.new("UIPadding")
rarityPad.PaddingLeft = UDim.new(0, 3); rarityPad.PaddingRight = UDim.new(0, 3); rarityPad.Parent = rarityBar

local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0, 88, 1, -27); previewFrame.Position = UDim2.new(1, -88, 0, 27)
previewFrame.BackgroundColor3 = T.preview; previewFrame.BorderSizePixel = 0; previewFrame.Parent = body
corner(previewFrame, 9); stroke(previewFrame, Color3.fromRGB(60, 65, 100), 1)

textLabel(previewFrame, UDim2.new(1, -6, 0, 14), UDim2.new(0, 3, 0, 3), "PREVIEW", Enum.Font.GothamBold, 8, T.muted, Enum.TextXAlignment.Center)

local previewImg = Instance.new("ImageLabel")
previewImg.Size = UDim2.new(1, -12, 0, 56); previewImg.Position = UDim2.new(0, 6, 0, 18)
previewImg.BackgroundColor3 = T.imgBg; previewImg.BorderSizePixel = 0; previewImg.Image = ""
previewImg.ScaleType = Enum.ScaleType.Fit; previewImg.Parent = previewFrame; corner(previewImg, 6)

local previewSwatch = Instance.new("Frame")
previewSwatch.Size = UDim2.new(1, -12, 0, 56); previewSwatch.Position = UDim2.new(0, 6, 0, 18)
previewSwatch.BackgroundColor3 = Color3.fromRGB(178, 114, 68); previewSwatch.BorderSizePixel = 0
previewSwatch.Visible = false; previewSwatch.Parent = previewFrame; corner(previewSwatch, 6)

local previewName = Instance.new("TextLabel")
previewName.Size = UDim2.new(1, -6, 0, 24); previewName.Position = UDim2.new(0, 3, 0, 76)
previewName.BackgroundTransparency = 1; previewName.Text = ""; previewName.TextColor3 = T.text
previewName.Font = Enum.Font.GothamBold; previewName.TextSize = 8
previewName.TextXAlignment = Enum.TextXAlignment.Center; previewName.TextWrapped = true; previewName.Parent = previewFrame

local previewRarityLbl = Instance.new("TextLabel")
previewRarityLbl.Size = UDim2.new(1, -6, 0, 14); previewRarityLbl.Position = UDim2.new(0, 3, 0, 100)
previewRarityLbl.BackgroundTransparency = 1; previewRarityLbl.Text = ""; previewRarityLbl.TextColor3 = T.accent
previewRarityLbl.Font = Enum.Font.GothamBlack; previewRarityLbl.TextSize = 8
previewRarityLbl.TextXAlignment = Enum.TextXAlignment.Center; previewRarityLbl.Parent = previewFrame

local gridClip = Instance.new("Frame")
gridClip.Size = UDim2.new(1, -92, 1, -52); gridClip.Position = UDim2.new(0, 0, 0, 52)
gridClip.BackgroundTransparency = 1; gridClip.ClipsDescendants = true; gridClip.Parent = body

local grid = Instance.new("ScrollingFrame")
grid.Size = UDim2.new(1, 0, 1, 0); grid.BackgroundTransparency = 1; grid.BorderSizePixel = 0
grid.ScrollBarThickness = 2; grid.ScrollBarImageColor3 = T.accent
grid.CanvasSize = UDim2.new(0, 0, 0, 0); grid.AutomaticCanvasSize = Enum.AutomaticSize.Y; grid.Parent = gridClip

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 62, 0, 74); gridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder; gridLayout.Parent = grid

local gridPad = Instance.new("UIPadding")
gridPad.PaddingTop = UDim.new(0, 2); gridPad.PaddingLeft = UDim.new(0, 2); gridPad.Parent = grid

local miscFrame = Instance.new("ScrollingFrame")
miscFrame.Size = UDim2.new(1, 0, 1, -28); miscFrame.Position = UDim2.new(0, 0, 0, 28)
miscFrame.BackgroundTransparency = 1; miscFrame.BorderSizePixel = 0; miscFrame.ScrollBarThickness = 2
miscFrame.ScrollBarImageColor3 = T.accent; miscFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
miscFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y; miscFrame.Visible = false; miscFrame.Parent = body

local miscLayout = Instance.new("UIListLayout")
miscLayout.FillDirection = Enum.FillDirection.Vertical; miscLayout.Padding = UDim.new(0, 5)
miscLayout.SortOrder = Enum.SortOrder.LayoutOrder; miscLayout.Parent = miscFrame

local miscPad = Instance.new("UIPadding")
miscPad.PaddingTop = UDim.new(0, 3); miscPad.PaddingLeft = UDim.new(0, 2); miscPad.PaddingRight = UDim.new(0, 4)
miscPad.PaddingBottom = UDim.new(0, 4); miscPad.Parent = miscFrame

local function makeMiscToggleRow(order, labelText)
	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, 38); box.LayoutOrder = order
	box.BackgroundColor3 = T.card; box.BorderSizePixel = 0; box.Parent = miscFrame
	corner(box, 8); stroke(box, Color3.fromRGB(60, 65, 100), 1)

	textLabel(box, UDim2.new(1, -54, 1, 0), UDim2.new(0, 10, 0, 0), labelText, Enum.Font.GothamBlack, 9, T.text)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 36, 0, 22); btn.Position = UDim2.new(1, -44, 0.5, -11)
	btn.BackgroundColor3 = T.btn; btn.BorderSizePixel = 0; btn.Text = "OFF"
	btn.TextColor3 = T.muted; btn.Font = Enum.Font.GothamBlack; btn.TextSize = 9; btn.Parent = box; corner(btn, 6)
	return btn
end

local autoExecToggle = makeMiscToggleRow(1, "AUTO EXECUTE")
local skinsRgbToggle = makeMiscToggleRow(2, "SKINS RGB")
local nickRgbToggle  = makeMiscToggleRow(3, "NICK RGB")
local spinBotToggle  = makeMiscToggleRow(4, "SPINBOT")

local spinSpeedBox = Instance.new("Frame")
spinSpeedBox.Size = UDim2.new(1, 0, 0, 38); spinSpeedBox.LayoutOrder = 5
spinSpeedBox.BackgroundColor3 = T.card; spinSpeedBox.BorderSizePixel = 0; spinSpeedBox.Parent = miscFrame
corner(spinSpeedBox, 8); stroke(spinSpeedBox, Color3.fromRGB(60, 65, 100), 1)

local spinSpeedLbl = textLabel(spinSpeedBox, UDim2.new(1, -86, 1, 0), UDim2.new(0, 10, 0, 0), "VELOCIDADE SPIN: 14", Enum.Font.GothamBlack, 8, T.text)

local spinMinusBtn = Instance.new("TextButton")
spinMinusBtn.Size = UDim2.new(0, 24, 0, 22); spinMinusBtn.Position = UDim2.new(1, -60, 0.5, -11)
spinMinusBtn.BackgroundColor3 = T.btn; spinMinusBtn.BorderSizePixel = 0; spinMinusBtn.Text = "-"
spinMinusBtn.TextColor3 = T.text; spinMinusBtn.Font = Enum.Font.GothamBlack; spinMinusBtn.TextSize = 10; spinMinusBtn.Parent = spinSpeedBox; corner(spinMinusBtn, 6)

local spinPlusBtn = Instance.new("TextButton")
spinPlusBtn.Size = UDim2.new(0, 24, 0, 22); spinPlusBtn.Position = UDim2.new(1, -30, 0.5, -11)
spinPlusBtn.BackgroundColor3 = T.accent; spinPlusBtn.BorderSizePixel = 0; spinPlusBtn.Text = "+"
spinPlusBtn.TextColor3 = T.text; spinPlusBtn.Font = Enum.Font.GothamBlack; spinPlusBtn.TextSize = 10; spinPlusBtn.Parent = spinSpeedBox; corner(spinPlusBtn, 6)

local saveCfgBox = Instance.new("Frame")
saveCfgBox.Size = UDim2.new(1, 0, 0, 38); saveCfgBox.LayoutOrder = 6
saveCfgBox.BackgroundColor3 = T.card; saveCfgBox.BorderSizePixel = 0; saveCfgBox.Parent = miscFrame
corner(saveCfgBox, 8); stroke(saveCfgBox, Color3.fromRGB(60, 65, 100), 1)

textLabel(saveCfgBox, UDim2.new(1, -86, 1, 0), UDim2.new(0, 10, 0, 0), "SALVAR CONFIGURACAO", Enum.Font.GothamBlack, 9, T.text)

local saveCfgBtn = Instance.new("TextButton")
saveCfgBtn.Size = UDim2.new(0, 64, 0, 22); saveCfgBtn.Position = UDim2.new(1, -72, 0.5, -11)
saveCfgBtn.BackgroundColor3 = T.accent; saveCfgBtn.BorderSizePixel = 0; saveCfgBtn.Text = "SALVAR"
saveCfgBtn.TextColor3 = T.text; saveCfgBtn.Font = Enum.Font.GothamBlack; saveCfgBtn.TextSize = 8; saveCfgBtn.Parent = saveCfgBox; corner(saveCfgBtn, 6)

local hideToggle = makeMiscToggleRow(7, "NOMES")

local gridCards, rarityBtns = {}, {}

local function getSelectedIdKey(tabId)
	return ({ skin = "skinId", color = "colorId", trail = "trailId", punch = "punchId" })[tabId]
end
local function getListForTab(tabId)
	return ({ skin = skinList, color = colorList, trail = trailList, punch = punchList })[tabId] or {}
end
local function getThumbData(tabId, item)
	local id = item.id
	if tabId == "skin" then
		local rawThumb = findSkinThumbRaw(item)
		return resolveThumbAsset(rawThumb), false, nil
	elseif tabId == "trail" then return TRAIL_THUMBS[id] or "", false, nil
	elseif tabId == "punch" then return PUNCH_THUMBS[id] or "", false, nil
	elseif tabId == "color" then return "", true, resolveColorValue(item) end
	return "", false, nil
end

local function canTouchUi()
	local ok, ready = pcall(function()
		if state.minimized or state.tab == "misc" then return false end
		if not gui or not main or not body then return false end
		local pGui = gui.Parent
		local pMain = main.Parent
		local pBody = body.Parent
		return pGui ~= nil and pMain ~= nil and pBody ~= nil
	end)
	return ok and ready == true
end

updatePreview = function()
	task.defer(function()
		if not canTouchUi() then
			return
		end
		local list, idKey, item
		local okData = pcall(function()
			list = getListForTab(state.tab)
			idKey = getSelectedIdKey(state.tab)
			item = findItemById(list, state[idKey])
		end)
		if not okData or not item then return end

		local img, isSwatch, swatchColor = "", false, Color3.fromRGB(178, 114, 68)
		pcall(function()
			img, isSwatch, swatchColor = getThumbData(state.tab, item)
		end)

		if isSwatch then
			safeSetProp(previewImg, "Visible", false)
			safeSetProp(previewSwatch, "Visible", true)
			safeSetProp(previewSwatch, "BackgroundColor3", swatchColor or Color3.fromRGB(178, 114, 68))
		else
			safeSetProp(previewSwatch, "Visible", false)
			safeSetProp(previewImg, "Visible", true)
			safeSetProp(previewImg, "Image", img)
			safeSetProp(previewImg, "ScaleType", Enum.ScaleType.Fit)
		end

		local displayText = ""
		local rarityText = ""
		pcall(function()
			displayText = (state.tab == "color") and formatColorDisplayName(item) or tostring(item.name or item.id or "")
			rarityText = (state.tab == "skin") and tostring(getRarityForSkin(item) or "") or string.upper(tostring(state.tab or ""))
		end)

		safeSetProp(previewName, "Text", displayText)
		safeSetProp(previewRarityLbl, "Text", rarityText)

		for _, entry in ipairs(gridCards) do
			if entry and entry.card then
				local sel = (entry.itemId == item.id)
				safeSetProp(entry.card, "BackgroundColor3", sel and T.cardSel or T.card)
				pcall(function()
					local s = entry.card:FindFirstChildOfClass("UIStroke")
					if s then
						s.Enabled = sel
					end
				end)
			end
		end
	end)
end

local function refreshRarityButtons()
	task.defer(function()
		pcall(function()
			local selectedRarity = RARITIES[state.rarityIdx] or RARITIES[1]
			for _, rb in ipairs(rarityBtns) do
				if rb.btn then
					local isSel = (rb.rarity == selectedRarity)
					safeSetProp(rb.btn, "BackgroundColor3", isSel and T.accent or T.card)
					safeSetProp(rb.btn, "TextColor3", isSel and T.text or T.muted)
				end
			end
		end)
	end)
end

local function setSkinsRgbVisual(enabled)
	safeSetProp(skinsRgbToggle, "Text", enabled and "ON" or "OFF")
	safeSetProp(skinsRgbToggle, "TextColor3", enabled and T.text or T.muted)
	safeSetProp(skinsRgbToggle, "BackgroundColor3", enabled and T.accentD or T.btn)
end

local function setNickRgbVisual(enabled)
	safeSetProp(nickRgbToggle, "Text", enabled and "ON" or "OFF")
	safeSetProp(nickRgbToggle, "TextColor3", enabled and T.text or T.muted)
	safeSetProp(nickRgbToggle, "BackgroundColor3", enabled and T.accentD or T.btn)
end

local function setSpinBotVisual(enabled)
	safeSetProp(spinBotToggle, "Text", enabled and "ON" or "OFF")
	safeSetProp(spinBotToggle, "TextColor3", enabled and T.text or T.muted)
	safeSetProp(spinBotToggle, "BackgroundColor3", enabled and T.accentD or T.btn)
end

local function syncSpinSpeedLabel()
	safeSetProp(spinSpeedLbl, "Text", "VELOCIDADE SPIN: " .. tostring(math.floor((tonumber(state.spinSpeed) or 14) + 0.5)))
end

local rgbLoopGen = 0
local function startSkinsRgbLoop()
	rgbLoopGen += 1
	local currentGen = rgbLoopGen
	task.spawn(function()
		local idx = 1
		while state.skinsRgb and currentGen == rgbLoopGen do
			local pool = rgbSkinPool
			local count = (type(pool) == "table") and #pool or 0
			if count > 0 then
				if idx < 1 or idx > count then
					idx = 1
				end
				local item = pool[idx]
				local char = lp and lp.Character
				if (not char or not char.Parent) and lp and state.skinsRgb and currentGen == rgbLoopGen then
					pcall(function()
						char = lp.CharacterAdded:Wait()
					end)
					if state.skinsRgb and currentGen == rgbLoopGen then
						task.wait(0.35)
					end
				end
				if item and item.id and state.skinsRgb and currentGen == rgbLoopGen then
					applyRgbSkinFast(tostring(item.id), char)
					if not state.minimized and state.tab == "skin" then
						updatePreview()
					end
				end
				idx += 1
				if state.skinsRgb and currentGen == rgbLoopGen then
					task.wait(1.15)
				end
			else
				if state.skinsRgb and currentGen == rgbLoopGen then
					task.wait(1.15)
				end
			end
		end
	end)
end

local function setSkinsRgbEnabled(enabled)
	local nextVal = enabled and true or false
	state.skinsRgb = nextVal
	rgbLoopGen += 1
	setSkinsRgbVisual(nextVal)
	if nextVal then
		startSkinsRgbLoop()
	end
end

local function setNickRgbEnabled(enabled)
	state.nickRgb = enabled and true or false
	setNickRgbVisual(state.nickRgb)
	lastNameScanClock = 0
	if state.nickRgb then
		refreshNameLabels(lp and lp.Character)
		startWorldEffectsLoop()
	else
		stopWorldEffectsLoopIfIdle()
	end
end

local function setSpinBotEnabled(enabled)
	state.spinBot = enabled and true or false
	setSpinBotVisual(state.spinBot)
	if state.spinBot then
		startWorldEffectsLoop()
	else
		stopWorldEffectsLoopIfIdle()
	end
end

local function buildGrid(tabId)
	task.defer(function()
		pcall(function()
			for _, entry in ipairs(gridCards) do
				if entry.card then pcall(function() entry.card:Destroy() end) end
			end
			gridCards = {}

			local isSkinTab = (tabId == "skin")
			local isMiscTab = (tabId == "misc")
			safeSetProp(rarityBar, "Visible", isSkinTab)
			safeSetProp(miscFrame, "Visible", isMiscTab)
			safeSetProp(previewFrame, "Visible", not isMiscTab)
			safeSetProp(gridClip, "Visible", not isMiscTab)
			if isMiscTab then return end

			safeSetProp(gridClip, "Position", isSkinTab and UDim2.new(0, 0, 0, 52) or UDim2.new(0, 0, 0, 28))
			safeSetProp(gridClip, "Size", isSkinTab and UDim2.new(1, -92, 1, -52) or UDim2.new(1, -92, 1, -28))

			local list = getListForTab(tabId)
			local idKey = getSelectedIdKey(tabId)
			local selectedRarity = RARITIES[state.rarityIdx] or RARITIES[1]

			for i, item in ipairs(list) do
				if (not isSkinTab) or (getRarityForSkin(item) == selectedRarity) then
					local img, isSwatch, swatchColor = getThumbData(tabId, item)
					local card = Instance.new("TextButton")
					card.Size = UDim2.new(0, 62, 0, 74); card.BackgroundColor3 = T.card; card.BorderSizePixel = 0
					card.Text = ""; card.LayoutOrder = i; card.Parent = grid; corner(card, 7)

					local sel = Instance.new("UIStroke")
					sel.Color = T.accent; sel.Thickness = 2; sel.Enabled = false; sel.Parent = card

					local imgArea = Instance.new("Frame")
					imgArea.Size = UDim2.new(1, -6, 0, 44); imgArea.Position = UDim2.new(0, 3, 0, 3)
					imgArea.BackgroundColor3 = isSwatch and (swatchColor or Color3.fromRGB(178, 114, 68)) or T.imgBg
					imgArea.BorderSizePixel = 0; imgArea.Parent = card; corner(imgArea, 5)

					if not isSwatch and img ~= "" then
						local icoImg = Instance.new("ImageLabel")
						icoImg.Size = UDim2.new(1, 0, 1, 0); icoImg.BackgroundTransparency = 1
						icoImg.Image = img; icoImg.ScaleType = Enum.ScaleType.Fit; icoImg.Parent = imgArea
					end

					local nameLbl = Instance.new("TextLabel")
					nameLbl.Size = UDim2.new(1, -4, 0, 22); nameLbl.Position = UDim2.new(0, 2, 0, 49)
					nameLbl.BackgroundTransparency = 1
					nameLbl.Text = (tabId == "color") and formatColorDisplayName(item) or tostring(item.name or item.id or "")
					nameLbl.TextColor3 = T.text
					nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 7; nameLbl.TextWrapped = true
					nameLbl.TextXAlignment = Enum.TextXAlignment.Center; nameLbl.Parent = card

					gridCards[#gridCards + 1] = { card = card, itemId = item.id }
					local capturedId = item.id
					card.MouseButton1Click:Connect(function()
						if idKey == "skinId" and state.skinsRgb then
							setSkinsRgbEnabled(false)
						end
						state[idKey] = capturedId; updatePreview(); applyCosmetics()
					end)
				end
			end
			updatePreview()
		end)
	end)
end

for idx, rName in ipairs(RARITIES) do
	local rb = Instance.new("TextButton")
	rb.Size = UDim2.new(0, 56, 0, 18); rb.BackgroundColor3 = T.card; rb.BorderSizePixel = 0
	rb.Text = rName; rb.TextColor3 = T.muted; rb.Font = Enum.Font.GothamBold; rb.TextSize = 7
	rb.Parent = rarityBar; corner(rb, 5)
	rarityBtns[#rarityBtns + 1] = { rarity = rName, btn = rb }
	local capturedRarityIdx = idx
	rb.MouseButton1Click:Connect(function()
		state.rarityIdx = capturedRarityIdx; refreshRarityButtons()
		if state.tab == "skin" then buildGrid("skin") end
	end)
end

local tabBtns = {}
local TABS = {
	{ id = "skin", label = "SKIN" }, { id = "color", label = "COR" },
	{ id = "trail", label = "TRAIL" }, { id = "punch", label = "PUNCH" }, { id = "misc", label = "MISC" },
}

local function switchTab(tabId)
	state.tab = tabId
	task.defer(function()
		pcall(function()
			for _, tb in ipairs(tabBtns) do
				if tb.btn then
					safeSetProp(tb.btn, "BackgroundColor3", (tb.id == tabId) and T.tabSel or T.tabBg)
					safeSetProp(tb.btn, "TextColor3", (tb.id == tabId) and T.text or T.muted)
				end
			end
		end)
	end)
	buildGrid(tabId)
end

for _, def in ipairs(TABS) do
	local tb = Instance.new("TextButton")
	tb.Size = UDim2.new(0, 52, 0, 18); tb.BackgroundColor3 = T.tabBg; tb.BorderSizePixel = 0
	tb.Text = def.label; tb.TextColor3 = T.muted; tb.Font = Enum.Font.GothamBold; tb.TextSize = 8
	tb.Parent = tabBar; corner(tb, 6)
	tabBtns[#tabBtns + 1] = { id = def.id, btn = tb }
	tb.MouseButton1Click:Connect(function() switchTab(def.id) end)
end

local function syncAutoExecVisual()
	safeSetProp(autoExecToggle, "Text", state.autoExec and "ON" or "OFF")
	safeSetProp(autoExecToggle, "TextColor3", state.autoExec and T.text or T.muted)
	safeSetProp(autoExecToggle, "BackgroundColor3", state.autoExec and T.accentD or T.btn)
end

autoExecToggle.MouseButton1Click:Connect(function()
	state.autoExec = not state.autoExec
	syncAutoExecVisual()
	saveConfigToFile()
	if state.autoExec then
		queueTeleportActions(true)
	else
		lastQueuedSignature = nil
	end
end)

skinsRgbToggle.MouseButton1Click:Connect(function()
	setSkinsRgbEnabled(not state.skinsRgb)
end)

nickRgbToggle.MouseButton1Click:Connect(function()
	setNickRgbEnabled(not state.nickRgb)
end)

spinBotToggle.MouseButton1Click:Connect(function()
	setSpinBotEnabled(not state.spinBot)
end)

spinMinusBtn.MouseButton1Click:Connect(function()
	state.spinSpeed = math.max(4, (tonumber(state.spinSpeed) or 14) - 4)
	syncSpinSpeedLabel()
end)

spinPlusBtn.MouseButton1Click:Connect(function()
	state.spinSpeed = math.min(40, (tonumber(state.spinSpeed) or 14) + 4)
	syncSpinSpeedLabel()
end)

saveCfgBtn.MouseButton1Click:Connect(function()
	saveConfigToFile()
	queueTeleportActions(true)
	safeSetProp(saveCfgBtn, "Text", "SALVO")
	safeSetProp(saveCfgBtn, "BackgroundColor3", T.accentD)
	task.delay(1.2, function()
		safeSetProp(saveCfgBtn, "Text", "SALVAR")
		safeSetProp(saveCfgBtn, "BackgroundColor3", T.accent)
	end)
end)

hideToggle.MouseButton1Click:Connect(function()
	state.hideNames = not state.hideNames
	safeSetProp(hideToggle, "Text", state.hideNames and "ON" or "OFF")
	safeSetProp(hideToggle, "TextColor3", state.hideNames and T.text or T.muted)
	safeSetProp(hideToggle, "BackgroundColor3", state.hideNames and T.accentD or T.btn)
	pcall(lp.SetAttribute, lp, "SGHideAllNames", state.hideNames)
end)

minBtn.MouseButton1Click:Connect(function()
	applyMinimizeState(not state.minimized, true)
end)

closeBtn.MouseButton1Click:Connect(function()
	setSkinsRgbEnabled(false)
	state.nickRgb = false
	state.spinBot = false
	stopWorldEffectsLoopIfIdle()
	pcall(function() gui:Destroy() end)
end)

lp.CharacterAdded:Connect(function(char)
	lastNameScanClock = 0
	table.clear(cachedNameLabels)
	task.wait(0.8)
	applyCosmetics(char)
	if state.nickRgb then
		refreshNameLabels(char)
	end
end)

task.spawn(function()
	pcall(function()
		refreshRarityButtons()
		switchTab("skin")
		syncSpinSpeedLabel()

		local savedCfg = loadSavedConfig()
		if type(savedCfg) == "table" then
			if type(savedCfg.skinId) == "string" and savedCfg.skinId ~= "" then state.skinId = savedCfg.skinId end
			if type(savedCfg.colorId) == "string" and savedCfg.colorId ~= "" then state.colorId = savedCfg.colorId end
			if type(savedCfg.trailId) == "string" and savedCfg.trailId ~= "" then state.trailId = savedCfg.trailId end
			if type(savedCfg.punchId) == "string" and savedCfg.punchId ~= "" then state.punchId = savedCfg.punchId end
			if type(savedCfg.hideNames) == "boolean" then state.hideNames = savedCfg.hideNames end
			if type(savedCfg.autoExec) == "boolean" then state.autoExec = savedCfg.autoExec end
			if type(savedCfg.minimized) == "boolean" then state.minimized = savedCfg.minimized end
			if type(savedCfg.nickRgb) == "boolean" then state.nickRgb = savedCfg.nickRgb end
			if type(savedCfg.spinBot) == "boolean" then state.spinBot = savedCfg.spinBot end
			state.spinSpeed = tonumber(savedCfg.spinSpeed) or 14
			state.posX = tonumber(savedCfg.posX) or 4
			state.posYScale = tonumber(savedCfg.posYScale) or 0
			state.posYOffset = tonumber(savedCfg.posYOffset) or 100

			local restoredPos = clampMainPosition(UDim2.new(0, state.posX, state.posYScale, state.posYOffset))
			safeSetProp(main, "Position", restoredPos)
			applyMinimizeState(state.minimized, false)

			safeSetProp(hideToggle, "Text", state.hideNames and "ON" or "OFF")
			safeSetProp(hideToggle, "TextColor3", state.hideNames and T.text or T.muted)
			safeSetProp(hideToggle, "BackgroundColor3", state.hideNames and T.accentD or T.btn)
			setNickRgbVisual(state.nickRgb)
			setSpinBotVisual(state.spinBot)
			syncSpinSpeedLabel()
			if state.nickRgb or state.spinBot then
				startWorldEffectsLoop()
			end
			syncAutoExecVisual()
			applyCosmetics(lp.Character)
			updatePreview()
		end
	end)

	task.wait(1.5)
	pcall(function()
		if state.autoExec then
			syncAutoExecVisual()
			queueTeleportActions(true)
		end
	end)
end)
