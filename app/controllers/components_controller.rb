class ComponentsController < ApplicationController


  def index

  end

  def command_io
    input = params[:input]
    result = Component.parse_input(input)
    if result
      render json: { status: 200, result: result }
    else
      render json: { status: 422 }
    end
  end

end
