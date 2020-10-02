# framework

require 'erb'

class Monroe
  def erb(filename, local = {})  # abstracts away how ERB templates are prepared and rendered
    b = binding
    message = local[:message]  # nil if message DNE
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result(b)  # passing in binding makes message available to ERB template
  end

  def response(status, headers, body = '')
    body = yield if block_given?
    [status, headers, [body]]
  end
end