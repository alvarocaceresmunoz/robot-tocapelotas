require 'io/console'
require 'serialport'

# Get port for the Arduino
if File.exist?('/dev/ttyUSB0')
  puerto_arduino = '/dev/ttyUSB0'
elsif File.exist?('/dev/ttyUSB1')
  puerto_arduino = '/dev/ttyUSB1'
else
  puts "[RUBY] Arduino is not connected. Please connect and try again"
  exit
end

#def read_char
  #STDIN.echo = false
  #STDIN.raw!
  #input = STDIN.getc.chr

  #if input == "\e" then
    #input << STDIN.read_nonblock(3) rescue nil
    #input << STDIN.read_nonblock(2) rescue nil
  #end

  #STDIN.echo = true
  #STDIN.cooked!
  #return input
#end

# Initiate serial communication
$ser = SerialPort.new(puerto_arduino, 9600, 8 , 1, SerialPort::NONE)

def send_key(key)
  puts "[RUBY] Sending #{key}..."
  $ser.write key
end
