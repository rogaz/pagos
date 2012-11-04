require 'test_helper'

class PatientChargesControllerTest < ActionController::TestCase
  setup do
    @patient_charge = patient_charges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:patient_charges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create patient_charge" do
    assert_difference('PatientCharge.count') do
      post :create, patient_charge: { amount: @patient_charge.amount, date: @patient_charge.date, description: @patient_charge.description, liquidated: @patient_charge.liquidated, patient_id: @patient_charge.patient_id }
    end

    assert_redirected_to patient_charge_path(assigns(:patient_charge))
  end

  test "should show patient_charge" do
    get :show, id: @patient_charge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @patient_charge
    assert_response :success
  end

  test "should update patient_charge" do
    put :update, id: @patient_charge, patient_charge: { amount: @patient_charge.amount, date: @patient_charge.date, description: @patient_charge.description, liquidated: @patient_charge.liquidated, patient_id: @patient_charge.patient_id }
    assert_redirected_to patient_charge_path(assigns(:patient_charge))
  end

  test "should destroy patient_charge" do
    assert_difference('PatientCharge.count', -1) do
      delete :destroy, id: @patient_charge
    end

    assert_redirected_to patient_charges_path
  end
end
