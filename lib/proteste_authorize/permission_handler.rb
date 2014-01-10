module ProtesteAuthorize
  class PermissionHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      request_processor = ProtesteAuthorize::RequestProcessor.new(status, headers, response)

      request_processor.process
    rescue => e
      status, headers, response = @app.call(env)
      
      puts "erro no middleware:"
      puts e.backtrace
      puts "---------------------------------------"
      puts e.message
      puts "---------------------------------------"

      [status, headers, response]
    end
  end
end