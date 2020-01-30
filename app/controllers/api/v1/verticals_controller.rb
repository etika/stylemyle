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
        vertical = Vertical.new(vertical_params)

        if vertical.save
          render json: {status: 'SUCCESS', message:'Saved vertical', data:vertical},status: :ok
        else
          render json: {status: 'ERROR', message:'vertical not saved', data:vertical.errors},status: :unprocessable_entity
        end
      end

      def destroy
        vertical = Vertical.find(params[:id])
        vertical.destroy
        render json: {status: 'SUCCESS', message:'Deleted vertical', data:vertical},status: :ok
      end

      def update
        vertical = Vertical.find(params[:id])
        if vertical.update_attributes(course_params)
          render json: {status: 'SUCCESS', message:'Updated vertical', data:vertical},status: :ok
        else
          render json: {status: 'ERROR', message:'Vertical not updated', data:vertical.errors},status: :unprocessable_entity
        end
      end

      private

      def vertical_params
        params.permit(:name)
end
end
