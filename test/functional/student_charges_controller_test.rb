require 'test_helper'

class StudentChargesControllerTest < ActionController::TestCase
  setup do
    @student_charge = student_charges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_charges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_charge" do
    assert_difference('StudentCharge.count') do
      post :create, student_charge: { amount: @student_charge.amount, date: @student_charge.date, description: @student_charge.description, liquidated: @student_charge.liquidated, student_id: @student_charge.student_id }
    end

    assert_redirected_to student_charge_path(assigns(:student_charge))
  end

  test "should show student_charge" do
    get :show, id: @student_charge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_charge
    assert_response :success
  end

  test "should update student_charge" do
    put :update, id: @student_charge, student_charge: { amount: @student_charge.amount, date: @student_charge.date, description: @student_charge.description, liquidated: @student_charge.liquidated, student_id: @student_charge.student_id }
    assert_redirected_to student_charge_path(assigns(:student_charge))
  end

  test "should destroy student_charge" do
    assert_difference('StudentCharge.count', -1) do
      delete :destroy, id: @student_charge
    end

    assert_redirected_to student_charges_path
  end
end
