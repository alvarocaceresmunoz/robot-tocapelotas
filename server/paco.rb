require 'telegram/bot'
require_relative 'robot_tocapelotas'
require_relative 'parser/parser'
require_relative 'parser/tokenizer'
require 'stringio'

token = '217002004:AAG5Nz_fRIjGPoYrwEAV7VTS0D_QPQ9dq4I'
motifs = Hash.new

def send_msg_arduino ms
  chars = ms.split ''
  chars.each do |c| 
    send_char_arduino(c)
  end
end

def send_char_arduino(a)
  puts "Key is the following: #{a}"
  send_key(a)
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    m = message.text

    if m == '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Ola shurmano #{message.from.first_name}")
    elsif m == '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Mas traisionao shur #{message.from.first_name}")
    elsif m == '/help'
      bot.api.send_message(chat_id: message.chat.id, text: "Examples:\n\n" +
                            ":myVariable = s4 s4. s8 s s s s16 s s s s s s4\n" +
                            "----------------------------------------------\n" +
                            "Defines a motif (a group of notes). Each note has a letter and a number with an optional dot. The letter means the piece to be hit; snare drum is represented by 's' and rests are represented by 'r'. The number with the dot means the rhythm for that note, specified in traditional notation (1 means whole note, 4. means quarter note with dot, 8 means eighth note and so on). If two notes have the same rhythm, you only have to specify it on the first one.\n\n\n" +
                            "play :myVariable\n" +
                            "----------------\n" +
                            "Tells the robot tocapelotas to play the rhythm you defined on the motif.\n")
    elsif m.start_with?('/robot')
      begin
        input = StringIO.new(m[7..-1])
        tok = Tokenizer.new(input)
        parser = Parser.new(tok)
        parser_output = parser.parse()
      rescue Racc::ParseError
        bot.api.send_message(chat_id: message.chat.id, text: "Hey #{message.from.first_name}, there was a syntax error on your code")
      else
        if parser_output.instance_of? String
          if parser_output.start_with?(':')
            if motifs.key?(parser_output)
              send_char_arduino(motifs[parser_output])
            else
              bot.api.send_message(chat_id: message.chat.id, text: "Hey #{message.from.first_name}, there is no motif named #{parser_output}. Check if you wrote it properly.")
            end
          #else
            #puts 'something happened'
          end
        else
          motifs.store(parser_output[0], parser_output[1])
        end
        puts "[RUBY] Code received from the parser: #{parser_output}"
        puts "[RUBY] Motifs right now: #{motifs}\n"
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Hey #{message.from.first_name}, if you wanna talk to me you must start messages with /start, /stop, /help or /robot.")
    end
  end
end
