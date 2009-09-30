require 'ffi'

module FFI::Readline
  extend FFI::Library
  CONVENTION = FFI::Platform.windows? ? :stdcall : :default

  paths = %w[
    /usr/local/lib/libreadline.dylib
    /opt/local/lib/libreadline.dylib
    /usr/lib/libreadline.dylib
    /usr/lib/libreadline.so
    /lib/libreadline.so
    /lib/libreadline.so.5
  ]
  paths << File.expand_path(File.dirname(__FILE__) + "/../../ext/readline.dll")
  paths.find do |path|
    if File.exist?(path)
      begin
        ffi_lib path
        true
      rescue LoadError
        false
      end
    end
  end
  ffi_convention(CONVENTION)

  attach_function :readline, [:string], :string
  attach_function :filename_completion_function, :rl_filename_completion_function, [:pointer, :int], :pointer
  attach_function :username_completion_function, :rl_username_completion_function, [:string, :int], :string
  callback :compentry_function, [:pointer, :int], :string
  attach_function :completion_matches, :rl_completion_matches, [:string, :compentry_function], :pointer
  attach_function :refresh_line, :rl_refresh_line, [:int, :int], :int

  attach_variable :library_version, :rl_library_version, :pointer
  attach_variable :readline_name, :rl_readline_name, :pointer
  attach_variable :editing_mode, :rl_editing_mode, :int
  attach_variable :insert_mode, :rl_insert_mode, :int
  attach_variable :completion_entry_function, :rl_completion_entry_function, :pointer
  attach_variable :completion_append_character, :rl_completion_append_character, :int
  attach_variable :completer_quote_characters, :rl_completer_quote_characters, :pointer
  attach_variable :filename_quote_characters, :rl_filename_quote_characters, :pointer
  attach_variable :basic_quote_characters, :rl_basic_quote_characters, :pointer
  attach_variable :basic_word_break_characters, :rl_basic_word_break_characters, :pointer
  attach_variable :completer_word_break_characters, :rl_completer_word_break_characters, :pointer
  callback :completion_function, [:string, :int, :int], :pointer
  attach_variable :attempted_completion_function, :rl_attempted_completion_function, :completion_function
  attach_variable :outstream, :rl_outstream, :pointer
  attach_variable :instream, :rl_instream, :pointer

  # History
  class HistoryEntry < FFI::Struct
    layout :line, :string, 0,
           :timstamp, :string, 4,
           :data, :pointer, 8
  end

  attach_function :using_history, [], :void
  attach_function :add_history, [:string], :void
#  attach_function :add_history_time, [:string], :void
  attach_function :clear_history, [], :void
  attach_function :remove_history, [:int], :pointer
  attach_function :history_get, [:int], :pointer
  attach_function :replace_history_entry, [:int, :string, :pointer], :pointer

  attach_variable :history_base, :int
  attach_variable :history_length, :int
  attach_variable :history_max_entries, :int
end


