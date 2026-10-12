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

-- ═══════════════════════════════════════════════════════════════
--  ЗАГРУЖАЕМ КАРТИНКУ ЧЁРНОЙ ДЫРЫ (blackhole.png)
-- ═══════════════════════════════════════════════════════════════
local BLACKHOLE_ASSET = nil
do
    -- Пробуем несколько имён файла
    local names = {"blackhole.png", "blackhole.jpg", "blackhole.jpeg", "black hole.png", "bg.png"}
    for _, n in ipairs(names) do
        if type(isfile) == "function" and isfile(n) and type(getcustomasset) == "function" then
            local ok, id = pcall(getcustomasset, n)
            if ok and id then
                BLACKHOLE_ASSET = id
                print("[ssv] ✓ Загружена картинка: " .. n)
                break
            end
        end
    end
    if not BLACKHOLE_ASSET then
        warn("[ssv] blackhole.png не найден в workspace — используется резервный asset")
        BLACKHOLE_ASSET = "rbxassetid://16104850011"
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
--  1. УБИРАЕМ БЕЛУЮ ЛУНУ ВЕЗДЕ
-- ═══════════════════════════════════════════════════════════════
R('79685990879972', '0')
R('rbxassetid://79685990879972', 'rbxassetid://0')
R('"moon%-star"', '""')
R("'moon%-star'", "''")
R('"moon"', '""')
R("'moon'", "''")
R('"Moon"', '""')
R("'Moon'", "''")

-- Все эмодзи луны
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
--  2. ВСТАВЛЯЕМ ЧЁРНУЮ ДЫРУ КАК ФОН ОКНА
--  Подменяем BackgroundImage на нашу картинку
-- ═══════════════════════════════════════════════════════════════
-- Если уже был BackgroundImage — перезапишем
R('BackgroundImage = "[^"]*"', 'BackgroundImage = "' .. BLACKHOLE_ASSET .. '"')
R("BackgroundImage = '[^']*'", "BackgroundImage = '" .. BLACKHOLE_ASSET .. "'")

-- Если BackgroundImage не было — добавляем в тему
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
--  4. ТЁМНАЯ ТЕМА ПОД ЧЁРНУЮ ДЫРУ (чёрный + оранжевый)
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

-- Auto-Clicker → poses
R('<b>Auto%-Clicker</b>', '<b>poses</b>')

-- Звук + Name
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

-- ═══ ЗАПУСК ═══
local chunk, cerr = loadstring(src, "@ssv")
if not chunk then error("[ssv] compile: " .. tostring(cerr), 0) end
local rok, rerr = pcall(chunk)
if not rok then error("[ssv] run: " .. tostring(rerr), 0) end
-- ═══════════════════════════════════════════════════════════════
--  5. INJECT LOOP GRAB KICKS (from XOCO)
--     Rename: LoopGrab V2        → Loop Grab Kick V3
--             Loop Grab Kick V3  → Loop Grab Kick V4
--             Loop Grab Kick V3 (tp back) → Loop Grab Kick V4 (tp back)
--     Add to the same category as kicks without blobman (Target)
-- ═══════════════════════════════════════════════════════════════

-- 1) Rename existing toggles safely (use placeholders to avoid chained renames)
R('LoopGrab V2', '@@LGK_A@@')
R('Loop Grab Kick V3 %(tp back%)', '@@LGK_B@@')
R('Loop Grab Kick V3', '@@LGK_C@@')
R('@@LGK_A@@', 'Loop Grab Kick V3')
R('@@LGK_B@@', 'Loop Grab Kick V4 (tp back)')
R('@@LGK_C@@', 'Loop Grab Kick V4')

