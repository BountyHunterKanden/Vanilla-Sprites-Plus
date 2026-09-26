return function(mod)
  -- Vanilla Sprites+
  --
  -- 1. Removes white that is really background trapped inside a front sprite
  --    (e.g. the loop of Articuno's tail). transforms.lua builds the fixed
  --    sprites and the engine's asset lookup serves them everywhere.
  --    potato_voxel fills enclosed transparent areas back in during its 3D
  --    battles, so the picImage wrapper below re-opens the gaps afterwards.
  -- 2. In potato_voxel's 3D battles, sprites the engine returns in grey are
  --    coloured with their palette under the current COLORS mode.
  --
  -- Only engine functions are wrapped (BattleState.picImage and
  -- BattleState.drawPicsLayer), and each wrapper calls the original.

  -- Not a tail call on purpose, so Gen 2's module facade still applies.
  local function rawReq(p) local m = require(p); return m end
  local function req(p) local ok, m = pcall(rawReq, p); return ok and m or nil end

  local S = {}
  local DERIVED = "save/mod-derived/vanilla_sprites_plus/battle/front/"

  local function generation()
    local gv = req("src.core.GameVersion")
    local ok, g = pcall(function() return gv and gv.generation and gv.generation() end)
    return (ok and tonumber(g)) or 1
  end

  -- Gap re-punch (Gen 1 only; voxel's 3D battles don't run on Gen 2).
  -- A sprite qualifies if its alpha pattern matches one of the fixed sprites
  -- listed below. Unmodified sprites never contain enclosed transparent
  -- pixels, so any enclosed transparent pixel in a fixed sprite is a gap.
  -- Results are cached per image.
  S.GAP_MASKS = {
    ["7eca3e7c"] = true, -- bulbasaur
    ["1abaaeea"] = true, -- venusaur
    ["899e3540"] = true, -- charizard
    ["10bff751"] = true, -- squirtle
    ["522a3cc5"] = true, -- raticate
    ["05ed92e2"] = true, -- fearow
    ["37530417"] = true, -- ekans
    ["38c4d4ce"] = true, -- raichu
    ["bf1d7b35"] = true, -- zubat
    ["dc857d7c"] = true, -- gloom
    ["6fd6dcfc"] = true, -- vileplume
    ["851e7b16"] = true, -- paras
    ["7ac3404e"] = true, -- meowth
    ["e9bb4076"] = true, -- mankey
    ["81856b4a"] = true, -- abra
    ["3564171e"] = true, -- kadabra
    ["c14307c8"] = true, -- alakazam
    ["76b96e57"] = true, -- machop
    ["7ea99ad9"] = true, -- bellsprout
    ["e52e2a0a"] = true, -- weepinbell
    ["97c1a8ef"] = true, -- victreebel
    ["c8922bfd"] = true, -- tentacruel
    ["e94a5b4e"] = true, -- rapidash
    ["bdbf42a9"] = true, -- magneton
    ["8341542d"] = true, -- dewgong
    ["c090ffe8"] = true, -- muk
    ["640c0edb"] = true, -- hypno
    ["df21e060"] = true, -- cubone
    ["7ed57364"] = true, -- weezing
    ["3171d785"] = true, -- chansey
    ["947e140d"] = true, -- electabuzz
    ["f80c2700"] = true, -- magmar
    ["8a012646"] = true, -- pinsir
    ["0483e45e"] = true, -- tauros
    ["3b8435d6"] = true, -- gyarados
    ["77f1aa22"] = true, -- lapras
    ["44a76894"] = true, -- flareon
    ["20439ffc"] = true, -- omastar
    ["8834ab80"] = true, -- kabutops
    ["f0bea8d3"] = true, -- articuno
    ["55b0563c"] = true, -- zapdos
    ["9392015c"] = true, -- moltres
    ["0639cbed"] = true, -- dragonair
    ["f1d647be"] = true, -- dragonite
    ["2fb848ae"] = true, -- mewtwo
    ["90d403d0"] = true, -- mew
    ["ba112e1b"] = true, -- aerodactyl (yellow)
    ["9e00862b"] = true, -- alakazam (yellow)
    ["e57314a3"] = true, -- arcanine (yellow)
    ["a48ae1d0"] = true, -- articuno (yellow)
    ["2d4dee95"] = true, -- beedrill (yellow)
    ["6b914b1e"] = true, -- bellsprout (yellow)
    ["766743de"] = true, -- chansey (yellow)
    ["7c8fc47f"] = true, -- charizard (yellow)
    ["70cb775b"] = true, -- cloyster (yellow)
    ["15bedc1b"] = true, -- dewgong (yellow)
    ["a38a31fe"] = true, -- dodrio (yellow)
    ["8d0ba8cf"] = true, -- doduo (yellow)
    ["d153efb3"] = true, -- dragonite (yellow)
    ["a4d38243"] = true, -- dratini (yellow)
    ["dbf23a7a"] = true, -- ekans (yellow)
    ["63eb5247"] = true, -- electabuzz (yellow)
    ["e5eee7a4"] = true, -- exeggcute (yellow)
    ["e0d1cd13"] = true, -- farfetchd (yellow)
    ["73345cbc"] = true, -- fearow (yellow)
    ["6bbaef4d"] = true, -- flareon (yellow)
    ["ae10ac24"] = true, -- gastly (yellow)
    ["b6d200e9"] = true, -- gengar (yellow)
    ["e0e736ef"] = true, -- golduck (yellow)
    ["d3ee84d6"] = true, -- graveler (yellow)
    ["4859d5d3"] = true, -- growlithe (yellow)
    ["fdb7c94e"] = true, -- gyarados (yellow)
    ["749ba50a"] = true, -- haunter (yellow)
    ["171980d0"] = true, -- hitmonchan (yellow)
    ["7a2202b1"] = true, -- horsea (yellow)
    ["93c2c82e"] = true, -- hypno (yellow)
    ["aa965a58"] = true, -- ivysaur (yellow)
    ["c300a664"] = true, -- kabutops (yellow)
    ["e385b1c6"] = true, -- kadabra (yellow)
    ["df93a953"] = true, -- kingler (yellow)
    ["91a6d61c"] = true, -- machamp (yellow)
    ["633c6a38"] = true, -- machop (yellow)
    ["e26a585c"] = true, -- magikarp (yellow)
    ["fccb6f7d"] = true, -- magmar (yellow)
    ["7b6357c1"] = true, -- magnemite (yellow)
    ["ec7c06df"] = true, -- magneton (yellow)
    ["fbf55584"] = true, -- mankey (yellow)
    ["c0f45e4c"] = true, -- marowak (yellow)
    ["9bfa8fb7"] = true, -- meowth (yellow)
    ["86626658"] = true, -- mew (yellow)
    ["92012e91"] = true, -- mewtwo (yellow)
    ["f8ca3c69"] = true, -- moltres (yellow)
    ["37d3ca73"] = true, -- mr.mime (yellow)
    ["a2be5e48"] = true, -- nidoking (yellow)
    ["5977a91e"] = true, -- nidoqueen (yellow)
    ["8d67d4ef"] = true, -- nidoranf (yellow)
    ["041f3a11"] = true, -- nidoranm (yellow)
    ["324a292b"] = true, -- ninetales (yellow)
    ["36cba06b"] = true, -- oddish (yellow)
    ["827e6ea9"] = true, -- omastar (yellow)
    ["e9fc341a"] = true, -- paras (yellow)
    ["216f628a"] = true, -- parasect (yellow)
    ["104889ec"] = true, -- persian (yellow)
    ["f0d52f53"] = true, -- pidgeot (yellow)
    ["ff12a5ee"] = true, -- pidgeotto (yellow)
    ["5554e452"] = true, -- pikachu (yellow)
    ["5b2a6a64"] = true, -- pinsir (yellow)
    ["3e96a4c2"] = true, -- ponyta (yellow)
    ["4a0ed5f4"] = true, -- porygon (yellow)
    ["528d5fab"] = true, -- primeape (yellow)
    ["149c3a7c"] = true, -- psyduck (yellow)
    ["9cf768fe"] = true, -- raichu (yellow)
    ["7f57d345"] = true, -- rapidash (yellow)
    ["effbb2c4"] = true, -- raticate (yellow)
    ["9acdacba"] = true, -- rattata (yellow)
    ["8e0f8fbd"] = true, -- sandslash (yellow)
    ["3b72efe2"] = true, -- scyther (yellow)
    ["4de0353f"] = true, -- seadra (yellow)
    ["4b45559d"] = true, -- seel (yellow)
    ["17131b32"] = true, -- spearow (yellow)
    ["bd9fdba2"] = true, -- squirtle (yellow)
    ["69927d5a"] = true, -- tangela (yellow)
    ["25f807ed"] = true, -- tauros (yellow)
    ["14d14d66"] = true, -- tentacool (yellow)
    ["5f69ef40"] = true, -- tentacruel (yellow)
    ["c6b1d416"] = true, -- vaporeon (yellow)
    ["8abc1bcc"] = true, -- venonat (yellow)
    ["dca77cf1"] = true, -- venusaur (yellow)
    ["ff320e4f"] = true, -- victreebel (yellow)
    ["53ad78cb"] = true, -- vileplume (yellow)
    ["78c56bdf"] = true, -- vulpix (yellow)
    ["dcb86330"] = true, -- weedle (yellow)
    ["fb0e2ee1"] = true, -- zapdos (yellow)
  }
  S.holeCache = setmetatable({}, { __mode = "k" })
  S.outCache = setmetatable({}, { __mode = "k" })

  -- Reads back what img draws as. dpiscale = 1 avoids an upscaled copy on
  -- high-DPI Android screens, and push("all") restores the caller's state.
  function S.readBack(img)
    local w, h = img:getDimensions()
    if w <= 0 or h <= 0 then return nil end
    local data = nil
    love.graphics.push("all")
    local ok = pcall(function()
      local canvas = love.graphics.newCanvas(w, h, { dpiscale = 1 })
      love.graphics.setCanvas(canvas)
      love.graphics.origin()
      love.graphics.clear(0, 0, 0, 0)
      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(img, 0, 0)
      love.graphics.setCanvas()
      data = canvas:newImageData()
      if canvas.release then pcall(canvas.release, canvas) end
    end)
    love.graphics.pop()
    return ok and data or nil
  end

  -- Enclosed transparent pixels of a fixed sprite, or false.
  function S.holes(img)
    local hit = S.holeCache[img]
    if hit ~= nil then return hit end
    local holes = false
    pcall(function()
      local data = S.readBack(img)
      if not data then return end
      local w, h = data:getDimensions()
      local n = w * h
      local clear, hsh = {}, 5381
      local head = w .. "x" .. h .. ":"
      for i = 1, #head do hsh = (hsh * 33 + head:byte(i)) % 4294967296 end
      for y = 0, h - 1 do
        for x = 0, w - 1 do
          local _, _, _, a = data:getPixel(x, y)
          local c = a <= 0.5
          clear[y * w + x] = c
          hsh = (hsh * 33 + (c and 48 or 49)) % 4294967296
        end
      end
      if not S.GAP_MASKS[string.format("%08x", hsh)] then return end
      local outside, stack = {}, {}
      local function push(i)
        if clear[i] and not outside[i] then outside[i] = true; stack[#stack + 1] = i end
      end
      for x = 0, w - 1 do push(x); push((h - 1) * w + x) end
      for y = 0, h - 1 do push(y * w); push(y * w + w - 1) end
      while #stack > 0 do
        local i = stack[#stack]; stack[#stack] = nil
        local x = i % w
        if x > 0 then push(i - 1) end
        if x < w - 1 then push(i + 1) end
        if i >= w then push(i - w) end
        if i < n - w then push(i + w) end
      end
      local list = {}
      for i = 0, n - 1 do
        if clear[i] and not outside[i] then list[#list + 1] = i end
      end
      if #list > 0 then holes = { w = w, h = h, list = list } end
    end)
    S.holeCache[img] = holes
    return holes
  end

  -- out is what picImage returned for img, after voxel's fill if any.
  function S.punch(img, out)
    if not img or not out or out == img then return out end
    local holes = S.holes(img)
    if not holes then return out end
    local hit = S.outCache[out]
    if hit ~= nil then return hit or out end
    local made = false
    pcall(function()
      local data = S.readBack(out)
      if not data then return end
      local w, h = data:getDimensions()
      if w ~= holes.w or h ~= holes.h then return end
      local changed = false
      for _, i in ipairs(holes.list) do
        local x = i % w
        local y = (i - x) / w
        local _, _, _, a = data:getPixel(x, y)
        if a > 0 then data:setPixel(x, y, 0, 0, 0, 0); changed = true end
      end
      if not changed then return end
      local fixed = love.graphics.newImage(data)
      fixed:setFilter("nearest", "nearest")
      made = fixed
    end)
    S.outCache[out] = made
    return made or out
  end

  -- 3D battle colours (potato_voxel, Gen 1).
  --
  -- Voxel builds each Pokemon's 3D card by drawing the engine's pics layer
  -- into a texture. In OG, OG INV, CLASSIC and custom palettes, picImage
  -- returns a grey sprite and relies on a full-screen colour pass that the
  -- texture never gets. While voxel draws that texture, a grey sprite is
  -- recoloured using the palette baked into the battler's own sprite, run
  -- through PaletteFX.effectiveColors. Coloured sprites are left alone.
  --
  -- Voxel captures BattleState.drawPicsLayer at load and calls it with no
  -- onlySide to draw the texture. This mod loads first (priority 50, voxel
  -- is 100), so voxel captures this wrapper, which sets S.in3D for that
  -- call. With a different load order nothing is recoloured (see the log).
  S.colourCache = setmetatable({}, { __mode = "k" })
  S.log3D = 0

  function S.installDrawPicsWrap()
    if S.gen == 2 then return end
    local BS = req("src.battle.BattleState")
    if not BS or type(BS.drawPicsLayer) ~= "function" then return end
    if rawget(BS, "__vspDrawPics") then return end   -- already wrapped (hot reload)
    local inner = BS.drawPicsLayer
    BS.drawPicsLayer = function(self, slide, sx, sy, onlySide, skipMenuClip)
      if self and self.dramaticShapeShot and onlySide == nil then
        local was = S.in3D
        S.in3D = true
        local ok, err = pcall(inner, self, slide, sx, sy, onlySide, skipMenuClip)
        S.in3D = was
        if not ok then error(err, 0) end
        return
      end
      return inner(self, slide, sx, sy, onlySide, skipMenuClip)
    end
    rawset(BS, "__vspDrawPics", true)
  end

  local function isGrey(data)
    local w, h = data:getDimensions()
    for y = 0, h - 1 do
      for x = 0, w - 1 do
        local r, g, b, a = data:getPixel(x, y)
        if a > 0.5 and (math.abs(r - g) > 0.02 or math.abs(g - b) > 0.02) then
          return false
        end
      end
    end
    return true
  end

  local function shadeOf(r)
    if r > 0.83 then return 1 end
    if r > 0.5 then return 2 end
    if r > 0.17 then return 3 end
    return 4
  end

  function S.colourSig()
    local pfx = req("src.render.PaletteFX")
    if not pfx then return nil end
    return tostring(pfx.mode) .. "|" .. tostring(pfx.customRamp)
  end

  -- img is the battler's sprite, out is what picImage returned.
  function S.colour3D(self, img, out)
    if not S.in3D or not img or not out then return nil end
    local sig = S.colourSig()
    local hit = S.colourCache[out]
    if hit and hit.sig == sig then return hit.img or nil end
    local made = false
    local wasGrey = nil
    pcall(function()
      local od = S.readBack(out)
      if not od then return end
      wasGrey = isGrey(od)
      if not wasGrey then return end
      -- Palette baked into img, indexed by the grey shade at the same pixel
      -- in out.
      local base = {}
      local id = (img ~= out) and S.readBack(img) or nil
      local w, h = od:getDimensions()
      if id then
        local iw, ih = id:getDimensions()
        if iw == w and ih == h then
          for y = 0, h - 1 do
            for x = 0, w - 1 do
              local r, _, _, a = od:getPixel(x, y)
              if a > 0.5 then
                local s = shadeOf(r)
                if not base[s] then
                  local cr, cg, cb, ca = id:getPixel(x, y)
                  if ca > 0.5 then base[s] = { cr * 255, cg * 255, cb * 255 } end
                end
              end
            end
          end
        end
      end
      local pfx = req("src.render.PaletteFX")
      local grays = (pfx and pfx.GRAYS) or { { 255, 255, 255 }, { 170, 170, 170 }, { 85, 85, 85 }, { 0, 0, 0 } }
      for s = 1, 4 do base[s] = base[s] or grays[s] end
      local eff = pfx and pfx.effectiveColors and pfx.effectiveColors(base) or base
      od:mapPixel(function(_, _, r, g, b, a)
        if a <= 0 then return r, g, b, a end
        local c = eff[shadeOf(r)]
        return c[1] / 255, c[2] / 255, c[3] / 255, a
      end)
      local im = love.graphics.newImage(od)
      im:setFilter("nearest", "nearest")
      made = im
    end)
    S.colourCache[out] = { sig = sig, img = made }
    -- Log the first few results so a device log shows what happened.
    if S.log3D < 6 and wasGrey ~= nil then
      S.log3D = S.log3D + 1
      mod.log:info(string.format(
        "vanilla_sprites_plus: 3D pic in mode %s came back %s; %s",
        tostring(sig), wasGrey and "GREY" or "coloured",
        made and "recoloured to the palette" or "left as is"))
    end
    return made or nil
  end

  -- Logs once whether the drawPicsLayer wrapper is installed.
  function S.check3DFlag(self)
    if S.flagChecked or not (self and self.dramaticShapeShot) then return end
    S.flagChecked = true
    mod.log:info("vanilla_sprites_plus: staged 3D battle seen; drawPicsLayer wrap "
      .. (rawget(req("src.battle.BattleState") or {}, "__vspDrawPics") and "installed" or "MISSING"))
  end


  -- Keeps the picImage wrapper outermost. Runs every frame: potato_voxel
  -- wraps picImage after this mod loads, so this wraps again on top of it.
  -- Capped at 4 so two mods doing the same can't grow the chain forever.
  -- Gen 1 only.
  S.wraps = 0
  function S.installPicWrap()
    if S.gen == 2 or S.wraps >= 4 then return end
    local BS = req("src.battle.BattleState")
    if not BS or type(BS.picImage) ~= "function" then return end
    if BS.picImage == S.picWrap then return end
    local inner = BS.picImage
    local wrap
    wrap = function(self, img)
      local out = inner(self, img)
      if not S.flagChecked then pcall(S.check3DFlag, self) end
      local ok, fixed = pcall(S.punch, img, out)
      if ok and fixed then out = fixed end
      if S.colour3D then
        local okc, coloured = pcall(S.colour3D, self, img, out)
        if okc and coloured then out = coloured end
      end
      return out
    end
    BS.picImage = wrap
    S.picWrap = wrap
    S.wraps = S.wraps + 1
  end

  -- Logs one status line per boot: for each game's art, how many fixed
  -- sprites have their first gap open (opaque in the game's sprite,
  -- transparent in this mod's copy). Each entry is the first gap's {y, x},
  -- or false if the sprite has no gap.
  S.PROBE = {
    gen1 = {
      ["bulbasaur"] = { 35, 22 },
      ["venusaur"] = { 18, 10 },
      ["charizard"] = { 21, 45 },
      ["squirtle"] = false,
      ["raticate"] = { 7, 41 },
      ["fearow"] = { 16, 12 },
      ["ekans"] = { 16, 34 },
      ["raichu"] = { 13, 41 },
      ["zubat"] = { 22, 16 },
      ["gloom"] = { 21, 32 },
      ["vileplume"] = { 26, 13 },
      ["paras"] = { 14, 28 },
      ["meowth"] = { 24, 32 },
      ["mankey"] = { 7, 10 },
      ["abra"] = { 11, 11 },
      ["kadabra"] = { 15, 7 },
      ["alakazam"] = { 3, 32 },
      ["machop"] = { 15, 32 },
      ["bellsprout"] = { 11, 26 },
      ["weepinbell"] = { 12, 13 },
      ["victreebel"] = { 7, 15 },
      ["tentacruel"] = { 34, 38 },
      ["rapidash"] = { 16, 19 },
      ["magneton"] = { 17, 13 },
      ["dewgong"] = { 16, 36 },
      ["muk"] = { 14, 26 },
      ["hypno"] = { 26, 12 },
      ["cubone"] = { 29, 18 },
      ["weezing"] = { 12, 30 },
      ["chansey"] = { 17, 43 },
      ["electabuzz"] = { 13, 12 },
      ["magmar"] = { 17, 38 },
      ["pinsir"] = { 22, 10 },
      ["tauros"] = { 3, 11 },
      ["gyarados"] = { 34, 22 },
      ["lapras"] = { 24, 22 },
      ["flareon"] = { 6, 28 },
      ["omastar"] = { 33, 5 },
      ["kabutops"] = { 18, 41 },
      ["articuno"] = { 16, 27 },
      ["zapdos"] = { 32, 11 },
      ["moltres"] = { 11, 40 },
      ["dragonair"] = { 14, 19 },
      ["dragonite"] = { 17, 38 },
      ["mewtwo"] = { 15, 47 },
      ["mew"] = { 23, 9 },
    },
    gold = {
      ["abra"] = { 23, 30 },
      ["aipom"] = { 17, 31 },
      ["alakazam"] = { 14, 40 },
      ["arbok"] = { 42, 15 },
      ["ariados"] = { 26, 44 },
      ["articuno"] = { 35, 27 },
      ["azumarill"] = { 49, 37 },
      ["bayleef"] = { 21, 29 },
      ["beedrill"] = { 26, 13 },
      ["bellsprout"] = { 15, 23 },
      ["blissey"] = { 31, 9 },
      ["celebi"] = { 23, 23 },
      ["charizard"] = { 25, 36 },
      ["charmeleon"] = { 18, 24 },
      ["cloyster"] = { 11, 11 },
      ["cubone"] = { 13, 6 },
      ["delibird"] = { 3, 21 },
      ["diglett"] = { 35, 35 },
      ["dodrio"] = { 14, 20 },
      ["doduo"] = { 33, 10 },
      ["dragonair"] = { 12, 31 },
      ["dragonite"] = { 4, 19 },
      ["dugtrio"] = { 52, 6 },
      ["ekans"] = { 25, 33 },
      ["electabuzz"] = { 6, 34 },
      ["elekid"] = { 6, 22 },
      ["flaaffy"] = { 30, 38 },
      ["gastly"] = { 6, 21 },
      ["geodude"] = { 30, 27 },
      ["girafarig"] = { 42, 32 },
      ["gligar"] = { 33, 31 },
      ["gloom"] = { 24, 15 },
      ["graveler"] = { 38, 12 },
      ["gyarados"] = { 28, 34 },
      ["haunter"] = { 31, 10 },
      ["hitmonchan"] = { 31, 26 },
      ["hooh"] = { 11, 42 },
      ["hoothoot"] = { 7, 31 },
      ["horsea"] = { 16, 28 },
      ["hypno"] = { 26, 11 },
      ["jumpluff"] = { 30, 14 },
      ["jynx"] = { 28, 3 },
      ["kabuto"] = { 26, 7 },
      ["kabutops"] = { 25, 39 },
      ["kadabra"] = { 39, 30 },
      ["kingdra"] = { 7, 34 },
      ["kingler"] = { 17, 32 },
      ["koffing"] = { 8, 9 },
      ["krabby"] = { 19, 26 },
      ["ledian"] = { 21, 13 },
      ["ledyba"] = { 37, 14 },
      ["lugia"] = { 30, 49 },
      ["machamp"] = { 14, 42 },
      ["magmar"] = { 17, 21 },
      ["magneton"] = { 6, 31 },
      ["mankey"] = { 11, 32 },
      ["mareep"] = { 8, 30 },
      ["marill"] = { 13, 5 },
      ["meganium"] = { 46, 48 },
      ["meowth"] = { 24, 29 },
      ["mewtwo"] = { 17, 35 },
      ["misdreavus"] = { 13, 28 },
      ["moltres"] = { 20, 48 },
      ["mrmime"] = { 18, 11 },
      ["murkrow"] = { 37, 16 },
      ["nidoking"] = { 12, 13 },
      ["nidoranm"] = { 12, 29 },
      ["nidorina"] = { 19, 35 },
      ["nidorino"] = { 9, 20 },
      ["oddish"] = { 30, 12 },
      ["omastar"] = { 43, 37 },
      ["parasect"] = { 30, 18 },
      ["pidgeot"] = { 4, 24 },
      ["pidgeotto"] = { 38, 24 },
      ["pidgey"] = { 28, 30 },
      ["pikachu"] = { 26, 28 },
      ["pinsir"] = { 29, 12 },
      ["politoed"] = { 22, 45 },
      ["ponyta"] = { 8, 4 },
      ["primeape"] = { 15, 16 },
      ["psyduck"] = { 3, 31 },
      ["raichu"] = { 20, 33 },
      ["raikou"] = { 17, 51 },
      ["rapidash"] = { 6, 41 },
      ["rattata"] = { 27, 31 },
      ["rhydon"] = { 19, 38 },
      ["scizor"] = { 36, 41 },
      ["seadra"] = { 24, 26 },
      ["seel"] = { 13, 24 },
      ["sentret"] = { 27, 27 },
      ["shuckle"] = { 32, 5 },
      ["skarmory"] = { 9, 44 },
      ["smeargle"] = { 25, 21 },
      ["smoochum"] = { 25, 26 },
      ["spearow"] = { 28, 32 },
      ["spinarak"] = { 24, 5 },
      ["stantler"] = { 7, 6 },
      ["steelix"] = { 5, 26 },
      ["sudowoodo"] = { 15, 16 },
      ["suicune"] = { 17, 42 },
      ["tauros"] = { 21, 9 },
      ["tentacool"] = { 28, 12 },
      ["tentacruel"] = { 35, 27 },
      ["togetic"] = { 15, 32 },
      ["typhlosion"] = { 5, 30 },
      ["tyrogue"] = { 4, 14 },
      ["ursaring"] = { 4, 18 },
      ["vaporeon"] = { 27, 35 },
      ["venomoth"] = { 14, 16 },
      ["venonat"] = { 7, 13 },
      ["venusaur"] = { 23, 42 },
      ["victreebel"] = { 5, 38 },
      ["vulpix"] = { 25, 23 },
      ["weezing"] = { 3, 44 },
      ["yanma"] = { 22, 22 },
      ["zapdos"] = { 9, 11 },
    },
    yellow = {
      ["aerodactyl"] = { 43, 24 },
      ["alakazam"] = { 19, 12 },
      ["arcanine"] = { 20, 23 },
      ["articuno"] = { 21, 38 },
      ["beedrill"] = { 5, 29 },
      ["bellsprout"] = { 12, 19 },
      ["chansey"] = { 26, 6 },
      ["charizard"] = { 12, 13 },
      ["cloyster"] = { 30, 46 },
      ["dewgong"] = { 25, 22 },
      ["dodrio"] = { 2, 19 },
      ["doduo"] = { 6, 23 },
      ["dragonite"] = { 5, 19 },
      ["dratini"] = { 16, 21 },
      ["ekans"] = { 17, 27 },
      ["electabuzz"] = { 13, 13 },
      ["exeggcute"] = { 36, 40 },
      ["farfetchd"] = { 6, 10 },
      ["fearow"] = { 22, 12 },
      ["flareon"] = { 8, 32 },
      ["gastly"] = { 29, 29 },
      ["gengar"] = { 10, 32 },
      ["golduck"] = { 24, 27 },
      ["graveler"] = { 23, 40 },
      ["growlithe"] = { 15, 23 },
      ["gyarados"] = { 48, 40 },
      ["haunter"] = { 22, 45 },
      ["hitmonchan"] = { 24, 33 },
      ["horsea"] = { 23, 16 },
      ["hypno"] = { 15, 15 },
      ["ivysaur"] = { 12, 40 },
      ["kabutops"] = { 24, 38 },
      ["kadabra"] = { 26, 34 },
      ["kingler"] = { 16, 25 },
      ["machamp"] = { 30, 9 },
      ["machop"] = { 14, 11 },
      ["magikarp"] = { 21, 5 },
      ["magmar"] = { 8, 36 },
      ["magnemite"] = { 29, 30 },
      ["magneton"] = { 38, 10 },
      ["mankey"] = { 15, 8 },
      ["marowak"] = { 33, 9 },
      ["meowth"] = { 10, 10 },
      ["mew"] = { 13, 19 },
      ["mewtwo"] = { 15, 35 },
      ["moltres"] = { 9, 50 },
      ["mr.mime"] = { 40, 7 },
      ["nidoking"] = { 12, 14 },
      ["nidoqueen"] = { 30, 48 },
      ["nidoranf"] = { 15, 15 },
      ["nidoranm"] = { 15, 28 },
      ["ninetales"] = { 13, 15 },
      ["oddish"] = { 5, 25 },
      ["omastar"] = { 24, 3 },
      ["paras"] = { 18, 4 },
      ["parasect"] = { 39, 47 },
      ["persian"] = { 28, 39 },
      ["pidgeot"] = { 14, 18 },
      ["pidgeotto"] = { 15, 19 },
      ["pikachu"] = { 23, 29 },
      ["pinsir"] = { 23, 46 },
      ["ponyta"] = { 36, 11 },
      ["porygon"] = { 23, 8 },
      ["primeape"] = { 14, 14 },
      ["psyduck"] = { 2, 30 },
      ["raichu"] = { 41, 44 },
      ["rapidash"] = { 28, 10 },
      ["raticate"] = { 18, 6 },
      ["rattata"] = { 8, 25 },
      ["sandslash"] = { 10, 37 },
      ["scyther"] = { 16, 38 },
      ["seadra"] = { 13, 12 },
      ["seel"] = { 15, 22 },
      ["spearow"] = { 31, 14 },
      ["squirtle"] = { 30, 29 },
      ["tangela"] = { 10, 35 },
      ["tauros"] = { 8, 44 },
      ["tentacool"] = { 27, 14 },
      ["tentacruel"] = { 5, 26 },
      ["vaporeon"] = { 7, 24 },
      ["venonat"] = { 5, 19 },
      ["venusaur"] = { 19, 18 },
      ["victreebel"] = { 3, 32 },
      ["vileplume"] = { 34, 15 },
      ["vulpix"] = { 19, 21 },
      ["weedle"] = { 23, 23 },
      ["zapdos"] = { 4, 44 },
    },
    silver = {
      ["aerodactyl"] = { 20, 31 },
      ["aipom"] = { 22, 29 },
      ["alakazam"] = { 5, 15 },
      ["arbok"] = { 34, 37 },
      ["ariados"] = { 26, 44 },
      ["articuno"] = { 10, 28 },
      ["azumarill"] = { 37, 46 },
      ["bayleef"] = { 21, 29 },
      ["beedrill"] = { 7, 30 },
      ["bellsprout"] = { 8, 28 },
      ["butterfree"] = { 10, 31 },
      ["charizard"] = { 7, 4 },
      ["charmeleon"] = { 19, 34 },
      ["chikorita"] = { 6, 15 },
      ["clefable"] = { 14, 11 },
      ["croconaw"] = { 23, 36 },
      ["cyndaquil"] = { 7, 25 },
      ["dewgong"] = { 32, 27 },
      ["diglett"] = { 33, 35 },
      ["dodrio"] = { 4, 35 },
      ["doduo"] = { 14, 6 },
      ["donphan"] = { 32, 3 },
      ["dragonair"] = { 30, 35 },
      ["dragonite"] = { 5, 17 },
      ["drowzee"] = { 16, 13 },
      ["dugtrio"] = { 51, 5 },
      ["ekans"] = { 29, 11 },
      ["electabuzz"] = { 29, 38 },
      ["elekid"] = { 5, 20 },
      ["exeggutor"] = { 10, 22 },
      ["fearow"] = { 9, 5 },
      ["feraligatr"] = { 11, 10 },
      ["forretress"] = { 24, 47 },
      ["gastly"] = { 4, 45 },
      ["gengar"] = { 13, 39 },
      ["gligar"] = { 30, 20 },
      ["gloom"] = { 20, 17 },
      ["goldeen"] = { 40, 19 },
      ["graveler"] = { 16, 34 },
      ["haunter"] = { 25, 10 },
      ["heracross"] = { 29, 39 },
      ["hitmontop"] = { 25, 37 },
      ["hooh"] = { 12, 42 },
      ["hoppip"] = { 14, 24 },
      ["houndour"] = { 36, 22 },
      ["hypno"] = { 19, 4 },
      ["jolteon"] = { 8, 31 },
      ["kabutops"] = { 21, 40 },
      ["kadabra"] = { 37, 19 },
      ["kangaskhan"] = { 29, 12 },
      ["kingdra"] = { 5, 17 },
      ["koffing"] = { 4, 27 },
      ["krabby"] = { 13, 22 },
      ["lanturn"] = { 3, 8 },
      ["larvitar"] = { 31, 7 },
      ["ledian"] = { 21, 13 },
      ["machamp"] = { 18, 48 },
      ["machoke"] = { 25, 40 },
      ["machop"] = { 16, 13 },
      ["magikarp"] = { 26, 36 },
      ["magmar"] = { 1, 19 },
      ["magnemite"] = { 18, 29 },
      ["magneton"] = { 4, 4 },
      ["mankey"] = { 8, 10 },
      ["mantine"] = { 40, 45 },
      ["marill"] = { 21, 31 },
      ["marowak"] = { 16, 28 },
      ["meganium"] = { 1, 14 },
      ["meowth"] = { 17, 30 },
      ["mewtwo"] = { 11, 26 },
      ["miltank"] = { 20, 40 },
      ["misdreavus"] = { 39, 22 },
      ["moltres"] = { 16, 28 },
      ["mrmime"] = { 22, 10 },
      ["murkrow"] = { 11, 41 },
      ["nidorino"] = { 12, 16 },
      ["oddish"] = { 10, 27 },
      ["omastar"] = { 30, 44 },
      ["paras"] = { 12, 10 },
      ["parasect"] = { 37, 29 },
      ["persian"] = { 12, 30 },
      ["pidgeotto"] = { 22, 22 },
      ["pinsir"] = { 48, 29 },
      ["porygon"] = { 27, 13 },
      ["primeape"] = { 11, 38 },
      ["raichu"] = { 16, 29 },
      ["raikou"] = { 17, 51 },
      ["rapidash"] = { 10, 21 },
      ["rattata"] = { 15, 28 },
      ["rhydon"] = { 10, 33 },
      ["seadra"] = { 13, 21 },
      ["seaking"] = { 34, 46 },
      ["shuckle"] = { 32, 33 },
      ["skarmory"] = { 9, 45 },
      ["smeargle"] = { 39, 27 },
      ["snubbull"] = { 27, 36 },
      ["spearow"] = { 25, 10 },
      ["spinarak"] = { 24, 5 },
      ["stantler"] = { 13, 9 },
      ["steelix"] = { 30, 34 },
      ["sudowoodo"] = { 14, 36 },
      ["suicune"] = { 17, 42 },
      ["sunflora"] = { 30, 23 },
      ["sunkern"] = { 11, 22 },
      ["tangela"] = { 6, 23 },
      ["tauros"] = { 3, 42 },
      ["teddiursa"] = { 30, 31 },
      ["tentacruel"] = { 12, 10 },
      ["togetic"] = { 18, 29 },
      ["typhlosion"] = { 29, 43 },
      ["tyranitar"] = { 7, 30 },
      ["tyrogue"] = { 23, 28 },
      ["vaporeon"] = { 20, 10 },
      ["victreebel"] = { 6, 26 },
      ["vulpix"] = { 21, 22 },
      ["weezing"] = { 3, 9 },
      ["wobbuffet"] = { 33, 14 },
      ["wooper"] = { 15, 31 },
      ["xatu"] = { 13, 31 },
      ["yanma"] = { 34, 21 },
      ["zapdos"] = { 15, 27 },
      ["zubat"] = { 8, 10 },
    },
  }
  function S.report()
    if S.reported then return end
    local game = req("src.core.Game")
    local dp = game and game.data and game.data.pokemon
    if not dp then return end
    S.reported = true
    local own = {}
    for _, def in pairs(dp) do
      local rel = type(def) == "table" and def.spriteFront
      local nm = type(rel) == "string" and rel:match("battle/front/([^/]+)%.png$")
      if nm then own[nm] = rel end
    end
    local function alphaAt(path, seed)
      local ok, id = pcall(love.image.newImageData, path)
      if not (ok and id) then return nil end
      local okp, _, _, _, a = pcall(id.getPixel, id, seed[2], seed[1])
      return okp and a or nil
    end
    local parts = {}
    for _, set in ipairs({ "gen1", "yellow", "gold", "silver" }) do
      local open, n = 0, 0
      for name, seed in pairs(S.PROBE[set]) do
        n = n + 1
        if seed and own[name] then
          local mine = alphaAt(DERIVED .. name .. ".png", seed)
          local orig = alphaAt(own[name], seed)
          if mine == 0 and orig and orig > 0 then open = open + 1 end
        end
      end
      parts[#parts + 1] = set .. " " .. open .. "/" .. n
    end
    mod.log:info(string.format(
      "vanilla_sprites_plus: white gaps -- open: %s; gen %s; picImage wraps %d",
      table.concat(parts, ", "), tostring(S.gen), S.wraps))
  end

  S.gen = generation()
  if S.installDrawPicsWrap then pcall(S.installDrawPicsWrap) end
  mod.hooks:wrap("core.update", function(nextUpdate, game, dt)
    local r = nextUpdate(game, dt)
    pcall(S.installPicWrap)
    if not S.reported then pcall(S.report) end
    return r
  end)
end
