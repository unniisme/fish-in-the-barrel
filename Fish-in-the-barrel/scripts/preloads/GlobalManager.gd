extends Node

var username = ""
var server_ip = "http://0.0.0.0"

func _ready():
	var cookie_string = JavaScriptBridge.eval("document.cookie") as String
	var cookies = cookie_string.split(";")
	
	for cookie in cookies:
		var cookie_split = cookie.split("=")
		if cookie_split[0] == "Username":
			username = cookie_split[1]
		if cookie_split[0] == "IP":
			server_ip = cookie_split[1]
		
func _log_js(string):
	JavaScriptBridge.eval("console.log(\"" + string + "\");")
