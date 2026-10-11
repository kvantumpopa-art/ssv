-- ssv | created by qmee2
local _0 = getgenv and getgenv() or _G
_0.ResonanceRunning = nil
_0.ResonanceStarting = nil

-- ═══ URL оригинала (закодирован) ═══
local _c = {94,106,106,102,105,48,37,37,104,87,109,36,93,95,106,94,107,88,107,105,91,104,89,101,100,106,91,100,106,36,89,101,99,37,97,108,87,100,106,107,99,102,101,102,87,35,87,104,106,37,105,105,108,37,104,91,92,105,37,94,91,87,90,105,37,99,87,105,106,91,104,37,105,105,108}
local _u = ""
for _, n in ipairs(_c) do _u = _u .. string.char(n + 10) end

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

local function R(p, r) local ok, n = pcall(function() return src:gsub(p, r) end) if ok then src = n end end

-- ═══════════════════════════════════════════════════════════════
--  1. УБИРАЕМ ИНТРО (безопасно — добавляем return true в начало Play)
-- ═══════════════════════════════════════════════════════════════
R('function Intro%.Play%(%)', 'function Intro.Play()\n    return true')

-- ═══════════════════════════════════════════════════════════════
--  2. AUTO-CLICKER → poses
-- ═══════════════════════════════════════════════════════════════
R('<b>Auto%-Clicker</b>', '<b>poses</b>')

-- ═══════════════════════════════════════════════════════════════
--  3. НОВЫЙ ЗВУК + ИМЯ "resonance"
-- ═══════════════════════════════════════════════════════════════
-- Меняем ID звука кика
R('n34 = 97643101798871', 'n34 = 18317665126')
R('97643101798871', '18317665126')

-- Добавляем Name = "resonance" к Sound
R('Volume = tonumber%(Data%.Volume%) or 3,', 'Name = "resonance", Volume = tonumber(Data.Volume) or 3,')

-- Меняем текст уведомления о кике на "resonance"
R('"Player Kicked"', '"resonance"')

-- ═══════════════════════════════════════════════════════════════
--  4. УБИРАЕМ ВСЕ ИКОНКИ ЛУНЫ (пометим для кастомной)
-- ═══════════════════════════════════════════════════════════════
R('"moon%-star"', '"__SSV_MOON__"')
R("'moon%-star'", "'__SSV_MOON__'")
R('"moon"', '"__SSV_MOON__"')
R("'moon'", "'__SSV_MOON__'")

-- ═══════════════════════════════════════════════════════════════
--  5. СТАНДАРТНЫЕ ПАТЧИ
-- ═══════════════════════════════════════════════════════════════
R('cracked by InLoad and wraith%.dev', 'created by qmee2 💙')
R('cracked by [^"]+', 'created by qmee2 💙')
R('cracked by [^"<]+', 'created by qmee2 💙')
R('dont stop using cracks! ts crack is so cool', '💙')
R('InLoad', 'qmee2')
R('wraith%.dev', 'qmee2')
R('wraith', 'qmee2')
R('<b>Resonance</b>', '<b>ssv</b>')
R('"Resonance %%s', '"ssv %%s')
R('"Resonance", 79685990879972', '"ssv", 79685990879972')
R('or "Resonance"', 'or "ssv"')
R('AddTab%("<b>Home</b>", "house", "Profile, statistics"%)',
  'AddTab("<b><font color=\\"#64AAFF\\">ssv</font></b>", "__SSV_MOON__", "ssv")')
R('Welcome to <b><font color=\\"#fffb00\\">ssv crack</font></b>', 'Welcome to <b>ssv</b> 💙')
R('Welcome to <b>[^<]*</b>[^<]*', 'Welcome to <b>ssv</b> 💙')
R('"v2%.9"', '""')

-- Resonance → ssv (защита служебных)
local pr = {"ResonanceRunning","ResonanceStarting","ResonanceOriginalFallenHeight","ResonanceRestored","ResonanceIntro"}
local rs = {}
for i, nm in ipairs(pr) do local k = "__S"..i.."__" src = src:gsub(nm, k) rs[k] = nm end
src = src:gsub("Resonance", "ssv")
src = src:gsub("RESONANCE", "SSV")
src = src:gsub("Project ssv", "ssv")
for k, nm in pairs(rs) do src = src:gsub(k, nm) end

