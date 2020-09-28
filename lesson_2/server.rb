require "socket"  # socket library

def parse_request(request_line)
  http_method, path_params, version = request_line.split
  path, query = path_params.split("?")
  
  params = Hash.new
  query.scan(/[&]?([a-z0-9%]+)=([a-z0-9%]+)/) { params[$1] = $2 }

  [http_method, path, params, version]
end

server = TCPServer.new("localhost", 3003)
# create TCP server on localhost via port 3003

loop do
  client = server.accept  # waits for request, accepts call and open connection

  request_line = client.gets  # first line of request
  next if !request_line || request_line =~ /favicon/  # ignore empty or favicon requests
  puts request_line  # print into console

  http_method, path, params, version = parse_request(request_line)
  
  client.puts "#{version} 200 OK"  # status line of response 
  client.puts "Content-Type: text/html\r\n\r\n" # header + blank line
  
  # message body below
  client.puts "<html>"  # html tag
  client.puts "<body>"  # body tag
  client.puts "<pre>"  # pre tag - contents should be printed as shown to user without modification to whitespace
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls!</h1>"

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end
  
  client.puts "</body>"
  client.puts "</html>"

  client.close  # close connection
end