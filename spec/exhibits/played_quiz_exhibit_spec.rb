require "spec_helper"

describe PlayedQuizExhibit do
  before do
    @it = PlayedQuizExhibit.new(played_quiz)
  end

  let(:played_quiz) do
    stub.tap do |played_quiz|
      played_quiz.stub(:questions) { Array.new(4, stub) }
      played_quiz.stub(:students) { Array.new(2, stub) }
      played_quiz.stub(:question_answers) { [true, true, false, true] }
    end
  end

  it "has results" do
    @it.results
  end

  it "has scores" do
    expect(@it.scores).to eq [1, 2]
  end

  it "has score percentages" do
    expect(@it.score_percentages).to eq [50, 100]
  end

  it "has student numbers" do
    expect(@it.student_numbers).to eq [1, 2]
  end

  it "has ranks" do
    @it.ranks.each do |rank|
      expect(rank).to be_present
    end
  end

  it "has total score" do
    expect(@it.total_score).to eq 2
  end
end
