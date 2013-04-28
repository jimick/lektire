require "spec_helper"

describe QuizPlay do
  before do
    @it = QuizPlay.new({})
    @it.start!(quiz_snapshot, students)
  end

  let(:quiz_snapshot) do
    stub.tap do |quiz_snapshot|
      quiz_snapshot.stub(:id)        { 0 }
      quiz_snapshot.stub(:quiz)      { stub(:id => 0) }
      quiz_snapshot.stub(:questions) { 10.times.map { |i| stub(:id => i) } }
    end
  end

  let(:students) do
    3.times.map { |i| stub(:id => i) }
  end

  context "actions" do
    describe "#start!" do
      it "stores the begin time" do
        expect(@it.begin_time).to be_present
      end
    end

    describe "#save_answer!" do
      it "saves the answer" do
        answers = @it.questions.map { [true, false].sample }
        answers.each do |answer|
          @it.save_answer!(answer)
          @it.next_question!
        end
        expect(@it.questions.map { |q| q[:answer] }).to eq answers
      end
    end

    describe "#next_question!" do
      it "changes the student" do
        expect do
          @it.next_question!
        end.to change { @it.current_student[:number] }.by 1
      end

      it "goes to the next question" do
        expect do
          @it.next_question!
        end.to change { @it.current_question[:number] }.by 1
      end
    end

    describe "#next_student!" do
      it "goes to the next student" do
        expect { @it.next_student! }.to \
          change { @it.current_student[:number] }.from(1).to(2)
        expect { @it.next_student! }.to \
          change { @it.current_student[:number] }.from(2).to(3)
        expect { @it.next_student! }.to \
          change { @it.current_student[:number] }.from(3).to(1)
      end
    end

    describe "#finish!" do
      it "stores the end time" do
        @it.finish!
        expect(@it.end_time).to be_present
      end
    end
  end

  context "reading" do
    describe "#current_question" do
      it "returns the current question" do
        expect(@it.current_question).to eq({number: 1, id: 0, answer: nil})
        @it.next_question!
        expect(@it.current_question).to eq({number: 2, id: 1, answer: nil})
      end
    end

    describe "#current_student" do
      it "returns the current student" do
        expect(@it.current_student).to eq({number: 1, id: 0})
        @it.next_student!
        expect(@it.current_student).to eq({number: 2, id: 1})
      end
    end

    describe "#quiz" do
      it "returns the quiz" do
        expect(@it.quiz).to eq({id: 0})
      end
    end

    describe "#quiz_snapshot" do
      it "returns the quiz snapshot" do
        expect(@it.quiz_snapshot).to eq({id: 0})
      end
    end

    describe "#begin_time" do
      it "returns a time object" do
        expect(@it.begin_time).to be_a(Time)
      end
    end

    describe "#end_time" do
      it "returns a time object" do
        @it.finish!
        expect(@it.end_time).to be_a(Time)
      end
    end

    describe "#to_h" do
      it "returns a hash of information" do
        @it.finish!
        expect(@it.to_h).to be_a(Hash)
      end
    end

    describe "#interrupted?" do
      it "returns true if the last question wasn't answered" do
        until @it.current_question == @it.questions.last
          @it.save_answer!(true)
          @it.next_question!
        end
        @it.finish!
        expect(@it.interrupted?).to be_true
      end

      it "returns false if the last question was answered" do
        @it.save_answer!(true)
        until @it.over?
          @it.next_question!
          @it.save_answer!(true)
        end
        @it.finish!
        expect(@it.interrupted?).to be_false
      end
    end

    describe "#over?" do
      it "checks if the quiz play is over" do
        until @it.current_question == @it.questions.last
          @it.save_answer!(true)
          @it.next_question!
        end
        expect(@it.over?).to be_false
        @it.save_answer!(true)
        expect(@it.over?).to be_true
      end
    end
  end
end
