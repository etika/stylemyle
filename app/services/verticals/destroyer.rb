module Verticals
  class Destroyer
    def initialize(id)
      @vertical = Vertical.find(id)
    end

    def call
      vertical.destroy
    end

    private

    attr_reader :vertical
  end
end
