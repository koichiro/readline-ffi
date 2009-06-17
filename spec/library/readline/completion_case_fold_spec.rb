require File.dirname(__FILE__) + '/../../spec_helper'

process_is_foreground do

  not_supported_on :ironruby do
    require 'readline'
    describe "Readline.completion_case_fold" do
      it "returns nil" do
        Readline.completion_case_fold.should be_nil
      end
    end

    describe "Readline.completion_case_fold=" do
      it "returns the passed boolean" do
        Readline.completion_case_fold = true
        Readline.completion_case_fold.should == true
        Readline.completion_case_fold = false
        Readline.completion_case_fold.should == false
      end
    end
  end
end
