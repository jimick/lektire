# encoding: utf-8

class StudentsController < ApplicationController
  def index
    @students = current_school.students
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.create_with_key(params[:student], params[:key])

    if @student.valid?
      redirect_to new_game_path, notice: "Uspješno ste se registrirali."
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :new
    end
  end

  def show
    @student = Student.find(params[:id])
  end

  def destroy
    student = current_school.students.destroy(params[:id])
    redirect_to students_path, notice: "Učenik \"#{student.full_name}\" je uspješno izbrisan."
  end
end