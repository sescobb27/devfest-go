# puma -w 8 -t "16:32" -p 5002 -q server2.ru
require 'json'

class Server
  def initialize()
    @content = File.read('response.json').freeze
  end

  def call(env)
    response = Rack::Response.new
    response['Content-Type'] = 'application/json'
    case env['PATH_INFO']
    when '/'
      if env['REQUEST_METHOD'] == 'GET'
        response.status = 200
        response.write JSON.load(@content)
        response.finish
      else
        response.status = 400
        response.finish
      end
    else
      response.status = 400
      response.finish
    end
  end
end

run Server.new
