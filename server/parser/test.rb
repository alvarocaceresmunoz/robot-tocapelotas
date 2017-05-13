#require '~/Documents/repos/robot-tocapelotas/server/parser/handler'
require '~/Documents/repos/robot-tocapelotas/server/parser/parser'
require '~/Documents/repos/robot-tocapelotas/server/parser/tokenizer'
require 'stringio'

code = ':m1 = s1x1 s2x2 (s3x3 r4)x4'
#code = 'time 4/4'
#code = 'tempo 4 = 6'
#code = ':m1 = s r s8 r s16 r'
#code = 'asodkamsda dplay :m1'
input   = StringIO.new(code)
tok     = Tokenizer.new(input)
parser  = Parser.new(tok)
result  = parser.parse()

puts "You wrote this: #{code}"
puts "Resulting code: #{result}"

#tree = []
#aux = tok.next_token()
#while aux != nil
  #tree << aux
  #aux = tok.next_token()
#end
#puts "Here it is the syntax tree: #{tree}"
