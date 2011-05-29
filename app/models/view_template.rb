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
