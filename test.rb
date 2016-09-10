#!/usr/bin/env ruby

# Unit tests

require_relative "straw"
require_relative "cp437"

require "test/unit"

def srun(code)
    Straw.new(code).run.cst
end

class TestCP437 < Test::Unit::TestCase
    def test_decode
        assert_equal CP437.decode([0xE0, 0x62]), "αb"
    end

    def test_encode
        assert_equal CP437.encode("αb"), [0xE0, 0x62]
    end
end

class TestStraw < Test::Unit::TestCase
    def test_straw_escape
        assert_equal straw_escape("(Hello`)"), "`(Hello```)"
    end

    def test_stackinit
        assert_equal srun(""), [""]
        assert_equal srun("~"), ["Hello, World!"]
    end

    def test_string
        assert_equal srun("(Hello)"), ["", "Hello"]
        assert_equal srun("(Hello(World))"), ["", "Hello(World)"]
        assert_equal srun("(Hello`(World)"), ["", "Hello(World"]
        assert_equal srun("(Hello``World)"), ["", "Hello`World"]
    end

    def test_concat
        assert_equal srun("(He)(llo)+"), ["", "Hello"]
    end

    def test_repeat
        assert_equal srun("(Hello)(ABCD)*"), ["", "HelloHelloHelloHello"]
    end

    def test_eval
        assert_equal srun("((Hi))&"), ["", "Hi"]
    end

    def test_stackop
        assert_equal srun(":"), ["", ""]
        assert_equal srun(";"), []
        assert_equal srun("A,"), ["A", ""]
    end

    def test_unarith
        assert_equal srun("(000000)(00)\xF6"), ["", "000"]
        assert_equal srun("(00000):+(000)\xF6"), ["", "000"]
    end

    def test_stacktoggle
        assert_equal srun("1~"), ["Hello, World!"]
        assert_equal srun("1~~"), ["", "1"]
        assert_equal srun("1~-"), ["Hello, World!", "1"]
        assert_equal srun("1~2~-"), ["", "1", "2"]
    end

    def test_regex
        assert_equal srun("(Hello)(l(.)$)(R\\1)/"), ["", "HelRo"]
    end

    def test_random
        Kernel.srand 1
        assert_equal srun("AB?/"), ["", "A", "B"]
        Kernel.srand 10
        assert_equal srun("AB?,"), ["", "B", "A"]
    end

    def test_conditional
        assert_equal srun("AA="), ["", "Y"]
        assert_equal srun("AB="), ["", ""]

        assert_equal srun("AB!"), ["", "Y"]
        assert_equal srun("AA!"), ["", ""]
        
        assert_equal srun("(Hello)(l{2,})."), ["", "Y"]
        assert_equal srun("(Helo)(l{2,})."), ["", ""]
    end

    def test_ifelse
        assert_equal srun("((Yes))((No))Y'"), ["", "Yes"]
        assert_equal srun("((Yes))((No))()'"), ["", "No"]
    end

    def test_ht
        assert_equal srun("~{"), ["H"]
        assert_equal srun("~}"), ["ello, World!"]
        assert_equal srun("~:{}+"), ["Hello, World!"]
    end

    def test_reverse
        assert_equal srun('~"'), ["!dlroW ,olleH"]
    end

    def test_var
        assert_equal srun("~A]"), []
        assert_equal srun("~A]A["), ["Hello, World!"]
    end

    def test_decimal
        assert_equal srun("(5)#"), ["", "00000"]
        assert_equal srun("(00000)$"), ["", "5"]
    end

    def test_enc
        assert_equal srun("(Hello)%"), ["", "(Hello)"]
    end

    def test_mask
        assert_equal srun("(Hello)(10110)@"), ["", "Hll"]
    end

    def test_td
        assert_equal srun("~5#\xF4"), [", World!"]
        assert_equal srun("~5#\xF5"), ["Hello"]
    end

    def test_split
        assert_equal srun("(Hello World) |"), ["", "(Hello)(World)"]
        assert_equal srun("(Hello World) |&"), ["", "Hello", "World"]
    end

    def test_depth
        assert_equal srun("-\xAD"), ["", "Hello, World!", "00"]
    end

    def test_getel
        assert_equal srun("(A)(B)(C)(0)\xF3"), ["", "A", "B", "C", "A"]
        assert_equal srun("(A)(B)(C)(0)\xF2"), ["", "A", "B", "C", "C"]
    end
end
