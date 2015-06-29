module Fighter
  class Background < Gosu::Image
    def initialize(window)
      super('assets/background-1.jpg', tileable: true)
      @scale_x = window.width / width.to_f
      @scale_y = window.height / height.to_f
    end

    def draw
      super(0, 0, 0, @scale_x, @scale_y)
    end
  end
end