-- 2) Kick code injected into the SSV source
local _LGK_INJECT = [==[
-- ═══ LOOP GRAB KICKS (injected from XOCO) ═══
do
    local _Players = game:GetService("Players")
    local _RunService = game:GetService("RunService")
    local _RS = game:GetService("ReplicatedStorage")
    local _LP = _Players.LocalPlayer

    local function _LGK_sno(part)
        if not part or not part.Parent then return end
        pcall(function()
            _RS.GrabEvents.SetNetworkOwner:FireServer(part, part.CFrame)
        end)
    end

    _G.LGK_V3_Enabled   = false
    _G.LGK_V4_Enabled   = false
    _G.LGK_V4TP_Enabled = false

    -- Resolve selected target from SSV globals
    local function _LGK_getTarget()
        return _G.ssvSelectedTarget
            or _G.selectedTarget
            or _G.SelectedPlayer
            or _G.Target
            or _G.selectedKickPlayer
            or nil
    end

    -- ─── Loop Grab Kick V3 (former LoopGrab V2) ───
    local function LGK_V3_Loop()
        while _G.LGK_V3_Enabled do
            local target = _LGK_getTarget()
            if not target or not target.Parent or not target.Character then
                task.wait(0.1); continue
            end
            local tChar = target.Character
            local tRoot = tChar:FindFirstChild("HumanoidRootPart")
            local tHum  = tChar:FindFirstChild("Humanoid")
            local myChar = _LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if not (tRoot and tHum and myRoot) or tHum.Health <= 0 then
                task.wait(0.1); continue
            end

            local dist = (tRoot.Position - myRoot.Position).Magnitude
            if dist <= 30 then
                local bodyPos = tRoot:FindFirstChild("BodyPosition")
                if not bodyPos then
                    bodyPos = Instance.new("BodyPosition")
                    bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bodyPos.Parent = tRoot
                    bodyPos.P = 75000
                    bodyPos.D = 12000
                end
                bodyPos.Position = myRoot.Position + Vector3.new(0, 15, 0)

                local isHeld = target:FindFirstChild("IsHeld")
                if isHeld and isHeld.Value then
                    for _, v in pairs(tChar:GetChildren()) do
                        if v:IsA("Part") then
                            v.CFrame = myRoot.CFrame * CFrame.new(0, 15, 0)
                        end
                    end
                end

                tRoot.AssemblyAngularVelocity = Vector3.zero
                tRoot.AssemblyLinearVelocity = Vector3.zero
                tHum.PlatformStand = true
                _LGK_sno(tRoot)
            else
                myChar:PivotTo(tRoot.CFrame * CFrame.new(0, 2, 4))
                _LGK_sno(tRoot)
            end
            _RunService.Heartbeat:Wait()
        end

        local target = _LGK_getTarget()
        if target and target.Character then
            local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local bp = tRoot:FindFirstChild("BodyPosition")
                if bp then bp:Destroy() end
            end
        end
    end

    -- ─── Loop Grab Kick V4 (former Loop Grab Kick V3) ───
    local function LGK_V4_Loop()
        local myChar = _LP.Character
        local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local savedPos = myHRP.CFrame
        local lastRemoteFire = tick()

        while _G.LGK_V4_Enabled and _RunService.Heartbeat:Wait() do
            local target = _LGK_getTarget()
            if not target or not target.Parent then break end

            myChar = _LP.Character
            myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHead = myChar and myChar:FindFirstChild("Head")

            local tChar = target.Character
            local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
            local tHum  = tChar and tChar:FindFirstChild("Humanoid")
            if not (myChar and myHRP and myHead) or not (tHRP and tHum) or tHum.Health <= 0 then
                continue
            end

            local dist = (tHRP.Position - myHRP.Position).Magnitude
            if dist <= 30 then
                if not tHRP:FindFirstChild("KickAlign") then
                    local oldBp = tHRP:FindFirstChildOfClass("BodyPosition")
                    if oldBp then oldBp:Destroy() end
                    local att0 = Instance.new("Attachment", tHRP); att0.Name = "KickAtt0"
                    local att1 = Instance.new("Attachment", workspace.Terrain); att1.Name = "KickAtt1"
                    local ap = Instance.new("AlignPosition")
                    ap.Name = "KickAlign"; ap.Attachment0 = att0; ap.Attachment1 = att1
                    ap.MaxForce = math.huge; ap.Responsiveness = 200; ap.Parent = tHRP
                    local ar = Instance.new("AlignOrientation")
                    ar.Name = "KickRot"; ar.Attachment0 = att0
                    ar.Mode = Enum.OrientationAlignmentMode.OneAttachment
                    ar.CFrame = CFrame.new(); ar.MaxTorque = math.huge
                    ar.Responsiveness = 200; ar.Parent = tHRP
                end
                _LGK_sno(tHRP)
                local align = tHRP:FindFirstChild("KickAlign")
                if align and align.Attachment1 then
                    align.Attachment1.WorldPosition = myHead.Position + Vector3.new(0, 15, 0)
                end
                local rot = tHRP:FindFirstChild("KickRot")
                if rot then rot.CFrame = CFrame.Angles(0, 0, 0) end
                if tick() - lastRemoteFire > 0.05 then
                    pcall(function() _RS.GrabEvents.DestroyGrabLine:FireServer(tHRP) end)
                    lastRemoteFire = tick()
                end
            else
                pcall(function() myChar:PivotTo(tHRP.CFrame * CFrame.new(0, 2, 4)) end)
                _LGK_sno(tHRP)
            end
        end

        local target = _LGK_getTarget()
        if target and target.Character then
            local tH = target.Character:FindFirstChild("HumanoidRootPart")
            if tH then
                local align = tH:FindFirstChild("KickAlign")
                local rot   = tH:FindFirstChild("KickRot")
                local att0  = tH:FindFirstChild("KickAtt0")
                if align then
                    if align.Attachment1 then align.Attachment1:Destroy() end
                    align:Destroy()
                end
                if rot  then rot:Destroy()  end
                if att0 then att0:Destroy() end
                pcall(function() _RS.GrabEvents.DestroyGrabLine:FireServer(tH) end)
            end
        end
        pcall(function()
            if _LP.Character then _LP.Character:PivotTo(savedPos) end
        end)
    end

    -- ─── Loop Grab Kick V4 (tp back) (former V3 tp back) ───
    local function LGK_V4TP_Loop()
        local myChar = _LP.Character
        local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local savedPos = myHRP.CFrame
        local lastRemoteFire = tick()

        while _G.LGK_V4TP_Enabled and _RunService.Heartbeat:Wait() do
            local target = _LGK_getTarget()
            if not target or not target.Parent then break end

            myChar = _LP.Character
            myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHead = myChar and myChar:FindFirstChild("Head")

            local tChar = target.Character
            local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
            local tHum  = tChar and tChar:FindFirstChild("Humanoid")
            if not (myChar and myHRP and myHead) or not (tHRP and tHum) or tHum.Health <= 0 then
                continue
            end

            local dist = (tHRP.Position - myHRP.Position).Magnitude
            if dist > 30 then
                pcall(function() myChar:PivotTo(tHRP.CFrame * CFrame.new(0, 2, 4)) end)
                _LGK_sno(tHRP)
                if not tHRP:FindFirstChild("KickAlign") then
                    local oldBp = tHRP:FindFirstChildOfClass("BodyPosition")
                    if oldBp then oldBp:Destroy() end
                    local att0 = Instance.new("Attachment", tHRP); att0.Name = "KickAtt0"
                    local att1 = Instance.new("Attachment", workspace.Terrain); att1.Name = "KickAtt1"
                    local ap = Instance.new("AlignPosition")
                    ap.Name = "KickAlign"; ap.Attachment0 = att0; ap.Attachment1 = att1
                    ap.MaxForce = math.huge; ap.Responsiveness = 200; ap.Parent = tHRP
                    local ar = Instance.new("AlignOrientation")
                    ar.Name = "KickRot"; ar.Attachment0 = att0
                    ar.Mode = Enum.OrientationAlignmentMode.OneAttachment
                    ar.CFrame = CFrame.new(); ar.MaxTorque = math.huge
                    ar.Responsiveness = 200; ar.Parent = tHRP
                end
                local grabStartTime = tick()
                while (tick() - grabStartTime) < 0.3 do
                    task.wait(0.05)
                    _LGK_sno(tHRP)
                    pcall(function() _RS.GrabEvents.DestroyGrabLine:FireServer(tHRP) end)
                    local align = tHRP:FindFirstChild("KickAlign")
                    if myHead and align and align.Attachment1 then
                        align.Attachment1.WorldPosition = myHead.Position + Vector3.new(0, 15, 0)
                    end
                end
                pcall(function()
                    myChar:PivotTo(savedPos)
                    tHRP.CFrame = savedPos * CFrame.new(0, 15, 0)
                end)
                continue
            end

            if not tHRP:FindFirstChild("KickAlign") then
                local oldBp = tHRP:FindFirstChildOfClass("BodyPosition")
                if oldBp then oldBp:Destroy() end
                local att0 = Instance.new("Attachment", tHRP); att0.Name = "KickAtt0"
                local att1 = Instance.new("Attachment", workspace.Terrain); att1.Name = "KickAtt1"
                local ap = Instance.new("AlignPosition")
                ap.Name = "KickAlign"; ap.Attachment0 = att0; ap.Attachment1 = att1
                ap.MaxForce = math.huge; ap.Responsiveness = 200; ap.Parent = tHRP
                local ar = Instance.new("AlignOrientation")
                ar.Name = "KickRot"; ar.Attachment0 = att0
                ar.Mode = Enum.OrientationAlignmentMode.OneAttachment
                ar.CFrame = CFrame.new(); ar.MaxTorque = math.huge
                ar.Responsiveness = 200; ar.Parent = tHRP
            end
            _LGK_sno(tHRP)
            local align = tHRP:FindFirstChild("KickAlign")
            if align and align.Attachment1 then
                align.Attachment1.WorldPosition = myHead.Position + Vector3.new(0, 15, 0)
            end
            local rot = tHRP:FindFirstChild("KickRot")
            if rot then rot.CFrame = CFrame.Angles(0, 0, 0) end
            if tick() - lastRemoteFire > 0.05 then
                pcall(function() _RS.GrabEvents.DestroyGrabLine:FireServer(tHRP) end)
                lastRemoteFire = tick()
            end
        end

        local target = _LGK_getTarget()
        if target and target.Character then
            local tH = target.Character:FindFirstChild("HumanoidRootPart")
            if tH then
                local align = tH:FindFirstChild("KickAlign")
                local rot   = tH:FindFirstChild("KickRot")
                local att0  = tH:FindFirstChild("KickAtt0")
                if align then
                    if align.Attachment1 then align.Attachment1:Destroy() end
                    align:Destroy()
                end
                if rot  then rot:Destroy()  end
                if att0 then att0:Destroy() end
                pcall(function() _RS.GrabEvents.DestroyGrabLine:FireServer(tH) end)
            end
        end
    end

    -- Public registration hook — SSV calls this after its UI is ready
    _G._LGK_RegisterToggles = function(createToggle)
        if type(createToggle) ~= "function" then return end
        createToggle("Loop Grab Kick V3", function(v)
            _G.LGK_V3_Enabled = v
            if v then task.spawn(LGK_V3_Loop) end
        end)
        createToggle("Loop Grab Kick V4", function(v)
            _G.LGK_V4_Enabled = v
            if v then task.spawn(LGK_V4_Loop) end
        end)
        createToggle("Loop Grab Kick V4 (tp back)", function(v)
            _G.LGK_V4TP_Enabled = v
            if v then task.spawn(LGK_V4TP_Loop) end
        end)
    end
end
]==]

