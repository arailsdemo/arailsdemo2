module CucumberHelpers
  def submit_form(model, form_values)
    visit send(:"new_#{model}_path")  # visit the form page
    model_translations = t.send(model)
    form_values.each_pair do |field, value|
      fill_in model_translations.send(field), :with => value
    end
    click_button model_translations.form.save  # submit the form
  end

  def t
    return @t if @t
    I18n.backend.load_translations
    @t = Hashie::Mash.new(I18n.backend.instance_eval{translations}).en
  end
end

World(CucumberHelpers)
