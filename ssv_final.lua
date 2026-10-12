-- ssv | created by qmee2  [patched: xoco kicks removed | new moon everywhere]
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══════════════════════════════════════════════════════════════
--  NEW MOON ASSET — вставь сюда свой Asset ID (только цифры)
-- ═══════════════════════════════════════════════════════════════
local NEW_MOON_ASSET = "rbxassetid://1234567890"   -- ← ЗАМЕНИ НА СВОЙ ID

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

-- ═══ ЗАГРУЖАЕМ КАРТИНКУ (замену луны) ═══
local BLACKHOLE_ASSET = NEW_MOON_ASSET   -- везде теперь используем новую картинку

do
    -- Пробуем локальный файл (если положишь картинку рядом с executor'ом)
    local names = {"blackhole.png", "blackhole.jpg", "blackhole.jpeg", "black hole.png", "bg.png", "moon.png"}
    for _, n in ipairs(names) do
        if type(isfile) == "function" and isfile(n) and type(getcustomasset) == "function" then
            local ok, id = pcall(getcustomasset, n)
            if ok and id then
                BLACKHOLE_ASSET = id
                print("[ssv] ✓ Локальная картинка: " .. n .. " → " .. tostring(id))
                break
            end
        end
    end
    if BLACKHOLE_ASSET == NEW_MOON_ASSET then
        print("[ssv] Используется Roblox Asset: " .. NEW_MOON_ASSET)
    end
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
--  1. УБИРАЕМ СТАРУЮ ЛУНУ — СТАВИМ НОВУЮ КАРТИНКУ ВЕЗДЕ
-- ═══════════════════════════════════════════════════════════════
R('79685990879972', NEW_MOON_ASSET)
R('rbxassetid://79685990879972', NEW_MOON_ASSET)

-- Оставляем чистку текстовых "moon", но НЕ трогаем сам asset
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R("'Moon'", "''")

-- Все эмодзи луны на всякий случай убираем
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
--  2. ФОН ОКНА = НОВАЯ КАРТИНКА
-- ═══════════════════════════════════════════════════════════════
R('BackgroundImage = "[^"]*"', 'BackgroundImage = "' .. BLACKHOLE_ASSET .. '"')
R("BackgroundImage = '[^']*'", "BackgroundImage = '" .. BLACKHOLE_ASSET .. "'")
R('BackgroundImage = ""', 'BackgroundImage = "' .. BLACKHOLE_ASSET .. '"')

-- ═══════════════════════════════════════════════════════════════
--  3. ПОВТОРЫ qmee2 / ssv
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
R('created by qmee2 and qmee2', 'created by qmee2')
R('by qmee2 and qmee2', 'by qmee2')
R('ssv ssv', 'ssv')

-- ═══════════════════════════════════════════════════════════════
--  4. ТЁМНАЯ ТЕМА ПОД НОВУЮ КАРТИНКУ
-- ═══════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════
--  ⚠️ XOCO-КИКИ УДАЛЕНЫ — здесь ничего не инжектится
-- ═══════════════════════════════════════════════════════════════

-- ═══ ЗАПУСК ═══
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  5. ПОСТ-ОБРАБОТКА UI
--     Убираем старую луну + ставим новую картинку ВЕЗДЕ
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
        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
            local img = tostring(d.Image or "")
            local low = img:lower()
            local full = d:GetFullName():lower()
            local sz = d.AbsoluteSize

            -- СТАРАЯ ЛУНА: asset 79685* / moon / luna
            local is_old_moon = false
            if img:find("79685", 1, true) then is_old_moon = true end
            if low:find("moon", 1, true) then is_old_moon = true end
            if low:find("luna", 1, true) then is_old_moon = true end
            if full:find("moon", 1, true) then is_old_moon = true end

            if is_old_moon then
                -- Ставим НОВУЮ картинку вместо старой луны
                d.Image = BLACKHOLE_ASSET
                d.ImageTransparency = 0
                d.Visible = true
                d.BackgroundTransparency = 1
            end

            -- Большой фон — тоже заменяем на новую картинку
            if sz.X > 1000 or sz.Y > 500 then
                d.Image = BLACKHOLE_ASSET
                d.ImageTransparency = 0.35
                d.Visible = true
                d.ScaleType = Enum.ScaleType.Crop
                d.BackgroundTransparency = 1
            end
        end

        -- Чистим текстовые повторы
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

    -- Фон главного окна = новая картинка
    for _, c in ipairs(obs:GetChildren()) do
        if c:IsA("ImageLabel") then
            c.Image = BLACKHOLE_ASSET
            c.ImageTransparency = 0.4
            c.Visible = true
            c.ScaleType = Enum.ScaleType.Crop
        end
    end
end

-- Многократная зачистка (UI строится поэтапно)
for _, delay in ipairs({2, 4, 6, 8, 12, 16, 22, 30}) do
    task.delay(delay, function()
        pcall(function()
            for _, obs in ipairs(getAllObs()) do
                cleanObs(obs)
            end
        end)
    end)
end

-- Следим за новыми Obsidian и новыми картинками
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

-- Переименование звуков в resonance
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

-- ═══════════════════════════════════════════════════════════════
--  ПОСТ-ОБРАБОТКА UI — вторая волна (добиваем остатки)
-- ═══════════════════════════════════════════════════════════════
local BH_ASSET = BLACKHOLE_ASSET

local function clean()
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, obs in ipairs(cg:GetDescendants()) do
            if obs.Name == "Obsidian" and (obs:IsA("ScreenGui") or obs:IsA("Folder")) then
                for _, d in ipairs(obs:GetDescendants()) do
                    if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        local img = tostring(d.Image or "")
                        local full = d:GetFullName()
                        local sz = d.AbsoluteSize

                        -- Пустая / старая луна / 79685 — ставим новую
                        if (img == "" or img == "rbxassetid://0" or img:find("79685", 1, true)
                            or img:lower():find("moon") or img:lower():find("luna")) then
                            d.Image = BH_ASSET
                            d.ImageTransparency = 0
                            d.Visible = true
                        end

                        if full:find("Obsidian.Frame.TextLabel.ImageLabel", 1, true)
                           or full:find("Obsidian.Main.Frame.Frame.ImageLabel", 1, true) then
                            d.Image = BH_ASSET
                            d.ImageTransparency = 0
                            d.Visible = true
                        end

                        -- Большой фон
                        if sz.X > 1000 or sz.Y > 500 then
                            d.Image = BH_ASSET
                            d.ImageTransparency = 0.4
                            d.ScaleType = Enum.ScaleType.Crop
                            d.Visible = true
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
            end
        end
    end)
end

for _, delay in ipairs({2, 4, 6, 8, 12, 16, 22, 30}) do
    task.delay(delay, clean)
end

task.spawn(function()
    task.wait(3)
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, obs in ipairs(cg:GetDescendants()) do
            if obs.Name == "Obsidian" and (obs:IsA("ScreenGui") or obs:IsA("Folder")) then
                obs.DescendantAdded:Connect(function(d)
                    if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        task.wait(0.1)
                        pcall(function()
                            local img = tostring(d.Image or "")
                            local sz = d.AbsoluteSize
                            if (img == "" or img == "rbxassetid://0" or img:find("79685", 1, true)
                                or img:lower():find("moon") or img:lower():find("luna")) then
                                d.Image = BH_ASSET
                                d.ImageTransparency = 0
                                d.Visible = true
                            end
                            if sz.X > 1000 or sz.Y > 500 then
                                d.Image = BH_ASSET
                                d.ImageTransparency = 0.4
                                d.ScaleType = Enum.ScaleType.Crop
                                d.Visible = true
                            end
                        end)
                    end
                end)
            end
        end
    end)
end)
