module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing do |e|
      render json: JSON.generate({error: 'error'}), status: 400
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: JSON.generate({error: 'error'}), status: 400
    end
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: JSON.generate({error: 'error'}), status: 400
    end

  end
end
