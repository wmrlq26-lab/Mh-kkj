-- MYSTIC STORE | Cosmetics & Visuals Panel V3
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CG = game:GetService("CoreGui")

local lp = Players.LocalPlayer

-- URL raw do GitHub usada diretamente no Auto Execute via queue_on_teleport
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
	BonecoLencoVermelho    = "rbxassetid://73534313721213",
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
	"COMUM", "RARO", "ÉPICO", "LENDÁRIO", "MÍTICO",
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
	["ÉPICO"] = {
		"piloto", "boxeador", "lenco preto", "lenco vermelho", "vermelho",
		"lenco fina", "fina", "bonecopiloto", "bonecoboxeador",
		"bonecolencopreto", "bonecolencovermelho",
		"bonecolencobranco", "bonecolencofina",
	},
	["LENDÁRIO"] = { "homem corvo", "bonecohomemcorvo" },
	["MÍTICO"] = { "craque 10", "craque", "bonecocraque" },
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
		return "ÉPICO"
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
	return "ÉPICO"
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

local skinList  = deduplicateById(catalog.skins  or { { id = "BonecoNoob",  name = "NOOB" } })
local colorList = deduplicateById(catalog.colors or { { id = "COLOR12", name = "Amarelo", value = Color3.fromRGB(250, 204, 21) } })
local trailList = deduplicateById(buildListFromItems(trailCatalog, {
	{ id = "Fumaca", name = "FUMAÇA", fx = "Fumaca" },
	{ id = "Agua", name = "PEGADAS D'ÁGUA", fx = "Agua" },
	{ id = "AreiaDourada", name = "AREIA DOURADA", fx = "AreiaDourada" },
}))
local punchList = deduplicateById(buildListFromItems(punchCatalog, {
	{ id = "Padrao", name = "SOCO PADRÃO", fx = "Padrao" },
	{ id = "Agua", name = "SOCO D'ÁGUA", fx = "Agua" },
}))

