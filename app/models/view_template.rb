class ViewTemplate
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps

  max_versions 3

  field :name
  field :prefix
  field :source
  field :partial,  :type => Boolean, :default => false
  field :formats,  :default => "html"
  field :locale,   :default => "en"
  field :handlers, :default => "haml"
  field :status,   :default => "production"

  validates :name, :prefix, :source, :presence => true
  validate :haml_syntax_is_valid
  validate :uniqueness_of_template

  before_validation :strip_whitespace

  after_save do
    MongoidResolver.instance.clear_cache
  end

  class << self
    def preview(template_id)
      template = find(template_id)
      view = ActionView::Base.new(PreviewResolver.for_document(template), {})
      view.render(render_options(template))
    end

    def render_options(template_or_layout)
      if template_or_layout.prefix == 'layouts'
        template = associated_template_for(template_or_layout)
        if template
          layout_path = path_for(template_or_layout)
          template_path = path_for(template)
        else
          template_path = path_for(template_or_layout)
        end
      else
        template_path = path_for(template_or_layout)
        layout = associated_layout_for(template_or_layout)
        layout_path = path_for(layout) if layout
      end

      opts = layout_path ? { :layout => layout_path } : {}
      opts.merge!({:template => template_path})
    end

    private

    def associated_layout_for(template)
      where(:prefix => 'layouts', :name => template.prefix).first ||
      where(:prefix => 'layouts', :name => 'application').first
    end

    def associated_template_for(layout)
      return where(:prefix.nin => ["layouts"]).first if layout.name == 'application'
      where(:prefix => layout.name).first
    end

    def path_for(template)
      "#{template.prefix}/#{template.name}"
    end
  end

  def revert(_version)
    return nil unless _version
    selected = versions.where(:version => _version.to_i).first
    new_attributes = selected.attributes
    new_attributes.delete(:_id)
    new_attributes.delete(:version)
    update_attributes(new_attributes)

    coll = db.collection("view_templates")
    doc = coll.find("_id" => self.id).first
    doc["versions"].delete_if {|v| v["_id"] == selected.id }
    coll.update({"_id" => self.id}, {"$set" => {"versions" => doc["versions"]}})

    selected
  end

  def successful_update?(params)
    revert(params[:revert]) || update_attributes(params[:view_template])
  end

  private

  def strip_whitespace
    self.name.strip!
    self.prefix.strip!
  end

  def haml_syntax_is_valid
    begin
      Haml::Engine.new(source).render
    rescue Exception => e
      unless e.is_a? LocalJumpError
        errors.add(:source, :haml, :exception => e)
      end
    end if handlers == "haml"
  end

   def uniqueness_of_template
    return if status == "development"
    absent = self.class.where(
      :name => name, :prefix => prefix,
      :status => "production", :_id.nin => [self._id]
    ).empty?

    errors.add(:name, :duplicate) unless absent
  end
end
