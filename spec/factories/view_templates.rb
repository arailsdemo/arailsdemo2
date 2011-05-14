FactoryGirl.define do
  factory :view_template do
    name "home"
    prefix "pages"
    source "Mongoid view"
  end

  factory :home_page_view_template, :parent => :view_template do
  end

  factory :duplicate_view_template, :parent => :view_template do
    name "  home  \n"
    prefix "\n  pages\n\r"
  end

  factory :invalid_haml_view_template, :parent => :view_template do
    source "= this_method_no_exist"
  end
end
