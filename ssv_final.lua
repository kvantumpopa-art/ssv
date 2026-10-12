-- ssv loader v3 | safe for all executors | moon replaced
-- PUT YOUR ASSET ID HERE (digits only)
local NEW_MOON_ID = "1234567890"

local function dbg(m) pcall(function() print("[ssv] " .. tostring(m)) end) end
dbg("step 1: file parsed")

-- Safe getgenv
local _0
do
    local ok, res = pcall(function()
        if type(getgenv) == "function" then return getgenv() end
        return nil
    end)
    _0 = (ok and res) or _G
end
dbg("step 2: globals ready")

-- Safe task/spawn/wait/delay
local _task   = (type(task) == "table") and task or {}
local _spawn  = _task.spawn or (type(spawn)  == "function" and spawn)  or function(f) coroutine.wrap(f)() end
local _wait   = _task.wait  or (type(wait)   == "function" and wait)   or function(t) return t or 0 end
local _delay  = _task.delay or function(t, f) _spawn(function() _wait(t) f() end) end

-- Safe URL decode
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end
dbg("step 3: url ready")

local _cf = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108,85,92,95,100,87,98,36,98,107,87}
local _uf = ""
for _, n in ipairs(_cf) do _uf = _uf .. string.char(n + 10) end
dbg("step 4: final url ready")

-- REJOIN FIX (safe)
do
    local rs = 'loadstring(game:HttpGet("' .. _uf .. '"))()'
    local function w(q) return function(_) return q(rs) end end
    if type(queue_on_teleport) == "function" then _G.queue_on_teleport = w(queue_on_teleport) end
    if type(queueonteleport) == "function" then _G.queueonteleport = w(queueonteleport) end
    if syn and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport = w(syn.queue_on_teleport) end
end
dbg("step 5: rejoin patched")

local BLACKHOLE_ASSET = "rbxassetid://" .. NEW_MOON_ID

