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

  validates :name, :prefix, :source, :presence => true
  validates_uniqueness_of :name, :scope => :prefix, :message => :duplicate
  validate :haml_syntax_is_valid

  before_validation :strip_whitespace

  after_save do
    MongoidResolver.instance.clear_cache
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
end
