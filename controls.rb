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

    def update other_player
      if @window.button_down?  @window.char_to_button_id(@keys.key :left)
        @player.move_left other_player unless @player.busy?
      elsif @window.button_down?  @window.char_to_button_id(@keys.key :right)
        @player.move_right other_player unless @player.busy?
      else
        @player.idle unless @player.busy?
      end
    end

    def button_down key
      return if @player.busy?
      case @keys[key]
      when :left, :right then @player.walking
      when :block then @player.block
      when :punch then @player.punch
      when :kick then @player.kick
      end
    end
  end
end
