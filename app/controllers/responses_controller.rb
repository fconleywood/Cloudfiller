class ResponsesController < ApplicationController

  def index
    @responses = Request.joins(:responses).where(responses: {user_id: current_user}, requests: {active: true})
    @oldresponses = Request.joins(:responses).where(responses: {user_id: current_user}, requests: {active: false}).page(params[:page])
  end

  def show
    @response = Response.find(params[:id])
  end

  def new
    @response = Response.new
  end

  def create
    if Request.joins(:responses).where(responses: {user_id: current_user}, requests: {active: true}).length < 3

      @request = Request.find(params[:request_id])
      @response = Response.new
      @response.user = current_user
      @response.request = @request
      @response.save

      respond_to do |format|
          format.js {}
          format.html {}
      end

    else
      flash[:alert] = "Oops! You already have 3 active responses. You need to complete one before adding another."
    end

  end

  def edit
    # not in use
  end

  def update
    # not in use
  end

  def destroy
    @response = Response.find(params[:id])
    @response.destory
    redirect_to user_path
  end

end
