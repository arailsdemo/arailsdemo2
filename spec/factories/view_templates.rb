# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :view_template do
      name "MyString"
      prefix "MyString"
      partial false
      source "MyText"
      locale "MyString"
      formats "MyString"
      handlers "MyString"
    end
end