class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(params[:person])
    correct_esc_cost = true
    correct_cenaac_cost = true
    escuelaocenaac = true
    categoria_seleccionada = true

    escuelaocenaac = false if params[:escuela].nil? and params[:cenaac].nil?

    if params[:escuela] == "true"
      categoria_seleccionada = false if params[:category][:id] == ""
      correct_esc_cost = false if !params[:escuela_cost][/(^[\d]+$)/]
    end

    if params[:cenaac] == "true"
      correct_cenaac_cost = false if !params[:cenaac_cost][/(^[\d]+$)/]
    end

    respond_to do |format|
      if correct_esc_cost and escuelaocenaac and categoria_seleccionada and correct_cenaac_cost
        @person.save
        if params[:escuela] == "true"
          @student = Student.new
          @student.cost = params[:escuela_cost]
          @student.person_id = @person.id
          @student.category_id = params[:category][:id]
          @student.save
        end
        if params[:cenaac] == "true"
          @patient = Patient.new
          @patient.cost = params[:cenaac_cost]
          @patient.person_id = @person.id
          category = Category.find_by_name "CENAAC"
          @patient.category_id = category.id
          @patient.save
        end
        flash[:notice] = 'Persona guardada correctamente.'
        format.html { redirect_to @person }
        format.json { render json: @person, status: :created, location: @person }
      else
        flash[:notice] = "La persona debe estar en CENAAC o escuela" if !escuelaocenaac
        flash[:notice] = "Debe seleccionar una categoria de escuela" if !categoria_seleccionada
        flash[:notice] = "El campo de costo de colegiatura no debe estar vacio y solo acepta numeros" if !correct_esc_cost
        flash[:notice] = "El campo de costo de sesion no debe estar vacio y solo acepta numeros" if !correct_cenaac_cost
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])
    correct_esc_cost = true
    correct_cenaac_cost = true
    escuelaocenaac = true
    categoria_seleccionada = true
    student_tiene_cargos = false
    patient_tiene_cargos = false

    escuelaocenaac = false if params[:escuela].nil? and params[:cenaac].nil?

    if params[:escuela].nil?
      unless @person.student.nil?
        @student = Student.find_by_person_id @person.id
        if @student.student_charges.count > 0
          student_tiene_cargos = true
        else
          @student.destroy
        end
      end
    else
      if @person.student.nil?
        categoria_seleccionada = false if params[:category][:id] == ""
        correct_esc_cost = false if !params[:escuela_cost][/(^[\d]+$)/]
        if categoria_seleccionada and correct_esc_cost
          @student = Student.new
          @student.person_id = @person.id
          @student.cost = params[:escuela_cost]
          @student.category_id = params[:category][:id]
          @student.save
        end
      else
        categoria_seleccionada = false if params[:category][:id] == ""
        correct_esc_cost = false if !params[:escuela_cost][/(^[\d]+$)/]
        if categoria_seleccionada and correct_esc_cost
          @student = Student.find_by_person_id @person.id
          @student.cost = params[:escuela_cost]
          @student.category_id = params[:category][:id]
          @student.save
        end
      end
    end

    if params[:cenaac].nil?
      unless @person.patient.nil?
        @patient = Patient.find_by_person_id @person.id
        if @patient.patient_charges.count > 0
          patient_tiene_cargos = true
        else
          @patient.destroy
        end
      end
    else
      if @person.patient.nil?
        correct_cenaac_cost = false if !params[:cenaac_cost][/(^[\d]+$)/]
        if correct_cenaac_cost
          @patient = Patient.new
          @patient.person_id = @person.id
          @patient.cost = params[:cenaac_cost]
          category = Category.find_by_name "CENAAC"
          @patient.category_id = category.id
          @patient.save
        end
      else
        correct_cenaac_cost = false if !params[:cenaac_cost][/(^[\d]+$)/]
        if correct_cenaac_cost
          @patient = Patient.find_by_person_id @person.id
          @patient.cost = params[:cenaac_cost]
          category = Category.find_by_name "CENAAC"
          @patient.category_id = category.id
          @patient.save
        end
      end
    end

    respond_to do |format|
      if escuelaocenaac and categoria_seleccionada and correct_esc_cost and correct_cenaac_cost and !student_tiene_cargos and !patient_tiene_cargos
        @person.update_attributes(params[:person])
        flash[:notice] = 'Persona correctamente actualizada'
        format.html { redirect_to @person }#people_path }
        format.json { head :no_content }
      else
        flash[:notice] = "La persona debe estar en CENAAC o escuela" if !escuelaocenaac
        flash[:notice] = "Debe seleccionar una categoria de escuela" if !categoria_seleccionada
        flash[:notice] = "El campo de costo de colegiatura no debe estar vacio y solo acepta numeros" if !correct_esc_cost
        flash[:notice] = "El campo de costo de sesion no debe estar vacio y solo acepta numeros" if !correct_cenaac_cost
        flash[:notice] = "La persona tiene cargos de Colegiatura no liquidados" if student_tiene_cargos
        flash[:notice] = "La persona tiene cargos de Sesion no liquidados" if patient_tiene_cargos

        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    student_tiene_cargos = false
    patient_tiene_cargos = false
    unless @person.student.nil?
      @person.student.student_charges.count > 0 ? student_tiene_cargos = true : student_tiene_cargos = false
    end
    unless @person.patient.nil?
      @person.patient.patient_charges.count > 0 ? patient_tiene_cargos = true : patient_tiene_cargos = false
    end


    respond_to do |format|
      if !student_tiene_cargos and !patient_tiene_cargos
        @person.destroy
        format.html { redirect_to people_url }
        format.json { head :no_content }
      else
        if student_tiene_cargos and !patient_tiene_cargos
          flash[:notice] = "La persona #{@person.name} tiene cargos de Colegiatura"
        elsif !student_tiene_cargos and patient_tiene_cargos
          flash[:notice] = "El persona #{@person.name} tiene cargos de Sesion"
        elsif student_tiene_cargos and patient_tiene_cargos
          flash[:notice] = "El persona #{@person.name} tiene cargos de Colegiatura y de Sesion"
        end
        format.html { redirect_to people_charges_path(@person) }
      end
    end
  end

  def charges
    @person = Person.find params[:id]
    @saldo_general_por_pagar = 0
    
    unless @person.student.nil?
      @student = @person.student
      params[:student_id] = @student.id
      @student_charges = StudentCharge.will_paginate(params[:student_id], params[:student_page])
      unless @student.student_charges.empty?
        @student_charges_all = @student.student_charges.sort_by(&:date)
        oldest_student_charge = @student_charges_all.first.date
        newest_student_charge = @student_charges_all.last.date
        @student_charges_all.each do |student_charge|
          unless student_charge.student_payments.empty?
            paid = 0
            student_charge.student_payments.each do |student_payment|
              paid += student_payment.amount
            end
            @saldo_general_por_pagar += student_charge.amount - paid
          else
            @saldo_general_por_pagar += student_charge.amount
          end
        end
      end
    end

    unless @person.patient.nil?
      @patient = @person.patient
      params[:patient_id] = @patient.id
      @patient_charges = PatientCharge.will_paginate(params[:patient_id], params[:patient_page])
      unless @patient.patient_charges.empty?
        @patient_charges_all = @patient.patient_charges.sort_by(&:date)
        oldest_patient_charge = @patient_charges_all.first.date
        newest_patient_charge = @patient_charges_all.last.date
        @patient_charges_all.each do |patient_charge|
          unless patient_charge.patient_payments.empty?
            paid = 0
            patient_charge.patient_payments.each do |patient_payment|
              paid += patient_payment.amount
            end
            @saldo_general_por_pagar += patient_charge.amount - paid
          else
            @saldo_general_por_pagar += patient_charge.amount
          end
        end
      end
      @patient_charge = PatientCharge.new
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
    end

    unless @person.student.nil? or @person.patient.nil?
      if @person.student.student_charges.empty?
        @oldest = oldest_patient_charge
        @newest = newest_patient_charge
      elsif @person.patient.patient_charges.empty?
        @oldest = oldest_student_charge
        @newest = newest_student_charge
      else
        oldest_patient_charge < oldest_student_charge ? @oldest = oldest_patient_charge : @oldest = oldest_student_charge
        newest_patient_charge > newest_patient_charge ? @newest = newest_patient_charge : @newest = newest_student_charge
      end
    else
      if @person.student.nil?
        @oldest = oldest_patient_charge
        @newest = newest_patient_charge
      elsif @person.patient.nil?
        @oldest = oldest_student_charge
        @newest = newest_student_charge
      end
    end

