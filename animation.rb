module Fighter
  class Animation
    def initialize(pattern, window)
      @images = find_images_matching_pattern pattern
      @current_image_index = 0
      @last_time = 0
    end

    def draw(*args)
      @last_time ||= Gosu.milliseconds
      @images[@current_image_index].draw *args
      next_image if Gosu::milliseconds - @last_time > 150 || @frozen
    end

    def next_image
      if @play_once && @current_image_index == @images.length - 1
        @play_once.call
        return
      end
      (@current_image_index < @images.length-1)? @current_image_index += 1 : @current_image_index = 0
      @last_time = Gosu::milliseconds
    end

    def play_once &next_move
      @play_once = next_move
      @current_image_index = 0
      @last_time = 0
    end

    def freeze!
      @frozen = true
    end

    def find_images_matching_pattern(pattern)
      @image_files = Dir.glob("assets/#{pattern}*").map {  |path| Gosu::Image.new(path)  }
    end

    def width
      @images[0].width
    end

    def height
      @images[0].height
    end
  end
end
