#!/usr/bin/env ruby

# Unit tests

require_relative "straw"
require "test/unit"

def srun(code)
    Straw.new(code).run.cst
end

class TestStraw < Test::Unit::TestCase
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

    def test_var
        assert_equal srun("~A]"), []
        assert_equal srun("~A]A["), ["Hello, World!"]
    end
end
