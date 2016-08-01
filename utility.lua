-- Useful reusable functions

local tonumber = tonumber
local awful = awful
local naughty = naughty
local timer = timer
local pairs = pairs
local type = type
local table = table
local io = io
local tostring = tostring
local log = log

module("utility")

function run_once(prg, times)
   if not prg then
      do return nil end
   end
   times = times or 1
   count_prog = 
      tonumber(awful.util.pread('ps aux | grep "' .. prg .. '" | grep -v grep | wc -l'))
   if times > count_prog then
      for l = count_prog, times-1 do
         awful.util.spawn_with_shell(prg)
      end
   end
end

function repeat_every(func, seconds)
   func()
   local t = timer({ timeout = seconds })
   t:connect_signal("timeout", func)
   t:start()
end

function pop_spaces(s1,s2,maxsize)
   local sps = ""
   for i = 1, maxsize-string.len(s1)-string.len(s2) do
      sps = sps .. " "
   end
   return s1 .. sps .. s2
end

function append_table(what, to_what, overwrite)
   for k, v in pairs(what) do
      if type(k) ~= "number" then
         if overwrite or not to_what[k] then
            to_what[k] = v
         end
      else
         table.insert(to_what, v)
      end
   end
end

function slurp(file, mode)
   local mode = mode or "*all"
   local handler = io.open(file, 'r')
   local result = handler:read(mode)
   handler:close()
   return result
end

-- *** Internal calc function *** ---
function calc(result)
   naughty.notify( { title = "Awesome calc",
                     text = "Result: " .. result,
                     timeout = 5})
end

-- *** Debug pring function *** ---
function nprint(s)
   naughty.notify( { title = "Debug print",
                     text = tostring(s),
                     timeout = 5})
end

-- *** Expand table debug pring function *** ---
function dprint(s)
   naughty.notify( { title = "ETDP",
                     text = log.d_return("Debug output", s),
                     timeout = 0})
end
