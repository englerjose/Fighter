module Fighter
  class Overlay
    def initialize window, player1, player2
      @window = window
      @player1 = player1
      @player2 = player2
      @font = Gosu::Font.new(@window, "Droid Serif", 100)
      @healthbar1 = Healthbar.new player1, @window
      @healthbar2 = Healthbar.new player2, @window
      @time = Gosu::milliseconds
    end

    def update
      @healthbar1.update
      @healthbar2.update
    end

    def draw
      case (Gosu::milliseconds-@time)
      when 0..500 then display "3..."
      when 500..1000 then display "2..."
      when 1000..1500 then display "1..."
      when 2000..2500 then display "Fight!"
      end
      @healthbar1.draw
      @healthbar2.draw
    end

    private
    # Print message in the top center of window
    def display message
      @font.draw(message, 275, 20, 1)
    end
  end

  class Healthbar
    def initialize player, window
      @player = player
      @window = window
    end

    def update

    end

    def draw
      width = @player.health * 3
      return if width <= 0
      x = @player.side == :left ? 20 : @window.width - width - 20
      y = 20
      color = Gosu::Color::RED
      @window.draw_quad(x, y, color, x + width, y, color, x+width, 2*y, color, x, 2*y, color, 1)
    end
  end
end
