-- ============================================================
-- PASTE DIRECT IMAGE URL HERE (must end with .png / .jpg / .jpeg)
-- ============================================================
local IMAGE_URL = "https://i.pinimg.com/originals/00/00/00/example.png"

-- Optional: fallback Roblox asset ID if download fails (digits only)
local FALLBACK_ROBLOX_ID = ""   -- e.g. "1234567890", or leave empty

-- ============================================================

local function dbg(m) pcall(function() print("[ssv] " .. tostring(m)) end) end
dbg("step 1: parsing")

-- Safe getgenv
local _0
do
    local ok, res = pcall(function()
        if type(getgenv) == "function" then return getgenv() end
        return nil
    end)
    _0 = (ok and res) or _G
end
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil
dbg("step 2: globals ready")

-- task/spawn/wait/delay fallbacks for old executors
local _task  = (type(task) == "table") and task or {}
local _spawn = _task.spawn or (type(spawn) == "function" and spawn) or function(f) coroutine.wrap(f)() end
local _wait  = _task.wait  or (type(wait)  == "function" and wait)  or function(t) return t or 0 end
local _delay = _task.delay or function(t, f) _spawn(function() _wait(t) f() end) end
dbg("step 3: task wrappers ready")

-- Decode SSV URLs
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

local _cf = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108,85,92,95,100,87,98,36,98,107,87}
local _uf = ""
for _, n in ipairs(_cf) do _uf = _uf .. string.char(n + 10) end
dbg("step 4: urls decoded")

-- REJOIN FIX
do
    local rs = 'loadstring(game:HttpGet("' .. _uf .. '"))()'
    local function w(q) return function(_) return q(rs) end end
    if type(queue_on_teleport) == "function" then _G.queue_on_teleport = w(queue_on_teleport) end
    if type(queueonteleport) == "function" then _G.queueonteleport = w(queueonteleport) end
    if syn and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport = w(syn.queue_on_teleport) end
end
dbg("step 5: rejoin patched")

-- ============================================================
-- DOWNLOAD IMAGE FROM URL -> CUSTOM ASSET
-- ============================================================
local CACHE_FILE = "ssv_moon_custom.png"
local assetToUse = nil