local state = {
	skinId = skinList[1] and skinList[1].id or "BonecoNoob",
	colorId = colorList[1] and colorList[1].id or "COLOR12",
	trailId = trailList[1] and trailList[1].id or "Fumaca",
	punchId = punchList[1] and punchList[1].id or "Padrao",
	rarityIdx = 1, tab = "skin", hideNames = false, autoExec = false, skinsRgb = false, minimized = false,
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
	}
	cachedSessionCfg = cfg
	if type(writefile) == "function" then
		pcall(writefile, CONFIG_FILE, table.concat({
			cfg.skinId,
			cfg.colorId,
			cfg.trailId,
			cfg.punchId,
			cfg.hideNames and "1" or "0",
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
		"task.wait(1)",
		"local ok, err = pcall(function()",
		"  loadstring(game:HttpGet(" .. qUrl .. ", true))()",
		"end)",
		"if not ok then",
		"  warn('[MYSTIC STORE] Auto Execute falhou: ' .. tostring(err))",
		"end",
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

local function applyCosmetics(charOverride)
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
		if char then
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
end

local function applySkinOnly(skinId)
	if type(skinId) ~= "string" or skinId == "" then return end
	state.skinId = skinId
	local colorId = state.colorId or "COLOR12"

	pcall(function()
		lp:SetAttribute("SGCharacterVisual", skinId)
	end)

	local char = lp.Character
	if char then
		pcall(function()
			char:SetAttribute("CharacterVisual", skinId)
		end)
		if type(appearance.Build) == "function" then
			pcall(appearance.Build, char, { skin = skinId, color = colorId })
		end
	end
end

-- ══ UI ══
local oldGui = CG:FindFirstChild("MysticStorePanelV3")
if oldGui then pcall(function() oldGui:Destroy() end) end
local legacyGui = CG:FindFirstChild("MysticPanelV3")
if legacyGui then pcall(function() legacyGui:Destroy() end) end

local gui = Instance.new("ScreenGui")
gui.Name = "MysticStorePanelV3"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() gui.Parent = CG end) then
	gui.Parent = lp:WaitForChild("PlayerGui")
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
main.Name = "Main"; main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H); main.Position = UDim2.new(0, 4, 0.14, 0)
main.BackgroundColor3 = T.bg; main.BorderSizePixel = 0; main.Active = true; main.Draggable = true; main.Parent = gui
corner(main, 11); stroke(main, Color3.fromRGB(50, 55, 90), 1)

local header = Instance.new("Frame")
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

local saveCfgBox = Instance.new("Frame")
saveCfgBox.Size = UDim2.new(1, 0, 0, 38); saveCfgBox.LayoutOrder = 3
saveCfgBox.BackgroundColor3 = T.card; saveCfgBox.BorderSizePixel = 0; saveCfgBox.Parent = miscFrame
corner(saveCfgBox, 8); stroke(saveCfgBox, Color3.fromRGB(60, 65, 100), 1)

textLabel(saveCfgBox, UDim2.new(1, -86, 1, 0), UDim2.new(0, 10, 0, 0), "SALVAR CONFIGURAÇÃO", Enum.Font.GothamBlack, 9, T.text)

local saveCfgBtn = Instance.new("TextButton")
saveCfgBtn.Size = UDim2.new(0, 64, 0, 22); saveCfgBtn.Position = UDim2.new(1, -72, 0.5, -11)
saveCfgBtn.BackgroundColor3 = T.accent; saveCfgBtn.BorderSizePixel = 0; saveCfgBtn.Text = "SALVAR"
saveCfgBtn.TextColor3 = T.text; saveCfgBtn.Font = Enum.Font.GothamBlack; saveCfgBtn.TextSize = 8; saveCfgBtn.Parent = saveCfgBox; corner(saveCfgBtn, 6)

local hideToggle = makeMiscToggleRow(4, "NOMES")

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

local function updatePreview()
	if state.tab == "misc" or state.minimized or not gui or not gui.Parent then
		return
	end
	task.defer(function()
		if state.tab == "misc" or state.minimized or not gui or not gui.Parent then
			return
		end
		pcall(function()
			local list = getListForTab(state.tab)
			local idKey = getSelectedIdKey(state.tab)
			local item = findItemById(list, state[idKey])
			if not item then return end

			local img, isSwatch, swatchColor = getThumbData(state.tab, item)
			if isSwatch then
				if previewImg and previewImg.Parent then previewImg.Visible = false end
				if previewSwatch and previewSwatch.Parent then
					previewSwatch.Visible = true
					previewSwatch.BackgroundColor3 = swatchColor or Color3.fromRGB(178, 114, 68)
				end
			else
				if previewSwatch and previewSwatch.Parent then previewSwatch.Visible = false end
				if previewImg and previewImg.Parent then
					previewImg.Visible = true
					previewImg.Image = img
					previewImg.ScaleType = Enum.ScaleType.Fit
				end
			end

			if previewName and previewName.Parent then
				previewName.Text = (state.tab == "color") and formatColorDisplayName(item) or tostring(item.name or item.id or "")
			end
			if previewRarityLbl and previewRarityLbl.Parent then
				previewRarityLbl.Text = (state.tab == "skin") and tostring(getRarityForSkin(item) or "") or string.upper(tostring(state.tab or ""))
			end

			for _, entry in ipairs(gridCards) do
				if entry.card and entry.card.Parent then
					local sel = (entry.itemId == item.id)
					entry.card.BackgroundColor3 = sel and T.cardSel or T.card
					local s = entry.card:FindFirstChildOfClass("UIStroke")
					if s then s.Enabled = sel end
				end
			end
		end)
	end)
end

local function refreshRarityButtons()
	if not gui or not gui.Parent then return end
	task.defer(function()
		if not gui or not gui.Parent then return end
		pcall(function()
			local selectedRarity = RARITIES[state.rarityIdx] or RARITIES[1]
			for _, rb in ipairs(rarityBtns) do
				if rb.btn and rb.btn.Parent then
					local isSel = (rb.rarity == selectedRarity)
					rb.btn.BackgroundColor3 = isSel and T.accent or T.card
					rb.btn.TextColor3 = isSel and T.text or T.muted
				end
			end
		end)
	end)
end

local function setSkinsRgbVisual(enabled)
	if not skinsRgbToggle or not skinsRgbToggle.Parent then return end
	task.defer(function()
		if not skinsRgbToggle or not skinsRgbToggle.Parent then return end
		pcall(function()
			skinsRgbToggle.Text = enabled and "ON" or "OFF"
			skinsRgbToggle.TextColor3 = enabled and T.text or T.muted
			skinsRgbToggle.BackgroundColor3 = enabled and T.accentD or T.btn
		end)
	end)
end

local rgbLoopGen = 0
local function isLencoSkin(item)
	if not item then return false end
	local combined = normalizeText(item.name) .. " " .. normalizeText(item.id)
	return string.find(combined, "lenco", 1, true) ~= nil
		or string.find(combined, "preto", 1, true) ~= nil
		or string.find(combined, "vermelho", 1, true) ~= nil
		or string.find(combined, "fina", 1, true) ~= nil
end

local function startSkinsRgbLoop()
	rgbLoopGen += 1
	local currentGen = rgbLoopGen
	task.spawn(function()
		local idx = 1
		while state.skinsRgb and currentGen == rgbLoopGen and gui and gui.Parent do
			local count = #skinList
			if count > 0 then
				if idx > count then idx = 1 end
				local item = skinList[idx]
				if item and item.id then
					if not lp.Character then
						lp.CharacterAdded:Wait()
						task.wait(0.35)
					end
					applySkinOnly(item.id)
					if state.tab == "skin" and not state.minimized then
						updatePreview()
					end
					task.wait(isLencoSkin(item) and 1.35 or 0.9)
				else
					task.wait(0.5)
				end
				idx += 1
			else
				task.wait(0.9)
			end
		end
	end)
end

local function setSkinsRgbEnabled(enabled)
	state.skinsRgb = enabled and true or false
	setSkinsRgbVisual(state.skinsRgb)
	if state.skinsRgb then
		startSkinsRgbLoop()
	else
		rgbLoopGen += 1
	end
end

local function buildGrid(tabId)
	if not gui or not gui.Parent then return end
	task.defer(function()
		if not gui or not gui.Parent then return end
		pcall(function()
			for _, entry in ipairs(gridCards) do
				if entry.card then pcall(function() entry.card:Destroy() end) end
			end
			gridCards = {}

			local isSkinTab = (tabId == "skin")
			local isMiscTab = (tabId == "misc")
			rarityBar.Visible = isSkinTab
			miscFrame.Visible = isMiscTab
			previewFrame.Visible = not isMiscTab
			gridClip.Visible = not isMiscTab
			if isMiscTab then return end

			gridClip.Position = isSkinTab and UDim2.new(0, 0, 0, 52) or UDim2.new(0, 0, 0, 28)
			gridClip.Size = isSkinTab and UDim2.new(1, -92, 1, -52) or UDim2.new(1, -92, 1, -28)

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
		if not gui or not gui.Parent then return end
		pcall(function()
			for _, tb in ipairs(tabBtns) do
				if tb.btn and tb.btn.Parent then
					tb.btn.BackgroundColor3 = (tb.id == tabId) and T.tabSel or T.tabBg
					tb.btn.TextColor3 = (tb.id == tabId) and T.text or T.muted
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

autoExecToggle.MouseButton1Click:Connect(function()
	state.autoExec = not state.autoExec
	autoExecToggle.Text = state.autoExec and "ON" or "OFF"
	autoExecToggle.TextColor3 = state.autoExec and T.text or T.muted
	autoExecToggle.BackgroundColor3 = state.autoExec and T.accentD or T.btn
	if state.autoExec then
		queueTeleportActions(true)
	else
		lastQueuedSignature = nil
	end
end)

skinsRgbToggle.MouseButton1Click:Connect(function()
	setSkinsRgbEnabled(not state.skinsRgb)
end)

saveCfgBtn.MouseButton1Click:Connect(function()
	saveConfigToFile()
	queueTeleportActions(true)
	saveCfgBtn.Text = "SALVO"
	saveCfgBtn.BackgroundColor3 = T.accentD
	task.delay(1.2, function()
		if saveCfgBtn and saveCfgBtn.Parent then
			saveCfgBtn.Text = "SALVAR"
			saveCfgBtn.BackgroundColor3 = T.accent
		end
	end)
end)

hideToggle.MouseButton1Click:Connect(function()
	state.hideNames = not state.hideNames
	hideToggle.Text = state.hideNames and "ON" or "OFF"
	hideToggle.TextColor3 = state.hideNames and T.text or T.muted
	hideToggle.BackgroundColor3 = state.hideNames and T.accentD or T.btn
	pcall(lp.SetAttribute, lp, "SGHideAllNames", state.hideNames)
end)

minBtn.MouseButton1Click:Connect(function()
	state.minimized = not state.minimized; body.Visible = not state.minimized
	main.Size = state.minimized and UDim2.new(0, PANEL_W, 0, 30) or UDim2.new(0, PANEL_W, 0, PANEL_H)
	minBtn.Text = state.minimized and "+" or "-"
end)

closeBtn.MouseButton1Click:Connect(function()
	state.skinsRgb = false
	rgbLoopGen += 1
	pcall(function() gui:Destroy() end)
end)

lp.CharacterAdded:Connect(function(char)
	task.wait(1)
	applyCosmetics(char)
end)

refreshRarityButtons()
switchTab("skin")

local savedCfg = loadSavedConfig()
if type(savedCfg) == "table" then
	if type(savedCfg.skinId) == "string" and savedCfg.skinId ~= "" then state.skinId = savedCfg.skinId end
	if type(savedCfg.colorId) == "string" and savedCfg.colorId ~= "" then state.colorId = savedCfg.colorId end
	if type(savedCfg.trailId) == "string" and savedCfg.trailId ~= "" then state.trailId = savedCfg.trailId end
	if type(savedCfg.punchId) == "string" and savedCfg.punchId ~= "" then state.punchId = savedCfg.punchId end
	if type(savedCfg.hideNames) == "boolean" then state.hideNames = savedCfg.hideNames end
	hideToggle.Text = state.hideNames and "ON" or "OFF"
	hideToggle.TextColor3 = state.hideNames and T.text or T.muted
	hideToggle.BackgroundColor3 = state.hideNames and T.accentD or T.btn
	applyCosmetics(lp.Character)
	updatePreview()
end
