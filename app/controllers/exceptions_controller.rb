class ExceptionsController < ApplicationController
  before_filter :load_target

  def load_target
    if RailsExceptionHandler.configuration.storage_strategies.include?(:mongoid)
      @target = RailsExceptionHandler::Mongoid::ErrorMessage
    else
      @target = RailsExceptionHandler::ActiveRecord::ErrorMessage
    end

  end

  def show
    @ex = @target.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') and return unless @ex
  end

  def index
    @exs = @target.all.to_a
  end
end
