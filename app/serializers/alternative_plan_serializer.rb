class AlternativePlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :billing_cycle, :features, 
             :plan_type, :company, :service_url
             
  belongs_to :category
end