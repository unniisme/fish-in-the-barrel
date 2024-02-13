extends Node

var username = ""
var server_ip = "http://0.0.0.0"
var difficulty = 1

var current_winner = ""

func _ready():
	var cookie_string = JavaScriptBridge.eval("document.cookie")
	if cookie_string == null: return
	var cookies = cookie_string.split(";")
	
	for cookie in cookies:
		var cookie_split = cookie.split("=")
		if cookie_split[0] == "server-ip":
			server_ip = cookie_split[1]
			
		
func _log_js(string):
	JavaScriptBridge.eval("console.log(\"" + string + "\");")
