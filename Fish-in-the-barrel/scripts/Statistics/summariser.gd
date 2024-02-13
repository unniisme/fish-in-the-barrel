class_name Summariser extends HTTPRequest

# Sends summary and statistics to Server

const LOGLEVELS = {
	TRACE = "TRACE",
	INFO = "INFO",
	DEBUG = "DEBUG",
	WARNING = "WARNING",
	ERROR = "ERROR"
}

signal all_requests_completed

@onready var server_address : String = GlobalManager.server_ip

var log_uid = 0
var send_queue : Array = []
var pileup = 0

func _ready():
	
	timeout = 5
	
	connect("request_completed", _handle_request_completed)
	
#	set_http_proxy(server_address, 5000)


static func _encode_dict(table : String, data : Dictionary):
	return JSON.stringify({"table" : table, "data" : data})

func _send_data(table : String, data : Dictionary):
	# Push message to queue
	send_queue.push_back([table, data])
	_send_data_dequeue()

func _send_request(table : String, data : Dictionary) -> Error:
	var send_data = _encode_dict(table, data)
	var url = server_address + "/save"
	print("[Sum] Sending data to " + url)
	return request(url, [], HTTPClient.METHOD_POST, send_data)
	
func _send_data_dequeue() -> bool:
	if send_queue.is_empty():
		all_requests_completed.emit()
		return true
		
	if send_queue.size() > 4 or pileup >= timeout:
		cancel_request()
		
	var msg = send_queue.pop_front()
	var table = msg[0]
	var data = msg[1]
	
	var status = _send_request(table, data)
	wait_dequeue()
	if status != OK:
		pileup += 1
		send_queue.push_front(msg)
		return false
	return true
		
	
	
func _log(message, level):
	var timestamp = Time.get_unix_time_from_system()
	var log = { str(log_uid) + "." + str(timestamp) :
				{
					"username" : GlobalManager.username,
					"timestamp" : timestamp,
					"message" : message,
					"level" : level
				}
			}
	_send_data("log", log)
	log_uid += 1
	print(log)
	
func wait_dequeue():
	await get_tree().create_timer(1).timeout
	_send_data_dequeue()

func _handle_request_completed(result, response_code, header, body):
	_send_data_dequeue()
