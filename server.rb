require 'rack'
require 'json'

class Server
  def initialize()
    @content = File.read('response.json').freeze
  end

  def call(env)
    case env['PATH_INFO']
    when '/'
      if env['REQUEST_METHOD'] == 'GET'
        response = Rack::Response.new
        response['Content-Type'] = 'application/json'
        response.status = 200
        response.write JSON.load(@content)
        response.finish
      else
        [400, {}, []]
      end
    else
      [400, {}, []]
    end
  end
end

Rack::Handler::WEBrick.run Server.new, Port: 5002, Logger: WEBrick::Log.new("/dev/null"), AccessLog: []
