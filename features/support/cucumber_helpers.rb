require 'hashie'

module CucumberHelpers
  def submit_form(instance_or_sym, form_values)

    if Symbol === instance_or_sym || String === instance_or_sym
      model = instance_or_sym
      path = send(:"new_#{model}_path")
    else
      model = instance_or_sym.class.name.underscore
      path = send(:"edit_#{model}_path", instance_or_sym)
    end

    visit path  # visit the form page
    model_translations = t.send(model)
    form_values.each_pair do |field, value|
      case value
      when String
        fill_in model_translations.send(field), :with => value # textfield
      when Symbol  # checkbox, radio
        send value, model_translations.send(field) # eg. "check('A Checkbox')"
      when Hash  # select lists
        send value.keys.first, value.values.first, :from => model_translations.send(field) # eg. "select('Option', :from => 'Select Box')"
      else
        raise "Yo no comprende"
      end
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
