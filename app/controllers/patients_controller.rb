class PatientsController < ApplicationController
  # GET /patients
  # GET /patients.json
  def index
    @patients = Patient.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.json
  def new
    @patient = Patient.new
    @patient.build_person

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.json
  def create
    @person = Person.new(params[:patient][:person_attributes])

    respond_to do |format|
      if @person.save
        @patient = Patient.new(params[:patient].except(:person_attributes))
        @patient.person_id = @person.id
        category = Category.find_by_name "CENAAC"
        @patient.category_id = category.id
        if @patient.save
          format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
          format.json { render json: @patient, status: :created, location: @patient }
        else
          @patient.build_person
          @patient.person = @person
          @person.destroy
          format.html { render action: "new" }
          format.json { render json: @patient.errors, status: :unprocessable_entity }
        end
      else
        @patient = Patient.new
        @patient.build_person
        @patient.person = @person
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patients/1
  # PUT /patients/1.json
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient].except(:person_attributes))
        format.html { redirect_to people_url, notice: 'Patient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end
end
