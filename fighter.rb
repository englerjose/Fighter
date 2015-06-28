require 'gosu'
require_relative 'background.rb'
require_relative 'player.rb'
require_relative 'controls.rb'
require_relative 'overlay.rb'

module Fighter
  class GameWindow < Gosu::Window
    def initialize
      super 768, 480, false
      self.caption = 'Goshu Tutorial Game'
      @background_image = Background.new(self)
      @player1 = Player.new('chun-li', self, 10, height-300, :left)
      @player2 = Player.new('ryu', self, width-100, height-300, :right)
      @controls1 = Controls.new(self, @player1, @player2)
      @controls2 = Controls.new(self, @player2, @player1)
      @overlay = Overlay.new self, @player1, @player2
    end

    # Called 60 times a second by default
    # Should contain the main game logic: move objects, handle collisions etc.
    def update
      @controls1.update
      @controls2.update
    end

    # Called after update and whenever the window needs redrawing for other
    # reasons (may be skipped every other time if fps is too low). Should contain
    # the code to redraw the whole screen, but no updates to the game's state.
    def draw
      @background_image.draw
      @player1.draw
      @player2.draw
      @overlay.draw
    end

    def button_down(id)
      close if id == Gosu::KbEscape
      @controls1.button_down button_id_to_char id
      @controls2.button_down button_id_to_char id
    end

    def gameover
      @gameover = true
      @player1.freeze
      @player2.freeze
    end

    def gameover?
      return @gameover
    end
  end
end

# Main program create a window and call it's show function which doesn't return
# until the window has been closed by the user or by calling close()
window = Fighter::GameWindow.new
window.show
