require 'erb'

module Thyme
  # Provides tmux integration. Thyme outputs the timer to TMUX_FILE. Tmux reads this file and
  # outputs to its bar.
  class Tmux
    attr_reader :color, :bar, :time

    def initialize(config)
      @config = config
    end

    def open
      return if !@config.tmux
      @tmux_file = File.open(Config::TMUX_FILE, "w")
      @tmux_file.truncate(0)
      @tmux_file.rewind
      @tmux_file.write('')
      @tmux_file.flush
    end

    def tick(color, title, bar)
      @color = color
      @time  = title
      @bar   = bar

      return if !@tmux_file

      @tmux_file.truncate(0)
      @tmux_file.rewind
      @tmux_file.write(template)
      @tmux_file.flush
    end

    def close
      @tmux_file.close if @tmux_file
      File.delete(Config::TMUX_FILE) if File.exists?(Config::TMUX_FILE)
    end

    def template
      ERB.new(@config.tmux_theme).result(binding)
    end
  end
end
