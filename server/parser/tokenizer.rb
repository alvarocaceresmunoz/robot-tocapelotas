require 'strscan'

class Tokenizer
  #TWO_DIGIT_INTEGER = /(\d){1,2}/
  #THREE_DIGIT_INTEGER =/(\d){1,3}/
  INTEGER = /(?:0|[1-9]\d*)/
  SPACE = /\s+/
  TEMPO = /\btempo\b/
  TIME = /\btime\b/
  PLAY = /\bplay\b/
  VARIABLE_NAME = /\:[a-zA-Z][a-zA-Z0-9]*/
  PIECE_TYPE = /(s|S|r)/
  #STRING = /"(?:[^"\\]|\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4}))*"/
  #TRUE   = /true/
  #FALSE  = /false/
  #NULL   = /null/

  def initialize(io)
    @ss = StringScanner.new(io.read())
  end

  def next_token()
    return if @ss.eos?

    case
    #when text = @ss.scan(TWO_DIGIT_INTEGER) then return [:TWO_DIGIT_INTEGER, text]
    #when text = @ss.scan(THREE_DIGIT_INTEGER) then return [:THREE_DIGIT_INTEGER, text]
    when text = @ss.scan(INTEGER) then return [:INTEGER, text]
    when text = @ss.scan(SPACE) then return [:SPACE, text]
    when text = @ss.scan(TIME) then return [:TIME, text]
    when text = @ss.scan(TEMPO) then return [:TEMPO, text]
    when text = @ss.scan(VARIABLE_NAME) then return [:VARIABLE_NAME, text]
    when text = @ss.scan(PIECE_TYPE) then return [:PIECE_TYPE, text]
    when text = @ss.scan(PLAY) then return [:PLAY, text]
    #when text = @ss.scan(STRING) then [:STRING, text]
    #when text = @ss.scan(TRUE)   then [:TRUE, text]
    #when text = @ss.scan(FALSE)  then [:FALSE, text]
    #when text = @ss.scan(NULL)   then [:NULL, text]
    else
      x = @ss.getch()
      return [x, x]
    end
  end
end
