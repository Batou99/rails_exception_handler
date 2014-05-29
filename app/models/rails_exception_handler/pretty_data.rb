module RailsExceptionHandler::PrettyData
  def user_agent_pretty
    "#{user_agent.match(/(Linux|Mac|Windows|iPad|iPhone|Android)/).captures[0]} #{user_agent.split(' ')[0]}" rescue "???"
  end

end
