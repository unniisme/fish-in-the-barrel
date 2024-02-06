class_name Summariser extends HTTPRequest

# Sends summary and statistics to Server

const LOGLEVELS = {
	TRACE = "TRACE",
	INFO = "INFO",
	DEBUG = "DEBUG",
	WARNING = "WARNING",
	ERROR = "ERROR"
}

@onready var server_address : String = GlobalManager.server_ip

var send_queue : Array = []

func _ready():
	
	timeout = 5
	
	connect("request_completed", _handle_request_completed)
	
#	set_http_proxy(server_address, 5000)


static func _encode_dict(table : String, data : Dictionary):
	return JSON.stringify({"table" : table, "data" : data})

func _send_data(table : String, data : Dictionary):
	# Push message to queue
	send_queue.push_back([table, data])
	cancel_request()
	_send_data_dequeue()

func _send_request(table : String, data : Dictionary) -> Error:
	var send_data = _encode_dict(table, data)
	var url = server_address + "/save"
	return request(url, [], HTTPClient.METHOD_POST, send_data)
	
func _send_data_dequeue() -> bool:
	if send_queue.is_empty():
		return true
		
	var msg = send_queue.pop_front()
	var table = msg[0]
	var data = msg[1]
	
	var status = _send_request(table, data)
	if status != OK:
		send_queue.append(msg)
		return false
	return true
		
	
	
func _log(message, level):
	var log = { Time.get_unix_time_from_system() :
				{
					"username" : GlobalManager.username,
					"message" : message,
					"level" : level
				}
			}
	_send_data("log", log)
	
func _wait_for_empty_queue():
	# Blocks thread until send queue is empty
	while not _send_data_dequeue():
		pass

func _handle_request_completed(result, response_code, header, body):
	_send_data_dequeue()
