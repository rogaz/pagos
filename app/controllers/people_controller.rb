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
        flash[:notice] = "El estudiante #{@person.name} tiene cargos" if student_tiene_cargos
        flash[:notice] = "El paciente '#{@person.name}' tiene cargos" if patient_tiene_cargos
        format.html { redirect_to people_url }
      end
    end
  end
end
