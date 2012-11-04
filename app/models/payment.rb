class Payment < ActiveRecord::Base
  attr_accessible :amount, :charge_id, :date
end
