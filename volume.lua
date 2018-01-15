volume_widget = widget({ type = "textbox", name = "tb_volume", align = "right" })
volume_widget.border_width = 1
volume_widget.border_color = "#ffffff"

function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()

   local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))

   status = string.match(status, "%[(o[^%]]*)%]")

   -- starting colour
   local sr, sg, sb = 0x3F, 0x3F, 0x3F
   -- ending colour
   local er, eg, eb = 0xDC, 0xDC, 0xCC

   local ir = math.floor(volume * (er - sr) / 100 + sr)
   local ig = math.floor(volume * (eg - sg) / 100 + sg)
   local ib = math.floor(volume * (eb - sb) / 100 + sb)
   interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
   if string.find(status, "on", 1, true) then
	  volume = " <span color='black' background='#" .. interpol_colour .. "'>" .. volume .. "%</span> "
   else
	  volume = " <span color='red' background='#" .. interpol_colour .. "'> M </span> "
   end
   widget.text = volume
end

update_volume(volume_widget)
awful.hooks.timer.register(30, function () update_volume(volume_widget) end)
