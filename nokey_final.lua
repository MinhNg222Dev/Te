local g = getgenv and getgenv() or _G

local function WM()
    local sg = Instance.new("ScreenGui")
    sg.Name = "NKWM"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 9999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 170, 0, 26)
    f.Position = UDim2.new(0, 8, 1, -34)
    f.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    local c = Instance.new("UICorner", f)
    c.CornerRadius = UDim.new(0, 5)
    local s = Instance.new("UIStroke", f)
    s.Color = Color3.fromRGB(0, 110, 255)
    s.Thickness = 1.2
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -6, 1, 0)
    l.Position = UDim2.new(0, 6, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = "NoKeyByMinhNg222"
    l.TextColor3 = Color3.fromRGB(0, 170, 255)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    local d = Instance.new("Frame", f)
    d.Size = UDim2.new(0, 6, 0, 6)
    d.Position = UDim2.new(1, -11, 0.5, -3)
    d.BackgroundColor3 = Color3.fromRGB(0, 255, 90)
    d.BorderSizePixel = 0
    local dc = Instance.new("UICorner", d)
    dc.CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        while true do
            for i = 0, 1, 0.08 do d.BackgroundTransparency = i task.wait(0.03) end
            for i = 1, 0, -0.08 do d.BackgroundTransparency = i task.wait(0.03) end
        end
    end)
end

local function patchEnv()
    local keys = {"Key","key","KEY","LuarmorKey","luarmorKey","AuthKey","authkey","License","license","Whitelist","whitelist","Verified","verified","Activated","activated","Passed","passed","KeySystem","keysystem"}
    for _, k in ipairs(keys) do g[k] = g[k] ~= nil and g[k] or true end
    g.luarmor = g.luarmor or {key="BYPASSED",verified=true,licensed=true}
    g.ScriptKey = g.ScriptKey or "BYPASSED"
    g.OwnerKey  = g.OwnerKey  or "BYPASSED"
    local fns = {"CheckKey","checkKey","VerifyKey","verifyKey","ValidateKey","validateKey","IsKeyed","isKeyed","HasKey","hasKey","KeyCheck","keycheck","isvalidkey","isKeyValid","IsKeyValid","iskeyvalid","checkLicense","CheckLicense","verifyLicense","VerifyLicense"}
    for _, f in ipairs(fns) do g[f] = function(...) return true end end
    if not getmetatable(g) then
        pcall(setmetatable, g, {
            __index = function(t, k)
                local lk = tostring(k):lower()
                if lk:find("key") or lk:find("license") or lk:find("auth") or lk:find("valid") or lk:find("pass") or lk:find("white") or lk:find("activ") then
                    return "NK_BYPASSED"
                end
                return rawget(t, k)
            end,
            __newindex = rawset
        })
    end
end

local http = (syn and syn.request) or (request and request) or (http_request and http_request) or nil

local function fetch(url)
    url = url:gsub("https?://github%.com/([^/]+)/([^/]+)/blob/(.+)", "https://raw.githubusercontent.com/%1/%2/%3")
    url = url:gsub("https?://pastebin%.com/(?!raw/)([%w]+)$", "https://pastebin.com/raw/%1")
    url = url:gsub("https?://ghostbin%.com/paste/([%w]+)", "https://ghostbin.com/paste/%1/raw")
    url = url:gsub("https?://paste%.ee/p/([%w]+)", "https://paste.ee/r/%1")
    if http then
        local ok, r = pcall(http, {Url=url, Method="GET"})
        if ok and r and r.StatusCode == 200 then return r.Body end
    end
    local ok2, b = pcall(game.HttpGet, game, url)
    if ok2 and b then return b end
    return nil
end

local function hookHTTP()
    local patternStrip = function(u)
        u = u:gsub("[?&][Kk]ey=[^&]*", "")
        u = u:gsub("[?&][Ll]icense=[^&]*", "")
        u = u:gsub("[?&][Aa]uth=[^&]*", "")
        u = u:gsub("[?&][Ww]hitelist=[^&]*", "")
        u = u:gsub("[?&][Tt]oken=[^&]*", "")
        u = u:gsub("[?&][Hh]wid=[^&]*", "")
        return u
    end
    local origHG = game.HttpGet
    game.HttpGet = function(self, u, ...) return origHG(self, patternStrip(u), ...) end
    if syn and syn.request then
        local o = syn.request
        syn.request = function(t) if t and t.Url then t.Url = patternStrip(t.Url) end return o(t) end
    elseif request then
        local o = request
        request = function(t) if t and t.Url then t.Url = patternStrip(t.Url) end return o(t) end
    elseif http_request then
        local o = http_request
        http_request = function(t) if t and t.Url then t.Url = patternStrip(t.Url) end return o(t) end
    end
end

local function exec(src, name)
    if not src or #src < 5 then return false end
    local fn, err = (loadstring or load)(src, name or "chunk")
    if not fn then warn("[NK] "..tostring(err)) return false end
    local ok, e = pcall(fn)
    if not ok then warn("[NK] "..tostring(e)) return false end
    return true
end

local NK = {}

function NK.loadURL(url)
    patchEnv(); hookHTTP()
    local b = fetch(url)
    if not b then warn("[NK] fetch failed: "..url) return false end
    return exec(b, "url")
end

function NK.exec(src)
    patchEnv(); hookHTTP()
    return exec(src, "dump")
end

function NK.loadAll(urls)
    patchEnv(); hookHTTP()
    for i, u in ipairs(urls) do
        local b = fetch(u)
        if b then exec(b, "url"..i)
        else warn("[NK] skip: "..u) end
    end
end

WM()
patchEnv()
hookHTTP()

g.NK = NK
g.NoKey = NK

local obfSource = game:HttpGet("YOUR_RAW_URL_HERE")
NK.exec(obfSource)
