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

    def initialize(window, player, other_player)
      @window = window
      @player = player
      @other_player = other_player
      @keys = @player.side == :left ? PLAYER1 : PLAYER2
    end

    def update
      return if @window.gameover? || @player.busy?
      if @window.button_down?  @window.char_to_button_id(@keys.key :left)
        @player.move_left @other_player
      elsif @window.button_down?  @window.char_to_button_id(@keys.key :right)
        @player.move_right @other_player
      elsif @window.button_down? @window.char_to_button_id(@keys.key :block)
        @player.block
      else
        @player.idle
      end
    end

    def button_down(key)
      return if @player.busy? || @window.gameover?
      case @keys[key]
      when :left, :right then @player.walking
      when :punch then @player.punch @other_player
      when :kick then @player.kick @other_player
      end
    end
  end
end
