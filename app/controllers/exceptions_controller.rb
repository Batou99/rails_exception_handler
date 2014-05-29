require 'digest/sha1'

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
    from = params[:from] || 10.years.ago
    to = params[:to] || Time.now
    @title = 'Exceptions'
    @exs = @target.where(:updated_at.gt => from).where(:updated_at.lt => to).to_a
    @summary = {}
    @exs.each { |ex|
      prm = eval(ex.params)
      key = "#{prm["controller"]}-#{prm["action"]}" 
      key = ex.class_name if key == "-"
      key = Digest::SHA1.hexdigest(key)[0..10]
      @summary[key] = [] if !@summary[key]
      @summary[key] << ex
    }
  end
end
