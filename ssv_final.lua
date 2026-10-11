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

-- ═══════════════════════════════════════════════════════════════
--  ХУК на Instance.new("Sound") — переименовываем при создании
-- ═══════════════════════════════════════════════════════════════
local SoundCount = 0
local _newInstance = Instance.new
local _hookedNew = function(class, parent)
    local inst = _newInstance(class, parent)
    if class == "Sound" then
        SoundCount = SoundCount + 1
        task.defer(function()
            pcall(function()
                if inst and inst.Parent then
                    inst.Name = "resonance"
                end
            end)
        end)
    end
    return inst
end

-- Ставим хук если поддерживается
local hookOk = false
if type(hookfunction) == "function" then
    pcall(function()
        _G.Instance.new = _hookedNew
        hookOk = true
    end)
end
if not hookOk and type(getrawmetatable) == "function" then
    pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if key == "new" then
                return _hookedNew
            end
            return old[self]
        end)
        setreadonly(mt, true)
        hookOk = true
    end)
end

-- ═══ ЗАГРУЗКА ═══
local function _g(u)
    if type(request) == "function" then
        local ok, r = pcall(request, { Url = u, Method = "GET" })
        if ok and r and r.Body then return r.Body end
    end
    if type(http_request) == "function" then
        local ok, r = pcall(http_request, { Url = u })
        if ok and r and r.Body then return r.Body end
    end
    local ok, r = pcall(game.HttpGet, game, u, true)
    if ok and type(r) == "string" then return r end
end

local src = _g(_u)
if type(src) ~= "string" or #src < 100000 then error("[ssv] fail") end

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
--  1. ЛУНА В КОДЕ
-- ═══════════════════════════════════════════════════════════════
R('79685990879972', '0')
R('rbxassetid://79685990879972', 'rbxassetid://0')
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R('[Mm][Oo][Oo][Nn]', '')
R('[Ll][Uu][Nn][Aa]', '')

-- BackgroundImage с луной
local ok_bg, new_bg = pcall(function()
    return src:gsub('BackgroundImage%s*=%s*"([^"]*)"', function(v)
        local low = v:lower()
        if low:find("moon") or low:find("79685") or low:find("luna") then
            return 'BackgroundImage = ""'
        end
        return 'BackgroundImage = "' .. v .. '"'
    end)
end)
if ok_bg then src = new_bg end

-- Эмодзи луны
for _, e in ipairs({"\240\159\140\145","\240\159\140\146","\240\159\140\147","\240\159\140\148","\240\159\140\149","\240\159\140\150","\240\159\140\151","\240\159\140\152","\240\159\140\153","\240\159\140\154","\240\159\140\155","\240\159\140\156","\240\159\140\157","\240\159\140\158"}) do
    R(e, '')
end

-- ═══════════════════════════════════════════════════════════════
--  2. ПОВТОРЫ qmee2 / ssv
-- ═══════════════════════════════════════════════════════════════
local function collapse(text, word)
    local iter = 0
    while iter < 20 do
        iter = iter + 1
        local ok, new = pcall(function() return text:gsub(word .. "[%s%p]+" .. word, word) end)
        if ok and type(new) == "string" and new ~= text then text = new else break end
    end
    local ok2, new2 = pcall(function() return text:gsub(word .. word, word) end)
    if ok2 and type(new2) == "string" then text = new2 end
    return text
end

src = collapse(src, "qmee2")
src = collapse(src, "ssv")
R('created by qmee2 and qmee2', 'created by qmee2')
R('by qmee2 and qmee2', 'by qmee2')

