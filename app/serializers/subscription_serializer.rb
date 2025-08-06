class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :billing_cycle, :start_date, 
             :payment_method, :is_active, :service_url, :notes,
             :next_payment_date, :days_until_payment
             
  belongs_to :category
  
  def next_payment_date
    object.next_payment_date
  end
  
  def days_until_payment
    object.days_until_payment
  end
end