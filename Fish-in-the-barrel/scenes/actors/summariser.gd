class_name Summariser extends HTTPRequest

# Sends summary and statistics to Server

const LOGLEVELS = {
	TRACE = "TRACE",
	INFO = "INFO",
	DEBUG = "DEBUG",
	WARNING = "WARNING",
	ERROR = "ERROR"
}

@export var server_address : String = "http://0.0.0.0"

var send_queue : Array = []

#func _ready():
	
#	http_request.set_http_proxy(address, 5000)

func _process(delta):
	# Keep sending queued data
	while _send_data_dequeue(): pass

static func _encode_dict(table : String, data : Dictionary):
	return JSON.stringify({"table" : table, "data" : data})

func _send_data(table : String, data : Dictionary):
	# Push message to queue
	send_queue.push_back([table, data])

func _send_request(table : String, data : Dictionary):
	var send_data = _encode_dict(table, data)
	var url = server_address + "/save"
	return request(url, [], HTTPClient.METHOD_POST, send_data)
	
func _send_data_dequeue():
	if send_queue.is_empty():
		return
		
	var msg = send_queue.pop_front()
	var table = msg[0]
	var data = msg[1]
	
	if _send_request(table, data) == ERR_BUSY:
		send_queue.push_front(msg)
		return false
		
	return true
	
	
func _log(message, level):
	var log = { Time.get_time_string_from_system() :
				{
					"message" : message,
					"level" : level
				}
			}
	_send_data("log", log)
	