-- Тема (тёмно-синяя)
R('BackgroundColor = Color3%.fromRGB%(15, 15, 15%)', 'BackgroundColor = Color3.fromRGB(4, 6, 12)')
R('MainColor = Color3%.fromRGB%(25, 25, 25%)', 'MainColor = Color3.fromRGB(12, 16, 28)')
R('AccentColor = Color3%.fromRGB%(125, 85, 255%)', 'AccentColor = Color3.fromRGB(100, 170, 255)')
R('OutlineColor = Color3%.fromRGB%(40, 40, 40%)', 'OutlineColor = Color3.fromRGB(25, 38, 65)')
R('FontColor = Color3%.new%(1, 1, 1%)', 'FontColor = Color3.fromRGB(200, 220, 250)')
R('RedColor = Color3%.fromRGB%(255, 50, 50%)', 'RedColor = Color3.fromRGB(220, 80, 100)')
R('DestructiveColor = Color3%.fromRGB%(220, 38, 38%)', 'DestructiveColor = Color3.fromRGB(200, 60, 90)')

-- crack → ssv
R('cracked', 'created')
R('crack', 'ssv')
R('Crack', 'Ssv')
R('CRACK', 'SSV')
R('ssv%s+ssv', 'ssv')
R('ssvssv', 'ssv')

-- ═══ ГЛУШИМ PRINT/WARN (через глобальные функции) ═══
local _rp = print
local _rw = warn
local _re = error
local function _silent() end

_G.print = _silent
_G.warn = _silent

-- ═══ ЗАПУСК ═══
local _ok, _err = pcall(function()
    local chunk, cerr = loadstring(src, "@ssv")
    if not chunk then _re("[ssv] " .. tostring(cerr), 0) end
    local rok, rerr = pcall(chunk)
    if not rok then _re("[ssv] " .. tostring(rerr), 0) end
end)

_G.print = _rp
_G.warn = _rw

if not _ok then _re("[ssv] " .. tostring(_err), 0) end

