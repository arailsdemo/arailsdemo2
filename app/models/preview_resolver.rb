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
      super
    end
  end
end
