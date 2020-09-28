# simulating stateful application that keep track of page number

require "socket"

def parse_request(request_line)
  http_method, path_params, version = request_line.split
  path_params.match(/\/[^\?]*/)
  path, query = $&, $'
  
  params = Hash.new
  query.scan(/[&\?]?([a-z0-9%]+)=([a-z0-9%]+)/) { params[$1] = $2 }

  [http_method, path, params, version]
end

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params, version = parse_request(request_line)
  
  client.puts "#{version} 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  
  client.puts "<html>" 
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"
  client.puts "</body>"
  client.puts "</html>"

  client.close
end