# General helper to be used in rake tasks, seeds, etc...
module ApplicationHelper

  # <b>To display a test followed by the progression percentage</b>
  # For rake tasks, etc...
  def self.puts_progression(text, progression)
    STDOUT.flush
    STDOUT.print("#{text} #{progression.to_i}%\r")
    if progression.to_i >= 100
      STDOUT.flush
      puts('' * 50)
    end
  end

  # <b>To get a random boolean</b>
  def self.rnd_yes_no
    rand>0.5 # +[!p, !!p].sample+, +[true, false].sample+, ... Ruby Golfing ? ;-)
  end

end
