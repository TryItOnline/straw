#!/usr/bin/env ruby --encoding=UTF-8

require_relative "cp437"

#require "readline"

def straw_escape(s)
    s = s.gsub("`", "``")
         .gsub("(", "`(")
         .gsub(")", "`)")
end

class Straw
    def initialize(code)
        @code = code.chars
        @st = [[""], ["Hello, World!"]]
        @tst = []
        @sp = 0
        @vars = {}
    end

    attr_reader :st
    attr_reader :sp
    attr_reader :vars
    attr_reader :output

    def cst
        @st[@sp]
    end
    
    def step
        c = @code.shift
        case c
        when "("
            s = ""
            l = 0
            loop do
                if @code.length == 0 then
                    break
                end
                c = @code.shift
                if c == "(" then
                    l += 1
                elsif c == ")" then
                    if l == 0 then
                        break
                    else
                        l -= 1
                    end
                elsif c == "`" then
                    c = @code.shift
                end
                s += c
            end
            @st[@sp].push s
        when "+"
            t = @st[@sp].pop
            @st[@sp].push @st[@sp].pop + t
        when "*"
            t = @st[@sp].pop
            @st[@sp].push @st[@sp].pop * t.length
        when "&"
            @code = @st[@sp].pop.chars + @code
        when ":"
            @st[@sp].push @st[@sp].last
        when ";"
            @st[@sp].pop
        when ","
            a = @st[@sp].pop
            b = @st[@sp].pop
            @st[@sp].push a
            @st[@sp].push b
        when "~"
            @sp ^= 1
        when "-"
            @st[@sp].push @st[@sp^1].pop
        when ">"
            STDOUT.write @st[@sp].pop.to_s
        when "<"
            #@st[@sp].push Readline.readline
            @st[@sp].push STDIN.readline.chomp
        when "?"
            if Kernel.rand < 0.5 then
                @code.shift
            end
        when "'"
            c = @st[@sp].pop
            e = @st[@sp].pop
            i = @st[@sp].pop
            if c.length > 0 then
                @code = i.chars + @code
            else
                @code = e.chars + @code
            end
        when "="
            @st[@sp].push (@st[@sp].pop == @st[@sp].pop) ? "Y" : ""
        when "!"
            @st[@sp].push (@st[@sp].pop != @st[@sp].pop) ? "Y" : ""
        when "{"
            @st[@sp].push @st[@sp].pop[0]
        when "}"
            @st[@sp].push @st[@sp].pop.chars.drop(1).join
        when '"'
            @st[@sp].push @st[@sp].pop.reverse
        when "/"
            b = @st[@sp].pop
            a = @st[@sp].pop
            @st[@sp].push @st[@sp].pop.gsub(Regexp.new(a), b)
        when "."
            r = @st[@sp].pop
            @st[@sp].push (@st[@sp].pop =~ Regexp.new(r)) ? "Y" : ""
        when "]"
            v = @st[@sp].pop
            @vars[v] = @st[@sp].pop
        when "["
            @st[@sp].push @vars[@st[@sp].pop]
        when "#"
            @st[@sp].push "0" * @st[@sp].pop.to_i
        when "$"
            @st[@sp].push @st[@sp].pop.length.to_s
        when "%"
            @st[@sp].push "(" + @st[@sp].pop + ")"
        when "@"
            # Pop a mask and a string
            # Mask the string. For example:
            #  Mask: 0001000
            #  String: ABCDEFG
            #  Result: D
            # Push the result
            m = @st[@sp].pop
            s = @st[@sp].pop
            s_ = ""
            m.chars.zip(s.chars).each {|a, b|
                if a == "1" then
                    s_ += b
                end
            }
            @st[@sp].push s_
        when "⌠"
            a = @st[@sp].pop
            b = @st[@sp].pop
            @st[@sp].push b.chars.drop(a.length).join
        when "⌡"
            a = @st[@sp].pop
            b = @st[@sp].pop
            @st[@sp].push b.chars.take(a.length).join
        when "|"
            a = @st[@sp].pop
            b = @st[@sp].pop
            l = b.split a
            s = l.map {|e| "(" + straw_escape(e) + ")"}.join
            @st[@sp].push s
        when "¡"
            @st[@sp].push "0" * @st[@sp].length
        when "≤"
            @st[@sp].push @st[@sp][@st[@sp].pop.length]
        when "≥"
            @st[@sp].push @st[@sp][@st[@sp].length - 1 - @st[@sp].pop.length]
        when "÷"
            a = @st[@sp].pop
            b = @st[@sp].pop
            @st[@sp].push "0" * (b.length / a.length)
        when "¥"
            a = @st[@sp].pop
            b = @st[@sp].pop
            @st[@sp].push "0" * (b.length % a.length)
        when "æ"
            @st[@sp].push "0" * CP437.ord(@st[@sp].pop)
        when "Æ"
            @st[@sp].push CP437.chr(@st[@sp].pop.length)
        when "ñ"
            @tst.push @st[@sp].pop
        when "Ñ"
            @st[@sp].push @tst.pop
        when "≈"
            tmp = @st[@sp]
            @st[@sp] = @tst
            @tst = tmp
        when "σ"
            @tst.clear
        when "¢"
            l = @st[@sp].pop
            s = @st[@sp].pop
            _, a, b = Straw.new(l).run.st[0]
            a = Straw.new(a).run.st[0].drop(1)
            b = Straw.new(b).run.st[0].drop(1)
            a.zip(b).each {|x, y|
                s = s.gsub(Regexp.new(x), y)
            }
            @st[@sp].push s
        when "«"
            s = @st[@sp].pop
            n = 0
            s.chars.each {|c|
                n += CP437.ord c
            }
            @st[@sp].push "0" * n
        when "»"
            n = @st[@sp].pop.length
            s = ""
            while n != 0 do
                if n > 255 then
                    s += CP437.chr 255
                    n -= 255
                else
                    s += CP437.chr n
                    break
                end
            end
            @st[@sp].push s
        when "_"
            STDERR.write @st.inspect + "\n"
        else
            @st[@sp].push c
        end
    end
    
    def run
        while @code.length != 0 do
            self.step
        end
        self
    end
end

$USAGE = "Straw - String manipulation esolang
Usage: #{$0} <file> [-u]
Options
\t-u\tAssume the file is already CP437 decoded
Documentation is in README.md"

if __FILE__  == $0 then
    if not ARGV[0] then
        puts $USAGE
        exit 1
    end

    if ARGV[1] == "-u" then
        f = File.new ARGV[0], "r:UTF-8"
    else
        f = File.new ARGV[0], "r:ASCII-8BIT"
    end
    c = f.read
    f.close
    if ARGV[1] != "-u" then
        c = CP437.decode(c.chars.map {|x| x.ord})
    end

    Straw.new(c).run
end
