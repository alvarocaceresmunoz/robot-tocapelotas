require 'strscan'

class Tokenizer
  INTEGER = /(?:0|[1-9]\d*)/
  SPACE = /\s+/
  TEMPO = /\btempo\b/
  TIME = /\btime\b/
  PLAY = /\bplay\b/
  VARIABLE_NAME = /\:[a-zA-Z][a-zA-Z0-9]*/
  PIECE_TYPE = /(s|S|r)/

  def initialize(io)
    @ss = StringScanner.new(io.read())
  end

  def next_token()
    return if @ss.eos?

    case
    when text = @ss.scan(INTEGER) then return [:INTEGER, text]
    when text = @ss.scan(SPACE) then return [:SPACE, text]
    when text = @ss.scan(TIME) then return [:TIME, text]
    when text = @ss.scan(TEMPO) then return [:TEMPO, text]
    when text = @ss.scan(VARIABLE_NAME) then return [:VARIABLE_NAME, text]
    when text = @ss.scan(PIECE_TYPE) then return [:PIECE_TYPE, text]
    when text = @ss.scan(PLAY) then return [:PLAY, text]
    else
      x = @ss.getch()
      return [x, x]
    end
  end
end
