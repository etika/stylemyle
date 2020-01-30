class Api::V1::CoursesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_category, only: [:index,  :create,  :update, :destroy, :show]
  # equivalent of authenticate_user!
  def index
    courses = @category.courses.order('created_at DESC');
    render json: {status: 'SUCCESS', message:'Loaded categories', data:categories},status: :ok
  end

  def show
    course = @category.courses.find(params[:id])
    render json: {status: 'SUCCESS', message:'Loaded course', data:course},status: :ok
  end

  def create
    course = @category.courses.new(course_params)
    if course.save
      render json: {status: 'SUCCESS', message:'Saved course', data:course},status: :ok
    else
      render json: {status: 'ERROR', message:'course not saved', data:course.errors},status: :unprocessable_entity
   end
  end

  def destroy
    course = @category.courses.find(params[:id])
    course.destroy
    render json: {status: 'SUCCESS', message:'Deleted course', data:course},status: :ok
  end

  def update
    course = @category.courses.find(params[:id])
    if course.update_attributes(course_params)
      render json: {status: 'SUCCESS', message:'Updated course', data:course},status: :ok
    else
      render json: {status: 'ERROR', message:'course not updated', data:course.errors},status: :unprocessable_entity
    end
  end

  private
  def course_params
    params.permit(:name, :author, :state, :category_id)
  end

  def set_category
    @category = Category.find(params[:category_id])
  end
end