-- ═══════════════════════════════════════════════════════════════
--  6. КАСТОМНАЯ БЕЛАЯ ЛУНА (реалистичная)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(5)
    local coreGui = game:GetService("CoreGui")
    local obsidian = coreGui:FindFirstChild("Obsidian")
    if not obsidian then return end
    
    local targets = {}
    for _, v in ipairs(obsidian:GetDescendants()) do
        if v:IsA("ImageLabel") and v.Visible then
            local p = v.Parent
            if p then
                local is_tab_icon = false
                local anc = v
                for i = 1, 4 do
                    if not anc.Parent then break end
                    anc = anc.Parent
                    if anc:IsA("TextButton") or anc.Name == "Holder" then
                        is_tab_icon = true
                        break
                    end
                end
                if is_tab_icon and v.AbsoluteSize.X >= 12 and v.AbsoluteSize.X <= 30 then
                    table.insert(targets, v)
                end
            end
        end
    end
    
    table.sort(targets, function(a, b)
        return a.AbsolutePosition.Y < b.AbsolutePosition.Y
    end)
    
    for idx, old in ipairs(targets) do
        if idx == 1 and old.Parent then
            local parent = old.Parent
            
            old.Visible = false
            old.Image = ""
            
            local holder = Instance.new("Frame")
            holder.Name = "SSV_Luna"
            holder.Size = old.Size
            holder.Position = old.Position
            holder.AnchorPoint = old.AnchorPoint
            holder.BackgroundTransparency = 1
            holder.ZIndex = old.ZIndex
            holder.Parent = parent
            
            -- Свечение (гало)
            local glow = Instance.new("ImageLabel")
            glow.Size = UDim2.fromScale(2.2, 2.2)
            glow.Position = UDim2.fromScale(0.5, 0.5)
            glow.AnchorPoint = Vector2.new(0.5, 0.5)
            glow.BackgroundTransparency = 1
            glow.Image = "rbxassetid://5028857472"
            glow.ImageColor3 = Color3.fromRGB(180, 210, 255)
            glow.ImageTransparency = 0.65
            glow.ZIndex = old.ZIndex
            glow.Parent = holder
            
            -- Луна (белый круг)
            local moon = Instance.new("Frame")
            moon.Size = UDim2.fromScale(0.9, 0.9)
            moon.Position = UDim2.fromScale(0.5, 0.5)
            moon.AnchorPoint = Vector2.new(0.5, 0.5)
            moon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            moon.BorderSizePixel = 0
            moon.ZIndex = old.ZIndex + 1
            moon.Parent = holder
            
            local c1 = Instance.new("UICorner")
            c1.CornerRadius = UDim.new(1, 0)
            c1.Parent = moon
            
            -- Тень луны (кратер, реализм)
            local crater1 = Instance.new("Frame")
            crater1.Size = UDim2.fromScale(0.22, 0.22)
            crater1.Position = UDim2.fromScale(0.28, 0.32)
            crater1.BackgroundColor3 = Color3.fromRGB(215, 225, 240)
            crater1.BorderSizePixel = 0
            crater1.ZIndex = moon.ZIndex + 1
            crater1.Parent = moon
            local c1a = Instance.new("UICorner")
            c1a.CornerRadius = UDim.new(1, 0)
            c1a.Parent = crater1
            
            local crater2 = Instance.new("Frame")
            crater2.Size = UDim2.fromScale(0.15, 0.15)
            crater2.Position = UDim2.fromScale(0.6, 0.55)
            crater2.BackgroundColor3 = Color3.fromRGB(215, 225, 240)
            crater2.BorderSizePixel = 0
            crater2.ZIndex = moon.ZIndex + 1
            crater2.Parent = moon
            local c2a = Instance.new("UICorner")
            c2a.CornerRadius = UDim.new(1, 0)
            c2a.Parent = crater2
            
            local crater3 = Instance.new("Frame")
            crater3.Size = UDim2.fromScale(0.1, 0.1)
            crater3.Position = UDim2.fromScale(0.45, 0.68)
            crater3.BackgroundColor3 = Color3.fromRGB(220, 230, 245)
            crater3.BorderSizePixel = 0
            crater3.ZIndex = moon.ZIndex + 1
            crater3.Parent = moon
            local c3a = Instance.new("UICorner")
            c3a.CornerRadius = UDim.new(1, 0)
            c3a.Parent = crater3
            
            -- Вырезающий круг (полумесяц)
            local cut = Instance.new("Frame")
            cut.Size = UDim2.fromScale(0.82, 0.82)
            cut.Position = UDim2.fromScale(0.55, -0.1)
            cut.AnchorPoint = Vector2.new(0.5, 0.5)
            cut.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
            cut.BorderSizePixel = 0
            cut.ZIndex = moon.ZIndex + 5
            cut.Parent = holder
            local c4 = Instance.new("UICorner")
            c4.CornerRadius = UDim.new(1, 0)
            c4.Parent = cut
            
            -- Мерцание
            task.spawn(function()
                while holder.Parent do
                    local t = tick()
                    glow.ImageTransparency = 0.5 + math.sin(t * 1.8) * 0.2
                    task.wait(0.05)
                end
            end)
        else
            -- Остальные иконки просто скрываем (луны больше нет)
            if old.Parent and old.Image == "" then
                old.Visible = false
            end
        end
    end
end)

-- ═══ ЕДИНЫЙ WATERMARK ═══
task.spawn(function()
    task.wait(6)
    local wm = Instance.new("ScreenGui")
    wm.Name = "SSVWatermark"
    wm.ResetOnSpawn = false
    wm.DisplayOrder = 999999
    wm.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 40)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = wm

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 170, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "ssv 🌙 created by qmee2"
    label.TextColor3 = Color3.fromRGB(200, 220, 250)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    task.spawn(function()
        local hue = 0
        while frame.Parent do
            hue = (hue + 0.005) % 1
            local col = Color3.fromHSV(hue, 0.7, 1)
            stroke.Color = col
            label.TextColor3 = Color3.fromRGB(200, 220, 250):Lerp(col, 0.3)
            task.wait(0.03)
        end
    end)
end)