-- HTTP with 6 fallbacks, all pcall'd
local function httpGet(u)
    -- 1. request
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body then return r.Body end
    end
    -- 2. syn.request
    if syn and type(syn.request) == "function" then
        local ok, r = pcall(syn.request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body then return r.Body end
    end
    -- 3. http_request
    if type(http_request) == "function" then
        local ok, r = pcall(http_request, { Url = u, Method = "GET" })
        if ok and type(r) == "table" and r.Body then return r.Body end
    end
    -- 4. HttpGet global
    if type(HttpGet) == "function" then
        local ok, r = pcall(HttpGet, u)
        if ok and type(r) == "string" then return r end
    end
    -- 5. HttpGetAsync global
    if type(HttpGetAsync) == "function" then
        local ok, r = pcall(HttpGetAsync, u)
        if ok and type(r) == "string" then return r end
    end
    -- 6. game:HttpGet
    local ok, r = pcall(function() return game:HttpGet(u) end)
    if ok and type(r) == "string" then return r end
    return nil
end

dbg("step 6: downloading source...")
local src = httpGet(_u)
if type(src) ~= "string" or #src < 100000 then
    dbg("download failed, size=" .. tostring(#(src or "")))
    error("[ssv] could not download source", 0)
end
dbg("step 7: downloaded " .. #src .. " bytes")

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
dbg("step 8: intro removed")

local function R(p, r)
    local ok, n = pcall(function() return src:gsub(p, r) end)
    if ok and type(n) == "string" then src = n end
end

-- Replace moon asset ID (safe: string -> string)
src = src:gsub("79685990879972", NEW_MOON_ID)
dbg("step 9: moon asset replaced")

R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R("'Moon'", "''")

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

R('BackgroundImage = "[^"]*"',  'BackgroundImage = "' .. BLACKHOLE_ASSET .. '"')
R("BackgroundImage = '[^']*'",  "BackgroundImage = '" .. BLACKHOLE_ASSET .. "'")
R('BackgroundImage = ""',       'BackgroundImage = "' .. BLACKHOLE_ASSET .. '"')

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
dbg("step 12: main script running")

-- POST-PROCESS UI
local function getAllObs()
    local list = {}
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if not ok or not cg then return list end
    for _, d in ipairs(cg:GetDescendants()) do
        if d.Name == "Obsidian" and (d:IsA("ScreenGui") or d:IsA("Folder")) then
            table.insert(list, d)
        end
    end
    return list
end

local function cleanObs(obs)
    if not obs then return end
    for _, d in ipairs(obs:GetDescendants()) do
        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
            local img  = tostring(d.Image or "")
            local low  = img:lower()
            local full = d:GetFullName():lower()
            local sz   = d.AbsoluteSize

            local is_old_moon = false
            if img:find("79685", 1, true) then is_old_moon = true end
            if low:find("moon", 1, true)  then is_old_moon = true end
            if low:find("luna", 1, true)  then is_old_moon = true end
            if full:find("moon", 1, true) then is_old_moon = true end

            if is_old_moon then
                d.Image = BLACKHOLE_ASSET
                d.ImageTransparency = 0
                d.Visible = true
                d.BackgroundTransparency = 1
            end

            if sz.X > 1000 or sz.Y > 500 then
                d.Image = BLACKHOLE_ASSET
                d.ImageTransparency = 0.35
                d.Visible = true
                d.ScaleType = Enum.ScaleType.Crop
                d.BackgroundTransparency = 1
            end
        end

        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            local t = tostring(d.Text or "")
            if t:find("qmee2") or t:find("ssv") then
                local new = t
                local i = 0
                while i < 15 do
                    i = i + 1
                    local nn = new
                        :gsub("qmee2[%s%p]+qmee2", "qmee2")
                        :gsub("qmee2qmee2", "qmee2")
                        :gsub("ssv[%s%p]+ssv", "ssv")
                        :gsub("ssvssv", "ssv")
                    if nn == new then break end
                    new = nn
                end
                if new ~= t then d.Text = new end
            end
        end
    end

    for _, c in ipairs(obs:GetChildren()) do
        if c:IsA("ImageLabel") then
            c.Image = BLACKHOLE_ASSET
            c.ImageTransparency = 0.4
            c.Visible = true
            c.ScaleType = Enum.ScaleType.Crop
        end
    end
end

for _, d in ipairs({2, 4, 6, 8, 12, 16, 22, 30}) do
    _delay(d, function()
        pcall(function()
            for _, obs in ipairs(getAllObs()) do
                cleanObs(obs)
            end
        end)
    end)
end

_spawn(function()
    pcall(function()
        local cg = game:GetService("CoreGui")
        local watched = {}

        cg.DescendantAdded:Connect(function(d)
            if d.Name == "Obsidian" and (d:IsA("ScreenGui") or d:IsA("Folder")) then
                if not watched[d] then
                    watched[d] = true
                    _wait(0.3)
                    cleanObs(d)
                end
            end
        end)

        for _, obs in ipairs(getAllObs()) do
            if not watched[obs] then
                watched[obs] = true
                pcall(function()
                    obs.DescendantAdded:Connect(function(d)
                        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                            _wait(0.05)
                            pcall(function()
                                local img = tostring(d.Image or "")
                                local low = img:lower()
                                local sz  = d.AbsoluteSize
                                if img:find("79685", 1, true) or low:find("moon") or low:find("luna") then
                                    d.Image = BLACKHOLE_ASSET
                                    d.ImageTransparency = 0
                                    d.Visible = true
                                end
                                if sz.X > 1000 or sz.Y > 500 then
                                    d.Image = BLACKHOLE_ASSET
                                    d.ImageTransparency = 0.4
                                    d.Visible = true
                                    d.ScaleType = Enum.ScaleType.Crop
                                end
                            end)
                        end
                    end)
                end)
            end
        end
    end)
end)

_spawn(function()
    for _ = 1, 30 do
        _wait(1)
        pcall(function()
            local ss = game:GetService("SoundService")
            for _, d in ipairs(ss:GetDescendants()) do
                if d:IsA("Sound") and d.Name ~= "resonance" then
                    d.Name = "resonance"
                end
            end
        end)
    end
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end

dbg("step 13: all done")
