class RailsExceptionHandler::Handler
  def initialize(env, exception)
    @exception = exception
    @env = env
    @parsed_error = nil
    @controller = @env['action_controller.instance']
  end

  def handle_exception
    request = ActionDispatch::Request.new(@env)
    @parsed_error = RailsExceptionHandler::Parser.new(@exception, request, @controller)
    ErrorMessage.create(@parsed_error.relevant_info) unless(@parsed_error.ignore?)
    log_error(@parsed_error.relevant_info)
    return response
  end
  
  def log_error(info)
    message = "#{info[:class_name]} (#{info[:message]}):\n  "
    message += Rails.backtrace_cleaner.clean(info[:trace].split("\n"), :noise).join("\n")
    Rails.logger.fatal(message)
  end
  
  private

  def response
    begin
      @env['layout_for_exception_response'] = @controller.send(:_default_layout) # Store the layout of the request that failed
    rescue
      @env['layout_for_exception_response'] = 'application' # Fall back on routing errors that doesnt have _default_layout set
    end
    action_name = @parsed_error.routing_error? ? :err404 : :err500
    ErrorResponseController.action(action_name).call(@env)
  end
end