local lib = require('lib')
local textcase = require('textcase')

local case_map = {
  { key = "gas", op = "to_snake_case" },
  { key = "gad", op = "to_dash_case" },
  { key = "gaca", op = "to_camel_case" },
  { key = "gaco", op = "to_constant_case" },
  { key = "gal", op = "to_lower_case" },
  { key = "gau", op = "to_upper_case" },
}

for _, case in ipairs(case_map) do
  lib.nmap(case.key, function() textcase.operator(case.op) end)
  lib.vmap(case.key, function() textcase.visual(case.op) end)
end