src = src .. "\n" .. _LGK_INJECT
-- ═══════════════════════════════════════════════════════════════
--  5. ПОСТ-ОБРАБОТКА UI
--  - Удаляем белую луну везде
--  - Ставим чёрную дыру на фон главного окна
--  - Убираем повторы qmee2/ssv
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

            -- БЕЛАЯ ЛУНА: asset 79685* / moon / luna в имени
            local is_moon = false
            if img:find("79685", 1, true) then is_moon = true end
            if low:find("moon", 1, true) then is_moon = true end
            if low:find("luna", 1, true) then is_moon = true end
            if full:find("moon", 1, true) then is_moon = true end

            if is_moon then
                d.Image = ""
                d.ImageTransparency = 1
                d.Visible = false
                d.BackgroundTransparency = 1
            end

            -- БОЛЬШОЙ ФОН — заменяем на чёрную дыру
            if sz.X > 1000 or sz.Y > 500 then
                d.Image = BLACKHOLE_ASSET
                d.ImageTransparency = 0.35
                d.Visible = true
                d.ScaleType = Enum.ScaleType.Crop
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

    -- Фон главного окна — ставим чёрную дыру
    for _, c in ipairs(obs:GetChildren()) do
        if c:IsA("ImageLabel") then
            c.Image = BLACKHOLE_ASSET
            c.ImageTransparency = 0.4
            c.Visible = true
            c.ScaleType = Enum.ScaleType.Crop
        end
    end