-- ═══════════════════════════════════════════════════════════════
--  3. ТЕМА
-- ═══════════════════════════════════════════════════════════════
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(10, 10, 10%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('BackgroundColor = Color3%.fromRGB%(20, 20, 20%)', 'BackgroundColor = Color3.fromRGB(0, 0, 0)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(8, 8, 8)')
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

-- Звук — Name = "resonance"
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')
-- Меняем название уведомления о кике
R('"Player Kicked"', '"resonance"')

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
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

R('cracked', 'created')
R('crack', 'ssv')
src = collapse(src, "qmee2")
src = collapse(src, "ssv")

-- ═══ ЗАПУСК ═══
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end

-- ═══════════════════════════════════════════════════════════════
--  4. УНИВЕРСАЛЬНАЯ ПОСТ-ОБРАБОТКА — ищем ВСЕ Obsidian в CoreGui
-- ═══════════════════════════════════════════════════════════════
local function getAllObsidians()
    local result = {}
    local cg = game:GetService("CoreGui")
    
    -- Ищем в CoreGui напрямую
    for _, d in ipairs(cg:GetChildren()) do
        if d.Name == "Obsidian" then
            table.insert(result, d)
        end
    end
    
    -- Ищем в RobloxGui
    local rbxGui = cg:FindFirstChild("RobloxGui")
    if rbxGui then
        for _, d in ipairs(rbxGui:GetChildren()) do
            if d.Name == "Obsidian" then
                table.insert(result, d)
            end
        end
    end
    
    -- Ищем в остальных ScreenGui
    for _, d in ipairs(cg:GetDescendants()) do
        if d.Name == "Obsidian" and d:IsA("ScreenGui") then
            if not table.find(result, d) then
                table.insert(result, d)
            end
        end
    end
    
    return result
end

local function cleanAll()
    pcall(function()
        local obsList = getAllObsidians()
        for _, obs in ipairs(obsList) do
            for _, d in ipairs(obs:GetDescendants()) do
                if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                    local img = tostring(d.Image or "")
                    local sz = d.AbsoluteSize
                    
                    -- Луна: asset 79685* / moon / luna
                    if img:find("79685", 1, true) or img:find("moon", 1, true) or img:find("luna", 1, true) then
                        d.Image = ""
                        d.ImageTransparency = 1
                        d.Visible = false
                        d.BackgroundTransparency = 1
                    end
                    
                    -- Фон: любая картинка >1000px
                    if sz.X > 1000 or sz.Y > 500 then
                        d.Image = ""
                        d.ImageTransparency = 1
                        d.Visible = false
                        d.BackgroundTransparency = 1
                    end
                end
                
                -- Тексты: убираем повторы
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    local t = tostring(d.Text or "")
                    if t:find("qmee2") or t:find("ssv") then
                        local new = t
                        local i = 0
                        while i < 15 do
                            i = i + 1
                            local nn = new:gsub("qmee2[%s%p]+qmee2", "qmee2"):gsub("qmee2qmee2", "qmee2")
                                            :gsub("ssv[%s%p]+ssv", "ssv"):gsub("ssvssv", "ssv")
                            if nn == new then break end
                            new = nn
                        end
                        if new ~= t then d.Text = new end
                    end
                end
            end
            
            -- Фон главного окна (прямой ребёнок Obsidian)
            local bg = obs:FindFirstChild("ImageLabel")
            if bg and bg:IsA("ImageLabel") then
                bg.Image = ""
                bg.ImageTransparency = 1
                bg.Visible = false
                bg.BackgroundTransparency = 1
            end
        end
    end)
end

-- Запускаем 6 раз с разными интервалами
for _, t in ipairs({2, 4, 7, 10, 15, 20}) do
    task.delay(t, cleanAll)
end

-- Следим за изменениями
task.spawn(function()
    for _ = 1, 30 do
        task.wait(1)
        local obsList = getAllObsidians()
        if #obsList > 0 then
            for _, obs in ipairs(obsList) do
                pcall(function()
                    obs.DescendantAdded:Connect(function(d)
                        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                            task.wait(0.05)
                            pcall(function()
                                local img = tostring(d.Image or "")
                                if img:find("79685", 1, true) or img:find("moon", 1, true) then
                                    d.Image = ""
                                    d.ImageTransparency = 1
                                    d.Visible = false
                                end
                                local sz = d.AbsoluteSize
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
            break
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  5. ПЕРЕИМЕНОВЫВАЕМ ВСЕ SOUND в SoundService
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    for _ = 1, 30 do
        task.wait(1)
        pcall(function()
            for _, d in ipairs(game:GetService("SoundService"):GetDescendants()) do
                if d:IsA("Sound") and not d.Name:find("resonance") then
                    d.Name = "resonance"
                end
            end
        end)
    end
end)

if type(writefile) == "function" then
    pcall(writefile, "ssvRestart.lua", 'loadstring(game:HttpGet("' .. _uf .. '"))()')
end
