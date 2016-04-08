module Inesita
  class AppFilesListener
    include Singleton
    CURRENT_DIR = Dir.pwd

    def initialize
      @websockets = []
      listener = Listen.to(Config::APP_DIR) do |modified, added, _removed|
        (modified + added).each do |file|
          @websockets.each do |ws|
            ws.send transform_filename(file)
          end
        end
      end
      listener.start
    end

    def add_ws(ws)
      @websockets << ws
    end

    def rm_ws(ws)
      @websockets.delete(ws)
    end

    def transform_filename(filename)
      filename.sub!(CURRENT_DIR, '')
      path = filename.split('/')
      path.delete('')
      path.delete(Config::APP_DIR)
      path = path.join('/').split('.')

      prefix = Config::ASSETS_PREFIX
      name = path.first
      if path.include?('rb') || path.include?('js')
        "#{prefix}|#{name}|js"
      elsif path.include?('sass') || path.include?('css')
        "#{prefix}|stylesheet|css"
      end
    end
  end
end
