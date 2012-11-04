class StudentsController < ApplicationController
  # GET /students
  # GET /students.json
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new
    @student.build_person

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
    unless @student.person.patient.nil?
      @patient = @student.person.patient
    end
  end

  # POST /students
  # POST /students.json
  def create
    @person = Person.new(params[:student][:person_attributes])

    respond_to do |format|
      if @person.save
        @student = Student.new(params[:student].except(:person_attributes))
        @student.person_id = @person.id
        if @student.save
          if params[:cenaac] == "true"
            if params[:cenaac_cost][/(^[\d]+$)/]
              @patient = Patient.new
              @patient.person_id = @person.id
              category = Category.find_by_name "CENAAC"
              @patient.category_id = category.id
              @patient.cost = params[:cenaac_cost]
              @patient.save
            else
              @student.destroy
              @person.destroy
              @student = Student.new
              @student.build_person
              @student.person = @person
              flash[:error] = "El costo de CENAAC no debe contener letras"
              format.html { redirect_to new_student_path }
            end
          end
          flash[:notice] = 'Student was successfully created.'
          format.html { redirect_to @person }
          format.json { render json: @person, status: :created, location: @student }
        else
          @student.build_person
          @student.person = @person
          @person.destroy
          format.html { render action: "new" }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      else
        @student = Student.new
        @student.build_person
        @student.person = @person
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])
    if @student.person.patient.nil?
      if params[:cenaac] == "true"
        @patient = Patient.new
        @patient.person_id = @student.person_id
        category = Category.find_by_name "CENAAC"
        @patient.category_id = category.id
        @patient.cost = params[:cenaac_cost]
        @patient.save
      end
    else
      if !params[:cenaac]
        @patient = Patient.find_by_person_id @student.person_id
        @patient.destroy
      else
        @patient = Patient.find_by_person_id @student.person_id
        @patient.cost = params[:cenaac_cost]
        @patient.save
      end
    end

    respond_to do |format|
      if @student.update_attributes(params[:student].except(:person_attributes))
        format.html { redirect_to people_path, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end
end
