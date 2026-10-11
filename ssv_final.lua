-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ URL ssv ═══
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

-- ═══ URL ssv_final.lua ═══
local _cf = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108,85,92,95,100,87,98,36,98,107,87}
local _uf = ""
for _, n in ipairs(_cf) do _uf = _uf .. string.char(n + 10) end

-- ═══ REJOIN FIX ═══
do
    local _rs = 'loadstring(game:HttpGet("' .. _uf .. '"))()'
    local function _w(q) return function(_) return q(_rs) end end
    if type(queue_on_teleport) == "function" then _G.queue_on_teleport = _w(queue_on_teleport) end
    if type(queueonteleport) == "function" then _G.queueonteleport = _w(queueonteleport) end
    if syn and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport = _w(syn.queue_on_teleport) end
end

-- ═══ ЗАГРУЗКА ═══
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
    local ok, n = pcall(function() return src:gsub(p, r) end)
    if ok and type(n) == "string" then src = n end
end

-- ═══════════════════════════════════════════════════════════════
--  1. УДАЛЯЕМ ВСЕ ЛУНЫ ИЗ КОДА
-- ═══════════════════════════════════════════════════════════════
-- Roblox asset луны
R('79685990879972', '0')
R('rbxassetid://79685990879972', 'rbxassetid://0')

-- Lucide имена луны → пусто (пустая иконка, не крашит)
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R("'Moon'", "''")

-- BackgroundImage с луной → пусто
R('BackgroundImage = "[^"]*[Mm]oon[^"]*"', 'BackgroundImage = ""')
R("BackgroundImage = '[^']*[Mm]oon[^']*'", "BackgroundImage = ''")

-- Все эмодзи луны (через байты)
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

-- ═══════════════════════════════════════════════════════════════
--  2. УДАЛЯЕМ ПОВТОРЯЮЩИЕСЯ qmee2 / ssv (в коде)
-- ═══════════════════════════════════════════════════════════════
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

-- Явные случаи
R('created by qmee2 and qmee2', 'created by qmee2')
R('by qmee2 and qmee2', 'by qmee2')
R('created by qmee2 qmee2', 'created by qmee2')
R('ssv and ssv', 'ssv')
R('ssv ssv', 'ssv')

-- ═══════════════════════════════════════════════════════════════
--  3. СИНЯЯ ТЕМА (потом заменишь на свою)
-- ═══════════════════════════════════════════════════════════════
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('MainColor = Color3%.fromRGB%(30, 30, 30%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 130, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 105, 180%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('AccentColor = Color3%.fromRGB%(255, 255, 0%)', 'AccentColor = Color3.fromRGB(255, 140, 30)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(50, 35, 25)')
R('OutlineColor = Color3%.fromRGB%(70, 70, 70%)', 'OutlineColor = Color3.fromRGB(50, 35, 25)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(255, 220, 180)')
R('FontColor = Color3%.fromRGB%(120, 40, 90%)', 'FontColor = Color3.fromRGB(255, 220, 180)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(255, 100, 60)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(255, 80, 40)')
R('"0f0f0f"', '"04060c"')
R('"191919"', '"0c101c"')
R('"7d55ff"', '"ff8c1e"')
R('"282828"', '"32231a"')
R('"ff69b4"', '"ff8c1e"')
R('"78285a"', '"ffdcb4"')

-- Auto-Clicker → poses
R('<b>Auto%-Clicker</b>', '<b>poses</b>')

-- Звук + Name = "resonance"
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

-- Авторы
R('cracked by InLoad and wraith%.dev', 'created by qmee2')
R('cracked by [^"]+', 'created by qmee2')
R('cracked by [^"<]+', 'created by qmee2')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('or "Resonance"', 'or "ssv"')
-- Home — без иконки, чисто "ssv"
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b>ssv</b>", "", "ssv")')
R('"v2%.9"', '""')

-- Resonance → ssv (защита служебных)
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

-- Финальная зачистка повторов
src = collapse(src, "qmee2")
src = collapse(src, "ssv")

-- ═══════════════════════════════════════════════════════════════
--  4. ЗАПУСК
-- ═══════════════════════════════════════════════════════════════
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  5. ПОСТ-ОБРАБОТКА: чистим UI — ищем Obsidian ВЕЗДЕ
--  Удаляем:
--   - луну по asset 79685990879972
--   - все ImageLabel с "moon"/"luna" в имени
--   - большой фон (>1000×500)
--   - повторы qmee2/ssv в текстах
-- ═══════════════════════════════════════════════════════════════

local function getAllObs()
    local list = {}
    local cg = game:GetService("CoreGui")
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
        -- Картинки
        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
            local img = tostring(d.Image or "")
            local low = img:lower()
            local full = d:GetFullName():lower()
            local sz = d.AbsoluteSize

            -- Луна: asset 79685* / moon в asset / moon/luna в пути
            local is_moon = false
            if img:find("79685", 1, true) then is_moon = true end
            if low:find("moon", 1, true) then is_moon = true end
            if low:find("luna", 1, true) then is_moon = true end
            if full:find("moon", 1, true) then is_moon = true end
            if full:find("luna", 1, true) then is_moon = true end

            if is_moon then
                d.Image = ""
                d.ImageTransparency = 1
                d.Visible = false
                d.BackgroundTransparency = 1
            end

            -- Большой фон (>1000×500)
            if sz.X > 1000 or sz.Y > 500 then
                d.Image = ""
                d.ImageTransparency = 1
                d.Visible = false
                d.BackgroundTransparency = 1
            end
        end

        -- Тексты — убираем повторы
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

    -- Фон главного окна (прямой ребёнок Obsidian)
    for _, c in ipairs(obs:GetChildren()) do
        if c:IsA("ImageLabel") then
            c.Image = ""
            c.ImageTransparency = 1
            c.Visible = false
            c.BackgroundTransparency = 1
        end
    end
end

-- Запускаем зачистку несколько раз — UI строится поэтапно
for _, delay in ipairs({2, 4, 6, 8, 12, 16, 22, 30}) do
    task.delay(delay, function()
        pcall(function()
            for _, obs in ipairs(getAllObs()) do
                cleanObs(obs)
            end
        end)
    end)
end

-- Слушаем новые Obsidian и новые картинки внутри них
task.spawn(function()
    pcall(function()
        local cg = game:GetService("CoreGui")
        local watched = {}

        cg.DescendantAdded:Connect(function(d)
            if d.Name == "Obsidian" and (d:IsA("ScreenGui") or d:IsA("Folder")) then
                if not watched[d] then
                    watched[d] = true
                    task.wait(0.3)
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
                            task.wait(0.05)
                            pcall(function()
                                local img = tostring(d.Image or "")
                                local low = img:lower()
                                local sz = d.AbsoluteSize
                                if img:find("79685", 1, true) or low:find("moon") or low:find("luna") then
                                    d.Image = ""
                                    d.ImageTransparency = 1
                                    d.Visible = false
                                end
                                if sz.X > 1000 or sz.Y > 500 then
                                    d.Image = ""
                                    d.ImageTransparency = 1
                                    d.Visible = false
                                    d.BackgroundTransparency = 1
                                end
                            end)
                        end
                    end)
                end)
            end
        end
    end)
end)

-- Звук — переименовываем в SoundService
task.spawn(function()
    for _ = 1, 30 do
        task.wait(1)
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
