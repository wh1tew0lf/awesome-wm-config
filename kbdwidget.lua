kbdwidget = widget({type = "textbox", name = "kbdwidget"}) --
kbdwidget.border_width = 1
kbdwidget.border_color = "#ffffff"
kbdwidget.text = " En "

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.add_signal("ru.gentoo.kbdd", function(...)--
				   local data = {...}
				   local layout = data[2]
				   lts = {[0] = "En", [1] = "Ru"}
				   kbdwidget.text = " " ..lts[layout].. " "
								  end
)
