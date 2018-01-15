battery_widget = widget({ type = "textbox", name = "tb_battery" })
battery_widget.border_width = 1
battery_widget.border_color = "#ffffff"

local function isempty(s)
  return s == nil or s == ''
end

function update_battery(widget)
   local fd = io.popen("upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|to\ full|percentage\"", "r")
   if not fd then
	  widget.text = " E "
	  do return end
   end
   local status = fd:read("*all")
   fd:close()

   if isempty(status) then
	  widget.text = " - "
	  do return end
   end

   local percentage = tonumber(string.match(status, "percentage:%s*(%d?%d?%d)%%"))
   local icon = "▴"
   if string.match(status, "discharging") then
	  icon = "▾"
   end

   -- starting colour
   local sr, sg = 0x00, 0x00
   -- ending colour
   local er, eg = 0xFF, 0xFF

   local ir = math.floor((100 - percentage) * (er - sr) / 100 + sr)
   local ig = math.floor(percentage * (eg - sg) / 100 + sg)
   local text_colour = "black"
   if ir > ig then
	  text_colour = "white"
   end
   local interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, 0x00)
   local text = " <span color='" .. text_colour .. "' background='#" .. interpol_colour .. "'> " .. percentage .. "%" .. icon .. " </span> "
   widget.text = text
end

 update_battery(battery_widget)
 awful.hooks.timer.register(90, function () update_battery(battery_widget) end)

-- returns a string with battery info
function battery_status ()
   local battery = 0
   local time = 0
   local state = 0  -- discharging = -1, charging = 1, nothing = 0
   local icon = ""
   local fd = io.popen("battery", "r")
   if not fd then
	  do return "no info" end
   end
   local text = fd:read("*all")
   io.close(fd)
   if string.match(text, "discharging") then
	  state = -1
	  icon =  "▾"
   else
	  state = 1
	  icon = "▴"
   end

   battery = string.match(text, "percentage:          (%d+)")
   -- above string does not always match

   return battery .. "%<b>" .. icon .."</b>"
end
