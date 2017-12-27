module Params
  private

  def check_valid_param_type
    updatable_attributes = %w(name relationship_status introduce quote ambition
      phone address gender occupation birthday country)

    return if updatable_attributes.include? params[:type]
    render json: {message: t(".param_incorrect")}
  end
end
