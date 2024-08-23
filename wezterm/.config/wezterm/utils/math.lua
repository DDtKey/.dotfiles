local M = {}

M.round = function(num)
    return num >= 0 and math.floor(num + 0.5) or math.ceil(num - 0.5)
end

M.clamp = function(x, min, max)
   return x < min and min or (x > max and max or x)
end

return M
