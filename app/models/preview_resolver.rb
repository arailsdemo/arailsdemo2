class PreviewResolver < BaseResolver
  attr_accessor :target

  def self.for_document(document)
    resolver = self.new
    resolver.target = document
    resolver
  end

  def find_templates(name, prefix, partial, details)
    if target.name == name && target.prefix == prefix
      self.document = target
      [ActionView::Template.new(*template_args)]
    else
      templates = super
      return templates unless templates.empty?
      super(name, prefix, partial, details, false)
    end
  end
end
