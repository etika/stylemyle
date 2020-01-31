module Verticals
  class Updater
    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def call
      vertical.update(safe_params)
      return vertical unless vertical.errors.count.positive?

      errors << vertical.errors.full_messages
      nil
    end

    private

    attr_reader :params

    def safe_params
      params
        .require(:vertical)
        .permit(:name)
    end

    def vertical
      @vertical ||= Vertical.find_by(id: params[:id])
    end
  end
end
