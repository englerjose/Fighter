module Fighter
  class Controls

    PLAYER1 = {
      'a' => :left,
      'd' => :right,
      'q' => :block,
      'e' => :punch,
      'r' => :kick
    }

    PLAYER2 = {
      'k' => :left,
      ';' => :right,
      'i' => :block,
      'p' => :punch,
      '[' => :kick
    }

    def initialize window, player, num
      @window = window
      @player = player
      @num = num
      @keys = [PLAYER1, PLAYER2][num-1]
    end

    def update player1_x, player2_x
      if @window.button_down?  @window.char_to_button_id(@keys.key :left)
        @num == 1 ? @player.move_left : @player.move_left(player1_x)
        #@player.turn_left @num == 2? player1_x < player2_x : true   #let the character know if it can move in the left direction
      elsif @window.button_down?  @window.char_to_button_id(@keys.key :right)
        @num == 2 ? @player.move_right : @player.move_right(player2_x)
        #@player.turn_right @num == 1? player1_x < player2_x : true  # #let the character know if it can move in the right direction
      end
    end

    def button_down key
      case @keys[key]
      when :left, :right then @player.walking
      when :block then @player.block
      when :punch then @player.punch
      when :kick then @player.kick
      end
    end
  end
end
