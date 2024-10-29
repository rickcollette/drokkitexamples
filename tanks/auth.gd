# auth.gd
# authentication handler

extends Node
var jwt_token = ""
var base_url = "https://your-drokkit-server.com"
signal login_complete

func login(username: String, password: String) -> void:
    var request = HTTPRequest.new()
    add_child(request)
    var body = { "username": username, "password": password }
    
    request.request(base_url + "/login", body, HTTPClient.METHOD_POST)
    yield(request, "request_completed")
    
    if request.response_code == 200:
        var response = parse_json(request.get_body_as_string())
        jwt_token = response.token
        print("Login successful")
        emit_signal("login_complete")  # Signal to indicate login is complete
    else:
        print("Login failed:", request.response_code)
