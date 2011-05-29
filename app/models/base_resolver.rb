class BaseResolver < ActionView::Resolver
  attr_accessor :document

  def find_templates(name, prefix, partial, details)
    search_args = { :name => name, :prefix => prefix,
                    :partial => partial, :status => "production" }
    self.document = ViewTemplate.where(search_args).any_in(details).first

    return [] unless self.document
    [ActionView::Template.new(*template_args)]
  end

  def template_args
    args = [document.source]
    args << "view_template-#{document.id}-#{document.prefix}-#{document.name}"
    args << ::ActionView::Template.registered_template_handler(document.handlers)
    args << { :format => Mime[document.formats], :virtual_path => virtual_path }
  end

  def virtual_path
    virtual = "#{document.prefix.to_s}/"
    virtual << "_" if document.partial
    virtual << document.name.to_s
  end
end
