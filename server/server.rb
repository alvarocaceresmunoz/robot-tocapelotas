# for serial port setup
require 'io/console'
require 'serialport'
# for the server
require 'telegram/bot'
# for the parser
require_relative 'parser/parser'
require_relative 'parser/tokenizer'
require 'stringio'

# Maximum number of characters (bytes) that can be sent to the Arduino at once
ARDUINO_SERIAL_BUS_BANDWIDTH = 64

# Get port for the Arduino
if File.exist?('/dev/ttyUSB0')
  puerto_arduino = '/dev/ttyUSB0'
elsif File.exist?('/dev/ttyUSB1')
  puerto_arduino = '/dev/ttyUSB1'
else
  puts "[RUBY] Arduino is not connected. Please connect and try again"
  exit
end
# Initiate serial communication
$ser = SerialPort.new(puerto_arduino, 9600, 8 , 1, SerialPort::NONE)

token = '217002004:AAG5Nz_fRIjGPoYrwEAV7VTS0D_QPQ9dq4I'
motifs = Hash.new

def send_motif_to_arduino(a)
  # Create a header with the header start symbol, the header length and the
  # motif length. Put it on top of the motif.
  puts a.length.to_s
  a.prepend('$' + a.length.to_s.length.to_s + a.length.to_s)

  # Break the motif in several chunks so that the Arduino serial bus is not
  # overflown with big motifs
  chunks = a.scan(/.{1,#{ARDUINO_SERIAL_BUS_BANDWIDTH}}/)

  # Send the motif in chunks, one by one, with a small delay that lets the bus
  # read the next one
  chunks.each do |c|
    puts c
    $ser.write c
    # sleep(0.0004882813)
    sleep(0.0002441406)
  end
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
                            "/robot :myVariable = s4 s4. s8 sx3 s (s s16)x2 s s s s s s4\n" +
                            "Defines a motif (a group of notes). Each note has a letter and a number with an optional dot. The letter means the piece to be hit; snare drum is represented by 's' and rests are represented by 'r'. The number with the dot means the rhythm for that note, specified in traditional notation (1 means whole note, 4. means quarter note with dot, 8 means eighth note and so on). If two notes have the same rhythm, you only have to specify it on the first one.\n\n\n" +

                            "/robot play :myVariable\n" +
                            "Tells robots to play the rhythm you defined on the motif.\n")
    elsif m.start_with?('/robot')
      if m == '/robot'
        bot.api.send_message(chat_id: message.chat.id, text: "Hey #{message.from.first_name}, you talked to me but didn't say anything apart from /robot")
      else
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
                send_motif_to_arduino(motifs[parser_output])
              else
                bot.api.send_message(chat_id: message.chat.id, text: "Hey #{message.from.first_name}, there is no motif named #{parser_output}. Check if you wrote it properly.")
              end
            #else
              #puts 'something happened'
            end
          else
            motifs.store(parser_output[0], parser_output[1])
          end
          #puts "[RUBY] Code received: #{m[7..-1]}"
          #puts "[RUBY] Motifs: #{motifs}"
          # puts
          # puts
        end
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Hey #{message.from.first_name}, if you wanna talk to me you must start messages with /start, /stop, /help or /robot.")
    end
  end
end
