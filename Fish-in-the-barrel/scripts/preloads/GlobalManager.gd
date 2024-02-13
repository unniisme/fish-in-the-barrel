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

func random_sample(probabilities: Array[float]) -> int:
	assert(probabilities.reduce(func(a,b): return a+b, 0) <= 1, "Distribution not valid")
	
	var random_value = randf()
	var cumulative_prob = 0.0
	
	for i in range(probabilities.size()):
		cumulative_prob += probabilities[i]
		if random_value < cumulative_prob:
			return i

	# If the loop completes without selecting, return -1
	return -1
	
func random_sample_normalised(counts : Array[float]) -> int:
	var sum = counts.reduce(func(a,b): return a+b, 0)
	for i in range(counts.size()):
		counts[i] *= 1.0/sum
	return random_sample(counts)
