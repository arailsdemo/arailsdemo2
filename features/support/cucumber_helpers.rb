module CucumberHelpers
  def t
    return @t if @t
    I18n.backend.load_translations
    @t = Hashie::Mash.new(I18n.backend.instance_eval{translations}).en
  end
end

World(CucumberHelpers)
