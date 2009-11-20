#
# Version: CPL 1.0/GPL 2.0/LGPL 2.1
#
# The contents of this file are subject to the Common Public
# License Version 1.0 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.eclipse.org/legal/cpl-v10.html
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# Copyright (C) 2009 Koichiro Ohba <koichiro@meadowy.org>
#
# Alternatively, the contents of this file may be used under the terms of
# either of the GNU General Public License Version 2 or later (the "GPL"),
# or the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
# in which case the provisions of the GPL or the LGPL are applicable instead
# of those above. If you wish to allow use of your version of this file only
# under the terms of either the GPL or the LGPL, and not to allow others to
# use your version of this file under the terms of the CPL, indicate your
# decision by deleting the provisions above and replace them with the notice
# and other provisions required by the GPL or the LGPL. If you do not delete
# the provisions above, a recipient may use your version of this file under
# the terms of any one of the CPL, the GPL or the LGPL.

require 'ffi/readline'

module Readline

  # filename_completion_proc_call
  FILENAME_COMPLETION_PROC = Proc.new do |text|
#    p = FFI::Readline.completion_matches(text) do |word, state|
#      puts word
#      puts word_p.read_string
#      puts state
#      p = FFI::Readline.filename_completion_function(word_p, state)
#      nil
#      p = ::FFI::MemoryPointer.new :pointer
#      p.put_string("hoge")
#      p
#      nil
#    end
#    return nil if p.null?

    r = Dir.glob(text + "*")
    p r
    r
  end
  # username_completion_proc_call
  USERNAME_COMPLETION_PROC = Proc.new do |text|
    []
  end

  # Readline initialize
  private
  FFI::Readline.readline_name = ::FFI::MemoryPointer.from_string("Ruby")
  @completion_proc = nil
  @completion_case_fold = nil

  def self.library_version
    p = FFI::Readline.library_version
    p.null? ? nil : p.read_string
  end

  ATTEMPTED_COMPLETION_PROC = lambda do |text, start, last|
    proc = @completion_proc
    return nil unless proc

    candidates = proc.call(text)
    return nil if candidates.empty?

    result_size = candidates.length + 1
    result = ::FFI::MemoryPointer.new :pointer, result_size
    candidates.each_with_index do |word, i|
      result[i].put_pointer(0, ::FFI::MemoryPointer.from_string(word))
    end
    result[result_size - 1].put_pointer(0, nil)

    result
  end
  FFI::Readline.attempted_completion_function = ATTEMPTED_COMPLETION_PROC

  public
  VERSION = "#{library_version} (FFI wrapper 0.0.1)"

  def readline( prompt = "", history = nil)
    raise TypeError unless STDIN.kind_of? IO
    raise TypeError unless STDOUT.kind_of? IO
    # TODO: STDOUT,STDIN connected in rl_outstream, rl_instream
    # FFI::Readline.instream
    # FFI::Readline.outstream

    r = FFI::Readline.readline(prompt)
    if history
      FFI::Readline.add_history(r)
    end
    r.taint
  end
  module_function :readline

  class History
    include Enumerable

    private
    def initialize
      FFI::Readline.using_history
    end

    def remove_history(index)
      p = FFI::Readline.remove_history(index)
      return nil if p.null?
      entry = FFI::Readline::HistoryEntry.new(p)
      String.new(entry[:line])
    end

    public
    def to_s; "HISTORY" end

    def [](index)
      index += FFI::Readline.history_length if index < 0
      p = FFI::Readline.history_get(FFI::Readline.history_base + index)
      raise IndexError, "invalid index" if p.null?
      entry = FFI::Readline::HistoryEntry.new(p)
      entry[:line].taint
    end

    def []=(index, str)
      index += FFI::Readline.hisrory_length if index < 0
      p = FFI::Readline.replace_history_entry(index, str, nil)
      raise IndexError, "invalid index" if p.null?
      str
    end

    def <<(str)
      raise TypeError unless str.respond_to?(:to_str)

      FFI::Readline.add_history(str.to_str)
      HISTORY
    end
    
    def push(*args)
      for s in args
        raise TypeError unless s.respond_to?(:to_str)
        FFI::Readline.add_history(s.to_str)
      end
      HISTORY
    end
    
    def pop
      l = FFI::Readline.history_length
      return nil if l <= 0
      r = remove_history(l - 1)
      r.taint
    end
    
    def shift
      return nil unless FFI::Readline.history_length > 0
      r = remove_history(0)
      r.taint
    end
    
    def each(&block)
      i = 0
      while i < FFI::Readline.history_length
        p = FFI::Readline.history_get(FFI::Readline.history_base + i)
        break if p.null?
        entry = FFI::Readline::HistoryEntry.new(p)
        block.call(String.new(entry[:line]).taint)
        i += 1
      end
      self
    end
    
    def length
      FFI::Readline.history_length
    end
    alias :size :length
    
    def empty?
      FFI::Readline.history_length == 0 ? true : false
    end

    def delete_at(index)
      l = FFI::Readline.history_length
      index += l if index < 0
      raise IndexError, "invalid index" if (index < 0) or (index > l - 1)
      r  = remove_history(index)
      r.taint
    end
  end
  HISTORY = History.new

  def self.basic_word_break_characters=(str)
    return nil unless str
    FFI::Readline.basic_word_break_characters = ::FFI::MemoryPointer.from_string(str)
  end

  def self.basic_word_break_characters
    p = FFI::Readline.basic_word_break_characters
    p.null? ? nil : p.read_string
  end
  
  def self.completion_append_character=(str)
    if str
      FFI::Readline.completion_append_character = str[0]
    else
      FFI::Readline.completion_append_character = 0
    end
  end

  def self.completion_append_character
    ch = FFI::Readline.completion_append_character
    return nil if ch == 0
    ch.chr
  end

  def self.completer_word_break_characters=(str)
    return nil unless str
    FFI::Readline.completer_word_break_characters = ::FFI::MemoryPointer.from_string(str)
  end

  def self.completer_word_break_characters
    p = FFI::Readline.completer_word_break_characters
    p.null? ? nil : p.read_string
  end

  def self.basic_quote_characters=(str)
    return nil unless str
    FFI::Readline.basic_quote_characters = ::FFI::MemoryPointer.from_string(str)
    HISTORY
  end

  def self.basic_quote_characters
    p = FFI::Readline.basic_quote_characters
    p.null? ? nil : p.read_string
  end

  def self.completer_quote_characters=(str)
    return nil unless str
    FFI::Readline.completer_quote_characters = ::FFI::MemoryPointer.from_string(str)
  end

  def self.completer_quote_characters
    p = FFI::Readline.completer_quote_characters
    p.null? ? nil : p.read_string
  end

  def self.filename_quote_characters=(str)
    return nil unless str
    FFI::Readline.completer_quote_characters = ::FFI::MemoryPointer.from_string(str)
  end

  def self.filename_quote_characters
    p = FFI::Readline.filename_quote_characters
    p.null? ? nil : p.read_string
  end

  def self.completion_proc=(proc)
    raise ArgumentError, "argument must respond to `call'" unless proc.respond_to? :call
    @completion_proc = proc
  end

  def self.completion_proc
    @completion_proc
  end

  def self.completion_case_fold=(bool)
    @completion_case_fold = bool
  end
  
  def self.completion_case_fold
    @completion_case_fold
  end

  def self.vi_editing_mode
    FFI::Readline.editing_mode = 0
    nil
  end

  def self.emacs_editing_mode
    FFI::Readline.editing_mode = 1
    nil
  end

  def self.refresh_line()
    FFI::Readline.refresh_line(0, 0)
  end
end

if __FILE__ == $0
  r = Readline.readline("hoge> ")
  puts ">> " + r
  puts FFI::Readline.editing_mode
  puts Readline.emacs_editing_mode
  puts Readline.completer_quote_characters
  puts Readline.basic_word_break_characters
end