end

-- Запускаем зачистку несколько раз
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
                                    d.Image = ""
                                    d.ImageTransparency = 1
                                    d.Visible = false
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

-- Звук → resonance
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
--  ПОСТ-ОБРАБОТКА UI — убираем луну + ставим чёрную дыру
-- ═══════════════════════════════════════════════════════════════

-- Загружаем картинку чёрной дыры
local BH_ASSET = nil
if type(isfile) == "function" and type(getcustomasset) == "function" then
    for _, n in ipairs({"blackhole.png", "blackhole.jpg", "blackhole.jpeg", "bg.png"}) do
        if isfile(n) then
            local ok, id = pcall(getcustomasset, n)
            if ok and id then BH_ASSET = id break end
        end
    end
end

if BH_ASSET then
    warn("[ssv] Фон: " .. BH_ASSET)
else
    warn("[ssv] blackhole.png не найден в workspace")
end

local function clean()
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, obs in ipairs(cg:GetDescendants()) do
            if obs.Name == "Obsidian" and (obs:IsA("ScreenGui") or obs:IsA("Folder")) then
                -- 1. Скрываем луну везде
                for _, d in ipairs(obs:GetDescendants()) do
                    if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        local img = tostring(d.Image or "")
                        local full = d:GetFullName()
                        local sz = d.AbsoluteSize
                        
                        -- Луна (asset 0 / пусто / 79685) — маленькие иконки
                        if (img == "" or img == "rbxassetid://0" or img:find("79685", 1, true)) then
                            if sz.X <= 40 and sz.Y <= 40 then
                                d.Visible = false
                                d.ImageTransparency = 1
                            end
                        end
                        
                        -- Явные луны по пути
                        if full:find("Obsidian.Frame.TextLabel.ImageLabel", 1, true) 
                           or full:find("Obsidian.Main.Frame.Frame.ImageLabel", 1, true) then
                            d.Visible = false
                            d.ImageTransparency = 1
                        end
                        
                        -- 2. Большой фон — заменяем на чёрную дыру
                        if sz.X > 1000 or sz.Y > 500 then
                            if BH_ASSET then
                                d.Image = BH_ASSET
                                d.ImageTransparency = 0.4
                                d.ScaleType = Enum.ScaleType.Crop
                                d.Visible = true
                                d.BackgroundTransparency = 1
                            else
                                d.Image = ""
                                d.ImageTransparency = 1
                                d.Visible = false
                            end
                        end
                    end
                    
                    -- Тексты — убираем повторы qmee2/ssv
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

-- Чистим много раз — UI строится поэтапно
for _, delay in ipairs({2, 4, 6, 8, 12, 16, 22, 30}) do
    task.delay(delay, clean)
end

-- Следим за новыми ImageLabel
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
                            if (img == "" or img == "rbxassetid://0" or img:find("79685", 1, true)) 
                               and sz.X <= 40 and sz.Y <= 40 then
                                d.Visible = false
                                d.ImageTransparency = 1
                            end
                            if sz.X > 1000 or sz.Y > 500 then
                                if BH_ASSET then
                                    d.Image = BH_ASSET
                                    d.ImageTransparency = 0.4
                                    d.ScaleType = Enum.ScaleType.Crop
                                    d.Visible = true
                                else
                                    d.Visible = false
                                end
                            end
                        end)
                    end
                end)
            end
        end
    end)
end)
