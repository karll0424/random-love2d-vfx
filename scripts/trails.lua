
return {

   CalculateRGB = function(t)
      --[[
         [1, 0, 0]
         [0-1, 1, 0],

         [0, 1, 0]
         [0, 0-1, 1],

         [0, 0, 1],
         [1, 0, 0-1]

         every 1/3rd, the current index increases by 1.
         the index before is degraded until the next third.
      --]]
      local time_sixes = t*6
      local rgb = {1, 1, 1, 0}
      --local position_offset = {math.random(-5, 5), math.random(5, 5)}

      local div = math.floor(time_sixes / 2)
      local last_index = ( (div-1) % 3 ) + 1
      local current_index = ( div % 3 ) + 1
      local last_index_degrade = (( time_sixes % 2 ) - 1) % 1

      rgb[last_index] = last_index_degrade
      rgb[current_index] = 1
      print(unpack(rgb))
      return rgb, {0, 0}
   end,

   CalculateRK = function(t, twistX, twistY)
      local rgb = {0, 0, 0, 0}
      local position_offset = {0, 0}

      if twistX and twistY then
         position_offset[1] = position_offset[1] + math.random(0-twistX, twistX)
         position_offset[2] = position_offset[2] + math.random(0-twistY, twistY)
      end
   end,

   CalculateRKBehind = function(t)

   end
}
