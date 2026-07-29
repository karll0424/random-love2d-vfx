
local sprite = love.graphics.newImage("images/person.png")
local sin_timer = { ts = 0, te = 8 }
local copy_interval_timer = { ts = 0, te = 10/10, cps = 10 }
local x = 380
local y = 100
local x_range = 100
local y_range = 20
local y_speed = 1
local scale = 1
local copies = {
   -- everytime a new item is generated, added to the copy
   -- oldest one is the first one to be removed
   -- copies are two items - {countdown, sin timer}
}
local mode = 1
local rgbmod


local function CreateCopy(x, y, te)
   table.insert(copies, {2, x, y, te})
end

local function IncrementCopies(dt)
   local defer_amount = 0
   for _, copy in ipairs(copies) do
      copy[1] = copy[1]-dt
      if copy[1] < 0 then
         copy[1] = 0
         defer_amount = defer_amount + 1
      end
   end
   for i = 1, defer_amount do
      table.remove(copies, 1)
   end
end

local function DrawCopies(image)
   -- start from newest to oldest
   for _, copy in ipairs(copies) do

      local rgb, p = rgbmod.CalculateRGB(copy[4])
      love.graphics.setColor(rgb[1], rgb[2], rgb[3], copy[1]/1)
      love.graphics.draw(image, copy[2]+p[1], copy[3]+p[2], 0, scale, scale)

   end
   love.graphics.setColor(1, 1, 1, 1)

end



function love.load()
   love.keyboard.setKeyRepeat(true)
   love.window.setTitle("karll0424's VFX demos (0.1)")

   rgbmod = require("scripts.trails")
   print("startup")

end

function love.draw()
   --local y = math.sin()


   DrawCopies(sprite)


   -- mode settings
   local tagoff = 0
   for i, string in ipairs({
      {{1, 1, 1, 0.9}, "[ MOVEMENT SPEED ]"},
      "SPEED: "..y_speed,
      {},
      {{1, 1, 1, 0.9}, "[ POSITION ]"},
      "ORIGIN (X): "..x,
      "ORIGIN (Y): "..y,
      "RANGE (X): "..x_range,
      "RANGE (Y): "..y_range,
      {},
      {{1, 1, 1, 0.9}, "[ IMAGE SCALE ]"},
      "SCALE: "..scale,
      {},
      {{1, 1, 1, 0.9}, "[OTHER]"},
      "RATE OF COPY INTERVALS: "..copy_interval_timer.cps.."/s"
   }) do
      local appen = ""
      if type(string) ~= "string" then
         tagoff = tagoff+1
      elseif i-tagoff == mode and type(string) == "string" then
         love.graphics.setColor(1, 1, 1, 0.7)
         appen = "> "
      elseif i-tagoff ~= mode then
         love.graphics.setColor(1, 1, 1, 0.4)
      end

      if type(string) == "table" then
         love.graphics.printf(string, 590, 10 + (i-1)*12, 200, "right")
      else
         love.graphics.printf(appen..string, 590, 10 + (i-1)*12, 200, "right")
      end
      love.graphics.setColor(1, 1, 1, 1)
   end
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.printf( { "karll0424's VFX demonstration\n", {1, 1, 1, 0.5}, "lovingly developed in college\nbuilt with love2d\ninspired by deltarune" }, 10, 10, 200)

   love.graphics.print("sin: "..(sin_timer.ts / sin_timer.te).."\ncopies: "..#copies, 10, 560)

   love.graphics.draw(sprite,
      x + (math.sin( math.rad(sin_timer.ts) * 45  ) * x_range),
      y + (math.sin( math.rad(sin_timer.ts) * 90  ) * y_range),
      0,
      scale,
      scale
   )

end

local t = 1
function love.update(dt)

   sin_timer.ts = sin_timer.ts + dt * y_speed
   if sin_timer.ts >= sin_timer.te then
      sin_timer.ts = sin_timer.ts - sin_timer.te
   end

   copy_interval_timer.ts = copy_interval_timer.ts + dt
   if copy_interval_timer.ts >= copy_interval_timer.te then
      copy_interval_timer.ts = 0


      CreateCopy(
         x + (math.sin( math.rad(sin_timer.ts) * 45  ) * x_range),
         y + (math.sin( math.rad(sin_timer.ts) * 90  ) * y_range),
         t / 100
      )
      t = t + 1
      if t == 100 then
         t = 1
      end
   end
   IncrementCopies(dt)

end

function love.keypressed(key)
   if key == "w" or key == "s" then

      if mode == 1 then
         -- speed
         y_speed = y_speed + ( (key == "w") and 0.1 or -0.1 )
      elseif mode == 2 then
         -- origin (x)
         x = x + ( (key == "w") and 10 or -10 )
      elseif mode == 3 then
         -- origin (y)
         y = y + ( (key == "w") and 10 or -10 )
      elseif mode == 4 then
         -- range (x)
         x_range = x_range + ( (key == "w") and 5 or -5 )
      elseif mode == 5 then
         -- range (y)
         y_range = y_range + ( (key == "w") and 5 or -5 )
      elseif mode == 6 then
         -- scale
         scale = scale + ( (key == "w") and 0.1 or -0.1 )
      elseif mode == 7 then
         -- frequency of shadows
         copy_interval_timer.cps = copy_interval_timer.cps + ( (key == "w") and 1 or -1)
         print(copy_interval_timer.cps / 100)
         copy_interval_timer.te = 1/copy_interval_timer.cps
      end
      -- INCLUDE: rgb trigger, speed of shadow fade, pattern select, show framerate, ui toggle (special keybind), rendering mode (filter)

   elseif key == "up" or key == "down" then
      if mode == 1 and key == "up" or mode == 7 and key == "down" then return end
      if key == "up" then
         mode = mode - 1
      else
         mode = mode + 1
      end
   end
end