local function httpGetRaw(u)
    -- binary-safe: prefer table-style request APIs
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body and #r.Body > 0 then
            return r.Body
        end
    end
    if syn and type(syn.request) == "function" then
        local ok, r = pcall(syn.request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body and #r.Body > 0 then
            return r.Body
        end
    end
    if type(http_request) == "function" then
        local ok, r = pcall(http_request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body and #r.Body > 0 then
            return r.Body
        end
    end
    return nil
end

do
    local hasWrite = type(writefile) == "function"
    local hasRead  = type(readfile)  == "function"
    local hasIsFile = type(isfile)   == "function"
    local hasGetCustom = type(getcustomasset) == "function"

    dbg("executor: writefile=" .. tostring(hasWrite)
        .. " isfile=" .. tostring(hasIsFile)
        .. " getcustomasset=" .. tostring(hasGetCustom))

    if hasWrite and hasGetCustom then
        local haveCache = hasIsFile and isfile(CACHE_FILE)

        if not haveCache then
            dbg("downloading image from url...")
            local bytes = httpGetRaw(IMAGE_URL)
            if bytes and #bytes > 0 then
                local okw = pcall(writefile, CACHE_FILE, bytes)
                if okw then
                    dbg("downloaded and saved: " .. #bytes .. " bytes")
                else
                    dbg("writefile failed")
                end
            else
                dbg("download failed (no bytes returned)")
            end
        else
            dbg("using cached file: " .. CACHE_FILE)
        end

        if (not hasIsFile) or isfile(CACHE_FILE) then
            local okg, id = pcall(getcustomasset, CACHE_FILE)
            if okg and type(id) == "string" and #id > 0 then
                assetToUse = id
                dbg("asset ready: " .. id)
            else
                dbg("getcustomasset failed")
            end
        end
    else
        dbg("executor missing writefile/getcustomasset")
    end

    -- Fallback to Roblox asset ID if user provided one
    if not assetToUse and FALLBACK_ROBLOX_ID and FALLBACK_ROBLOX_ID ~= "" then
        assetToUse = "rbxassetid://" .. FALLBACK_ROBLOX_ID
        dbg("using fallback Roblox asset: " .. assetToUse)
    end

    if not assetToUse then
        -- if we cannot get any image, keep original moon (do not break)
        dbg("WARNING: no image asset available, keeping original moon")
        assetToUse = nil
    end
end

-- Determine numeric replacement for src (safe literal)
local numericReplacement = "0"
if assetToUse then
    local n = assetToUse:match("rbxassetid://(%d+)")
    if n then
        numericReplacement = n
    else
        -- custom asset: use 0 in source, real asset applied in post-process
        numericReplacement = "0"
    end
end
dbg("step 6: numeric replacement = " .. numericReplacement)

-- ============================================================
-- DOWNLOAD SSV SOURCE
-- ============================================================
local function httpGetText(u)
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body then return r.Body end
    end
    if syn and type(syn.request) == "function" then
        local ok, r = pcall(syn.request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body then return r.Body end
    end
    if type(http_request) == "function" then
        local ok, r = pcall(http_request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body then return r.Body end
    end
    if type(HttpGet) == "function" then
        local ok, r = pcall(HttpGet, u); if ok and type(r) == "string" then return r end
    end
    if type(HttpGetAsync) == "function" then
        local ok, r = pcall(HttpGetAsync, u); if ok and type(r) == "string" then return r end
    end
    local ok, r = pcall(function() return game:HttpGet(u) end)
    if ok and type(r) == "string" then return r end
    return nil
end

dbg("step 7: downloading ssv source...")
local src = httpGetText(_u)
if type(src) ~= "string" or #src < 100000 then
    dbg("ssv download failed, size=" .. tostring(#(src or "")))
    error("[ssv] could not download source", 0)
end
dbg("step 8: ssv source = " .. #src .. " bytes")

-- kill intro
do
    local s1 = src:find('function Intro.Play', 1, true)
    if s1 then
        local e1 = src:find('return Intro', s1, true)
        if e1 then
            src = src:sub(1, s1 - 1) .. 'function Intro.Play() return true end\n' .. src:sub(e1)
        end
    end
end

local function R(p, r)
    local ok, n = pcall(function() return src:gsub(p, r) end)
    if ok and type(n) == "string" then src = n end
end

-- Replace moon asset id in source
src = src:gsub("79685990879972", numericReplacement)
dbg("step 9: moon id -> " .. numericReplacement)

-- Strip moon text labels
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R("'Moon'", "''")

-- Moon emoji bytes
R('\240\159\140\145', '')
R('\240\159\140\146', '')
R('\240\159\140\147', '')
R('\240\159\140\148', '')
R('\240\159\140\149', '')
R('\240\159\140\150', '')
R('\240\159\140\151', '')
R('\240\159\140\152', '')
R('\240\159\140\153', '')
R('\240\159\140\154', '')
R('\240\159\140\155', '')
R('\240\159\140\156', '')
R('\240\159\140\157', '')
R('\240\159\140\158', '')

-- Window background = custom asset
if assetToUse then
    R('BackgroundImage = "[^"]*"', 'BackgroundImage = "' .. assetToUse .. '"')
    R("BackgroundImage = '[^']*'", "BackgroundImage = '" .. assetToUse .. "'")
    R('BackgroundImage = ""',      'BackgroundImage = "' .. assetToUse .. '"')
end

-- collapse duplicated names
local function collapse(text, word)
    local iter = 0
    while iter < 20 do
        iter = iter + 1
        local ok, new = pcall(function()
            return text:gsub(word .. "[%s%p]+" .. word, word)
        end)
        if ok and type(new) == "string" and new ~= text then
            text = new
        else
            break
        end
    end
    local ok2, new2 = pcall(function() return text:gsub(word .. word, word) end)
    if ok2 and type(new2) == "string" then text = new2 end
    return text
end

src = collapse(src, "qmee2")
src = collapse(src, "ssv")
R('created by qmee2 and qmee2', 'created by qmee2')
R('by qmee2 and qmee2', 'by qmee2')
R('ssv ssv', 'ssv')

-- dark theme
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(10, 8, 5)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(10, 8, 5)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(60, 35, 15)')
R('OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(60, 35, 15)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 220, 180)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(255, 220, 180)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')

R('<b>Auto%-Clicker</b>', '<b>poses</b>')
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

R('cracked by InLoad and wraith%.dev', 'created by qmee2')
R('cracked by [^"]+', 'created by qmee2')
R('cracked by [^"<]+', 'created by qmee2')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('or "Resonance"', 'or "ssv"')
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b>ssv</b>", "", "ssv")')
R('"v2%.9"', '""')

local pr = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(pr) do
    local k = "__S"..i.."__"
    src = src:gsub(nm, k)
    rs[k] = nm
end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
src = src:gsub("Project ssv", "ssv")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('CRACK', 'SSV')
src = collapse(src, "qmee2")
src = collapse(src, "ssv")
dbg("step 10: patches applied")

-- RUN
local chunk, cerr = loadstring(src)
if not chunk then
    dbg("compile error: " .. tostring(cerr))
    error("[ssv] compile: " .. tostring(cerr), 0)
end
dbg("step 11: compiled, running...")
local rok, rerr = pcall(chunk)
if not rok then
    dbg("run error: " .. tostring(rerr))
    error("[ssv] run: " .. tostring(rerr), 0)
end
dbg("step 12: ssv running")

-- ============================================================
-- POST-PROCESS UI: apply custom asset everywhere
-- ============================================================
if not assetToUse then
    dbg("no custom asset, skipping UI post-process")
    return
end

local function getAllObs()
    local list = {}
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if not ok or not cg then return list end
    for _, d in ipairs(cg:GetDescendants()) do
        if d.Name == "
