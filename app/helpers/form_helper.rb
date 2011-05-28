module FormHelper
  def select_options_from_t(translation_key)
    I18n.t(translation_key).map { |k,v| [v, k] }.sort_by { |el| el[0] }
  end
end
