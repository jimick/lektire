# encoding: utf-8
require "spec_helper_full"

describe "Questions" do
  before(:all) {
    @school = create(:school)
    @other_school = create(:other_school)
    @quiz = create(:quiz, school: @school)
    @question_in_quiz       = create(:question, content: "In quiz", school: @school, quizzes: [@quiz])
    @question_not_in_quiz   = create(:question, content: "Not in quiz", school: @school)
    @question_not_in_school = create(:question, content: "Not in school", school: @other_school)
  }
  before(:each) { login(:school, attributes_for(:school)) }

  they "can be accessed on quiz" do
    visit quizzes_path
    within(".actions .dropdown-menu") { all("a").first.click }
    current_path.should eq quiz_questions_path(@quiz)
  end

  they "can be accessed in the navigation" do
    within(".nav") { click_on "Pitanja" }
    current_path.should eq school_questions_path(@school)
  end

  they "can be accessed elsewhere" do
    visit school_questions_path(@school)
    click_on "Pitanja drugih škola"
    current_path.should eq questions_path
    click_on "Vaša pitanja"
    current_path.should eq school_questions_path(@school)
  end

  context "inside a quiz" do
    before(:each) { visit quiz_questions_path(@quiz) }

    it "shows only questions in that quiz" do
      page.should have_content(@question_in_quiz.content)
      page.should_not have_content(@question_not_in_quiz.content)
      page.should_not have_content(@question_not_in_school.content)
    end
  end

  context "inside the logged in school" do
    before(:each) { visit school_questions_path(@school) }

    it "shows all questions from the logged in school" do
      page.should have_content(@question_in_quiz.content)
      page.should have_content(@question_not_in_quiz.content)
      page.should_not have_content(@question_not_in_school.content)
    end
  end

  context "inside other schools" do
    before(:each) { visit questions_path(@quiz) }

    it "shows all questions expect the ones from the logged in school" do
      page.should_not have_content(@question_in_quiz.content)
      page.should_not have_content(@question_not_in_quiz.content)
      page.should have_content(@question_not_in_school.content)
    end
  end

  after(:all) { [@school, @other_school].each(&:destroy) }
end
