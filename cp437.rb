#!/usr/bin/env ruby --encoding=UTF-8

class CP437
    @@codepage = (0..0x7F).map {|e| e.chr}.to_a.join\
        + "ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ¢£¥₧ƒáíóúñÑªº¿⌐¬½¼¡«»"\
        + "░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αßΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°∙·√ⁿ²■…"

    def self.codepage
        @@codepage
    end

    def self.chr(n)
        @@codepage[n]
    end

    def self.ord(c)
        @@codepage.index(c)
    end

    def self.decode(s)
        s_ = ""
        s.each {|c|
            s_ += @@codepage[c]
        }
        s_
    end

    def self.encode(s)
        s_ = []
        s.chars.each {|c|
            s_.push @@codepage.index(c)
        }
        s_
    end
end

$USAGE = "CP437 encoder/decoder
Usage: #{$0} {encode|decode} <a> <b>
Read from <a> and encode or decode into <b>"

if __FILE__ == $0
    if ARGV.length != 3 then
        puts $USAGE
        exit 1
    end

    case ARGV[0]
    when "encode"
        f = File.new ARGV[1], "r:UTF-8"
        s = f.read
        f.close
        f = File.new ARGV[2], "w:ASCII-8BIT"
        f.write CP437.encode(s).map {|e| e.chr}.join
        f.close
    when "decode"
        f = File.new ARGV[1], "r:ASCII-8BIT"
        s = f.read.chars.map {|e| e.ord}.to_a
        f.close
        f = File.new ARGV[2], "w:UTF-8"
        f.write CP437.decode s
        f.close
    else
        puts "Unknow mode '#{ARGV[0]}'"
        exit 1
    end
end
