FactoryBot.define do
  factory :invoice do
    customer # Associates the invoice with a customer
    status { :pending } # Defaults to the first enum value
  end
end
