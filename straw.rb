#!/usr/bin/env ruby

require "readline"

class Straw
    def initialize(code)
        @code = code.chars
        @st = [[""], ["Hello, World!"]]
        @sp = 0
        @vars = {}
    end

    attr_reader :st
    attr_reader :sp
    attr_reader :vars

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
            @st[@sp].push Readline.readline
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
Usage: #{$0} <file>
Documentation is in README.md"

if __FILE__  == $0 then
    if not ARGV[0] then
        puts $USAGE
        exit 0
    end

    f = File.new ARGV[0], "r:UTF-8"
    c = f.read
    f.close

    Straw.new(c).run
end
