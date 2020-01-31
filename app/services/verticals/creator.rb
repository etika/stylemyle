module Verticals
  class Creator
    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def call
      return vertical if vertical.save

      errors << vertical.errors.full_messages
      nil
    end

    private

    attr_reader :params

    def permitted_params
      params
        .require(:vertical)
        .permit(:name)
    end

    def vertical
      @vertical ||= Vertical.new(permitted_params)
    end
  end
end
