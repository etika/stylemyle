class Api::V1::CategoriesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_vertical, only: [:index,  :create,  :update, :destroy, :show]
  # equivalent of authenticate_user!
  # def new
  #   @vertical = Vertical.find(params[:vertical_id])
  #   @category = @vertical.categories.new
  # end

  def index
    categories = @vertical.catgories.order('created_at DESC');
    render json: {status: 'SUCCESS', message:'Loaded categories', data:categories},status: :ok
  end

  # def edit
  #   @category = @vertical.categories.find(params[:id])
  # end

  def show
    @category = @vertical.categories.find(params[:id])
    render json: {status: 'SUCCESS', message:'Loaded category', data:@category},status: :ok
  end

  def create
    @vertical = Vertical.find(params[:brand_id]) if params[:vertical_id].present?
    if @vertical.present?
      category =@vertical.categories.new(category_params)
      if category.save
        render json: {status: 'SUCCESS', message:'Saved category', data:category},status: :ok
      else
        render json: {status: 'ERROR', message:'Category not saved', data:category.errors},status: :unprocessable_entity
      end
    end
  end

  def destroy
    category = @vertical.categories.where(id:params[:id]).first
    category.destroy
    render json: {status: 'SUCCESS', message:'Deleted category', data:category},status: :ok
  end

  def update
    @category = @vertical.categoryies.find(params[:id])
    if @category.update_attributes(category_params)
      render json: {status: 'SUCCESS', message:'Updated category', data:category},status: :ok
    else
      render json: {status: 'ERROR', message:'Category not updated', data:category.errors},status: :unprocessable_entity
    end
  end

  private

  def set_vertical
    @vertical = Vertical.find(params[:vertical_id])
  end

  def category_params
    params.permit(:name, :state, :vertical_id)
  end
end
