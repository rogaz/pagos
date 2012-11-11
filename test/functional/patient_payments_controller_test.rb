require 'test_helper'

class PatientPaymentsControllerTest < ActionController::TestCase
  setup do
    @patient_payment = patient_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:patient_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create patient_payment" do
    assert_difference('PatientPayment.count') do
      post :create, patient_payment: { amount: @patient_payment.amount, date: @patient_payment.date, patient_charge_id: @patient_payment.patient_charge_id }
    end

    assert_redirected_to patient_payment_path(assigns(:patient_payment))
  end

  test "should show patient_payment" do
    get :show, id: @patient_payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @patient_payment
    assert_response :success
  end

  test "should update patient_payment" do
    put :update, id: @patient_payment, patient_payment: { amount: @patient_payment.amount, date: @patient_payment.date, patient_charge_id: @patient_payment.patient_charge_id }
    assert_redirected_to patient_payment_path(assigns(:patient_payment))
  end

  test "should destroy patient_payment" do
    assert_difference('PatientPayment.count', -1) do
      delete :destroy, id: @patient_payment
    end

    assert_redirected_to patient_payments_path
  end
end
