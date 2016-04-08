module Inesita
  class LiveReload
    INJECT_CODE = Opal.compile(File.read(File.expand_path('../../../opal/inesita/live_reload.rb', __FILE__)))

    def initialize(app, _options = {})
      @app = app
      Thread.new do
        begin
          init_live_reload
        rescue => e
          puts e
        end
      end
    end

    def call(env)
      status, headers, body = @app.call(env)
      if status == 200
        new_body = inject_script(body)
        headers['Content-Length'] = new_body.bytesize.to_s
        [status, headers, [new_body]]
      else
        [status, headers, body]
      end
    end

    def inject_script(body)
      new_body = ''
      body.each { |line| new_body += line.to_s }
      new_body.gsub('{ Opal.loaded', "{ #{INJECT_CODE} Opal.loaded")
    end

    def init_live_reload
      AppFilesListener.instance
      server = Rubame::Server.new('0.0.0.0', 23654)
      loop do
        server.run do |ws|
          ws.onopen    { AppFilesListener.instance.add_ws(ws) }
          ws.onclose   { AppFilesListener.instance.rm_ws(ws) }
          ws.onmessage { |msg| ws.send 'pong' if msg == 'ping' }
        end
      end
    end
  end
end
