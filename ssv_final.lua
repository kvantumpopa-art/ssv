-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

local _cf = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108,85,92,95,100,87,98,36,98,107,87}
local _uf = ""
for _, n in ipairs(_cf) do _uf = _uf .. string.char(n + 10) end

do
    local _rs = 'loadstring(game:HttpGet("' .. _uf .. '"))()'
    local function _w(q) return function(_) return q(_rs) end end
    if type(queue_on_teleport) == "function" then _G.queue_on_teleport = _w(queue_on_teleport) end
    if type(queueonteleport) == "function" then _G.queueonteleport = _w(queueonteleport) end
    if syn and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport = _w(syn.queue_on_teleport) end
end

local function _g(u)
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and r and r.Body then return r.Body end
    end
    local ok, r = pcall(game.HttpGet, game, u, true)
    if ok and type(r) == "string" then return r end
end

local src = _g(_u)
if type(src) ~= "string" or #src < 100000 then error("[ssv] fail") end

-- Убираем интро
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
    local ok, new = pcall(function() return src:gsub(p, r) end)
    if ok and type(new) == "string" then src = new end
end

-- ═══════════════════════════════════════════════════════════════
--  УБИРАЕМ ЛУНУ АБСОЛЮТНО ВЕЗДЕ
-- ═══════════════════════════════════════════════════════════════

-- 1. Roblox asset луны → 0 (пусто)
R('79685990879972', '0')
R('rbxassetid://79685990879972', 'rbxassetid://0')

-- 2. ВСЕ упоминания "moon" в ЛЮБОМ регистре → пусто
local ok1, new1 = pcall(function()
    return src:gsub('[Mm][Oo][Oo][Nn]%-?[Ss][Tt][Aa][Rr]?', '')
end)
if ok1 and type(new1) == "string" then src = new1 end

-- Ещё раз для "Moon", "MOON", оставшихся
R('[Mm][Oo][Oo][Nn]', '')
R('Luna', '')
R('luna', '')
R('LUNA', '')

-- 3. Фон: любой BackgroundImage с чем угодно → пусто
local ok_bg, new_bg = pcall(function()
    return src:gsub('BackgroundImage%s*=%s*"[^"]*"', 'BackgroundImage = ""')
end)
if ok_bg and type(new_bg) == "string" then src = new_bg end

local ok_bg2, new_bg2 = pcall(function()
    return src:gsub("BackgroundImage%s*=%s*'[^']*'", "BackgroundImage = ''")
end)
if ok_bg2 and type(new_bg2) == "string" then src = new_bg2 end

-- 4. Эмодзи луны (через байты UTF-8)
R('\240\159\140\153', '')
R('\240\159\140\154', '')
R('\240\159\140\155', '')
R('\240\159\140\156', '')
R('\240\159\140\146', '')
R('\240\159\140\147', '')
R('\240\159\140\148', '')
R('\240\159\140\149', '')
R('\240\159\140\150', '')
R('\240\159\140\151', '')
R('\240\159\140\152', '')
R('\240\159\140\145', '')

-- ═══════════════════════════════════════════════════════════════
--  УБИРАЕМ ДУБЛИ
-- ═══════════════════════════════════════════════════════════════
R('qmee2%s+qmee2', 'qmee2')
R('qmee2qmee2', 'qmee2')
R('qmee2•qmee2', 'qmee2')
R('qmee2%.qmee2', 'qmee2')
R('qmee2%-qmee2', 'qmee2')
R('qmee2_qmee2', 'qmee2')
R('qmee2/qmee2', 'qmee2')
R('created by qmee2 and qmee2', 'created by qmee2')
R('by qmee2 and qmee2', 'by qmee2')

local ok_ssv, new_ssv = pcall(function()
    return src:gsub('ssv([%s•%.%-/_]+)ssv', 'ssv')
end)
if ok_ssv and type(new_ssv) == "string" then src = new_ssv end
R('ssvssv', 'ssv')

-- ═══════════════════════════════════════════════════════════════
--  ТЕМА: чёрный фон + оранжевый + белый
-- ═══════════════════════════════════════════════════════════════
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(100, 170, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(255, 255, 255)')
R('FontColor = Color3%.fromRGB%(140, 80, 100%)', 'FontColor = Color3.fromRGB(255, 255, 255)')

-- Auto-Clicker → poses
R('<b>Auto%-Clicker</b>', '<b>poses</b>')

-- Звук
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

-- Авторы
R('cracked by InLoad and wraith%.dev', 'created by qmee2')
R('cracked by [^"]+', 'created by qmee2')
R('cracked by [^"<]+', 'created by qmee2')
R('dont stop using cracks! ts crack is so cool', 'created by qmee2')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('or "Resonance"', 'or "ssv"')
R('"v2%.9"', '""')

-- Resonance → ssv (защита)
local pr = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(pr) do
    local k = "__S"..i.."__"
    src = src:gsub(nm, k)
    rs[k] = nm
end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

R('cracked', 'created')
R('crack', 'ssv')

-- Финальная зачистка дублей
R('qmee2%s+qmee2', 'qmee2')
R('ssv%s+ssv', 'ssv')
R('qmee2qmee2', 'qmee2')
R('ssvssv', 'ssv')

-- ЗАПУСК
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  ПОСТ-ОБРАБОТКА — жёсткая зачистка луны в UI
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(6)
    pcall(function()
        local cg = game:GetService("CoreGui")
        local obsidian = cg:FindFirstChild("Obsidian")
        if not obsidian then return end

        for _, d in ipairs(obsidian:GetDescendants()) do
            -- ImageLabel / ImageButton с asset луны
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                local img = tostring(d.Image or "")
                if img:find("79685", 1, true) or img:find("moon", 1, true) or img:find("Moon", 1, true) then
                    d.Image = ""
                    d.Visible = false
                    d.BackgroundTransparency = 1
                end
            end
            -- Текст с эмодзи луны
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = tostring(d.Text or "")
                if t:find("\240\159\140\153") or t:find("\240\159\140\145") then
                    d.Text = ""
                end
            end
            -- Большие декоративные фоны (если это фон главного окна с moon)
            if d:IsA("ImageLabel") and d.Name:lower():find("bg") then
                if d.Size.X.Scale >= 0.9 and d.Size.Y.Scale >= 0.9 then
                    d.Image = ""
                    d.Visible = false
                end
            end
        end
    end)
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
