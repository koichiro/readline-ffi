require 'test/unit'
require File.dirname(__FILE__) + "/../lib/readline"

class TestReadline < Test::Unit::TestCase

  def test_completion_proc_error
    assert_raise(ArgumentError, "Need ArgumentError exception") { Readline.completion_proc = nil }
  end

  def test_library_version
    assert_match(/\(FFI wrapper \d\.\d\.\d\)/, Readline::VERSION)
  end

  def test_implimented_methods
    assert_nil(Readline.completer_word_break_characters)
    assert(Readline.completer_word_break_characters = "test")
    assert_equal("\"'", Readline.basic_quote_characters)
    assert(Readline.basic_quote_characters = "test")
    assert_nil(Readline.completer_quote_characters)
    assert(Readline.completer_quote_characters = "test")
    assert_nil(Readline.filename_quote_characters)
    assert(Readline.filename_quote_characters = "test")
    assert_equal(" \t\n\"\\'`@$><=;|&{(", Readline.basic_word_break_characters)
    assert(Readline.basic_word_break_characters = "test")
    assert_equal(" ", Readline.completion_append_character)
    assert(Readline.completion_append_character = "_")
    assert_nil(Readline.vi_editing_mode)
    assert_nil(Readline.emacs_editing_mode)
    assert_nil(Readline.completion_proc)
    assert_equal(0, Readline.refresh_line)
  end
  
  def test_history
    his = Readline::HISTORY
    assert_equal("HISTORY", his.to_s)
    assert_raise(IndexError, "need index error") { his[0] }
    
    assert(his.empty?)
    assert_equal("HISTORY", (his << "hist1").to_s)
    assert_equal(false, his.empty?)
    assert_equal("hist1", his.pop)

    assert_equal("HISTORY", (his << "hist1").to_s)
    assert_equal("HISTORY", (his << "hist2").to_s)
    assert_equal("hist1", his.shift)
    assert_equal("hist2", his.shift)

    assert_equal("HISTORY", (his << "hist1").to_s)
    assert_equal("hist1", his.delete_at(0))
    assert(his.empty?)
  end
  
#   def test_completion
#     words = %w[foo foobar foobaz]
#     Readline.completion_proc = proc do |word|
#       words.grep(/\A#{Regexp.quote word}/)
#     end
#     while buf = Readline.readline("> ")
#       p buf
#     end
#   end

#  def test_completion2
#    Readline.completion_proc = Readline::FILENAME_COMPLETION_PROC
#    while buf = Readline.readline("> ")
#      p buf
#    end
#  end
end
