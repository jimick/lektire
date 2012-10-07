require "spec_helper_lite"
require_relative "../../../app/models/question/text_question"

describe TextQuestion do
  before(:each) { @it = build(:text_question) }
  subject { @it }

  use_nulldb

  it { should be_a(Question) }

  its(:points) { should eq 5 }

  describe "#has_answer?" do
    it "is case insensitive" do
      @it.correct_answer?(@it.answer.downcase).should be_true
    end

    it "ignores a potential period at the end" do
      @it.correct_answer?(@it.answer + ".").should be_true
    end

    it "is false on incorrect answer" do
      @it.correct_answer?("Not the right answer").should be_false
    end
  end

  describe "validations" do
    it "can't have blank answer" do
      @it.answer = nil
      @it.should_not be_valid
    end
  end
end