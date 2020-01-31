class Api::V1::VerticalsController < ApplicationController
  before_action :doorkeeper_authorize!
   # equivalent of authenticate_user!
  def index
    verticals = Vertical.order('created_at DESC');
    render json: {status: 'SUCCESS', message:'Loaded verticals', data:verticals},status: :ok
  end

  def show
    vertical = Vertical.find(params[:id])
    render json: {status: 'SUCCESS', message:'Loaded vertical', data:vertical},status: :ok
  end

  def edit
    @vertical = Vertical.find(params[:id])
  end

  def create
    creator = Verticals::Creator.new(params)
    vertical = creator.call
    if vertical
      render json: { vertical: vertical,status: 'SUCCESS', message:'Saved vertical', data:vertical},status: :ok }
    else
      render json: {status: 'ERROR', message:'vertical not saved',data:creator.errors }, status: :bad_request
    end
  end

  def destroy
    Verticals::Destroyer.new(params[:id]).call
        head :no_content
   end

  def update
    updater = Verticals::Updater.new(params)
    vertical = updater.call
    if vertical
      render json: { vertical: vertical status: 'SUCCESS', message:'Updated vertical', data:vertical},status: :ok
    else
      render json: { errors: updater.errors }, status: :bad_request
    end
  end

  private
  def vertical_params
    params.permit(:name)
  end
end
