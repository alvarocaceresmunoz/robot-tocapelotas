class Parser
token VARIABLE_NAME PIECE_TYPE INTEGER SPACE TIME TEMPO PLAY

start document
rule
  document  : time_change {get_arduino_string(result)}
            | tempo_change{get_arduino_string(result)}
            | motif {get_arduino_string(result)}
            | play {get_arduino_string(result)}
            ;

  motif : VARIABLE_NAME SPACE '=' SPACE list {result = [val[0][0..-1], val[4]]};

  list  : list SPACE note {result = val[0] + val[2]}
        | note
        ;

  note  : piece_type rhythm { result = val[0] + val[1]
                              @current_rhythm = val[1]}
        | piece_type {result = val[0] + @current_rhythm}
        ;

  piece_type : PIECE_TYPE { aux = val[0]
                            if aux != 'r'
                              aux = distribute_hands(val[0])
                            end
                            result = aux
                          };

  time_change : TIME SPACE INTEGER '/' rhythm {result = 't' + val[2] + val[4]};

  tempo_change : TEMPO SPACE rhythm SPACE '=' SPACE three_digit_integer {result = 'T'+','+val[2]+','+val[6]};

  rhythm  : two_digit_integer     {result = val[0] + '_'}
          | two_digit_integer '.' {result = val[0] + val[1]}
          ;

  play : PLAY SPACE VARIABLE_NAME {result = val[2]}

  two_digit_integer : INTEGER {result = fix_length(val[0], 2)};

  three_digit_integer : INTEGER {result = fix_length(val[0], 3)};
end

---- inner ----
  require '~/Documents/scripts/arduino/robot-tocapelotas/server/parser/handler'
  require '~/Documents/scripts/arduino/robot-tocapelotas/server/parser/tokenizer'
  #attr_reader :handler

  def initialize(t, h = Handler.new())
    @tokenizer = t
    @handler = h
    @current_rhythm = fix_length('4',2) + '_'
    @current_snare = 's'
    super()
  end

  def next_token()
    @tokenizer.next_token()
  end

  def parse()
    do_parse()
  end

  def get_arduino_string(r)
    return @handler.result(r)
  end

  def fix_length(s, l)
    if s.length > l
      abort('You provided a number that was too big')
    else
      return s.rjust(l,'0')
    end
  end

  def distribute_hands(s)
    if @current_snare == 's'
      @current_snare = 'S'
    else
      @current_snare = 's'
    end

    return @current_snare
  end