#    oldest_patient_charge < oldest_student_charge ? @oldest = oldest_patient_charge : @oldest = oldest_student_charge
#    newest_patient_charge > newest_patient_charge ? @newest = newest_patient_charge : @newest = newest_student_charge

    unless @oldest.nil? or @newest.nil?
      @rank_of_months = []
      @oldest = @oldest - (@oldest.day).day + 1.day
      @newest = @newest - (@newest.day).day + 1.day
      iteration_date = @newest
      meses = "Loquesea Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre".split(" ")

      while iteration_date > @oldest
        @rank_of_months << {value: iteration_date.strftime("%m %Y"), date: iteration_date.strftime("#{meses[iteration_date.month]} %Y")}
        iteration_date -= 1.month
      end
    end

  end

  def new_charge_to_patient
    @patient_charge = PatientCharge.new
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

  def charges_by_month
    @person = Person.find params[:id]
    month = params[:month].split
    meses = "Loquesea Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre".split(" ")
#    puts meses[month[0].to_i]
#    puts month[1]
#    sleep 20
    @month = meses[month[0].to_i] + " #{month[1]}"

    unless @person.student.nil?
      @student_charges = @person.student.student_charges.find(:all, :conditions => ['EXTRACT(MONTH from date) = ? AND EXTRACT(YEAR from date) = ?', month[0], month[1]])
    end

    unless @person.patient.nil?
      @patient_charges = @person.patient.patient_charges.find(:all, :conditions => ['EXTRACT(MONTH from date) = ? AND EXTRACT(YEAR from date) = ?', month[0], month[1]])
    end
  end

end
