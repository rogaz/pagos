class PatientChargesController < ApplicationController
  # GET /patient_charges
  # GET /patient_charges.json
  def index
    if params[:category_id].nil?
      @patient_charges = PatientCharge.all
    else
      @patient_charges = Array.new
      @category = Category.find params[:category_id]
      unless @category.patients.nil?
        @category.patients.each do |patient|
          unless patient.patient_charges.nil?
            patient.patient_charges.each do |patient_charge|
              @patient_charges << patient_charge
            end
          end
        end
      end
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patient_charges }
    end
  end

  # GET /patient_charges/1
  # GET /patient_charges/1.json
  def show
    @patient_charge = PatientCharge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient_charge }
    end
  end

  # GET /patient_charges/new
  # GET /patient_charges/new.json
  def new
    @patient_charge = PatientCharge.new
    @patient = Patient.find params[:patient_id] unless params[:patient_id].nil?
    @horarios = Array.new
    i = 0
    while i < 13
      if i < 3
      @horarios << "#{i+8}:00 a.m. - #{i+9}:00 a.m."
      elsif i == 4
        @horarios << "#{i+8}:00 a.m. - #{i-3}:00 p.m."
      elsif i > 4
        @horarios << "#{i-4}:00 p.m. - #{i-3}:00 p.m."
      end
      i += 1
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient_charge }
    end
  end

  # GET /patient_charges/1/edit
  def edit
    @patient_charge = PatientCharge.find(params[:id])
  end

  # POST /patient_charges
  # POST /patient_charges.json
  def create
    @patient_charge = PatientCharge.new(params[:patient_charge])
    @patient = Patient.find params[:patient_charge][:patient_id]
    @patient_charge.amount = @patient.cost
    @patient_charge.liquidated = "no"
    @patient_charge.date = Time.now-7.hour
    @patient_charge.patient_id = @patient.id

    respond_to do |format|
      if @patient_charge.save
        format.html { redirect_to @patient_charge, notice: 'Patient charge was successfully created.' }
        format.json { render json: @patient_charge, status: :created, location: @patient_charge }
      else
        format.html { render action: "new" }
        format.json { render json: @patient_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_charges/1
  # PUT /patient_charges/1.json
  def update
    @patient_charge = PatientCharge.find(params[:id])

    respond_to do |format|
      if @patient_charge.update_attributes(params[:patient_charge])
        format.html { redirect_to @patient_charge, notice: 'Patient charge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_charges/1
  # DELETE /patient_charges/1.json
  def destroy
    @patient_charge = PatientCharge.find(params[:id])
    @patient_charge.destroy

    respond_to do |format|
      format.html { redirect_to patient_charges_url }
      format.json { head :no_content }
    end
  end
end
