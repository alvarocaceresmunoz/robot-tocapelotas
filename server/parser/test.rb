require_relative 'parser'
require_relative 'tokenizer'
require 'stringio'

#code = 'time 4/4'
#code = 'tempo 4 = 6'
#code = ':m1 = s r s8 r s16 r'
code = 'asodkamsda dplay :m1'
input   = StringIO.new(code)
tok     = Tokenizer.new(input)
parser  = Parser.new(tok)
handler = parser.parse()

puts "You wrote this: #{code}"
puts "Resulting code: #{handler}"

#tree = []
#aux = tok.next_token()
#while aux != nil
  #tree << aux
  #aux = tok.next_token()
#end
#puts "Here it is the syntax tree: #{tree}"
