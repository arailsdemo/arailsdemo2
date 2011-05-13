class ViewTemplate
  include Mongoid::Document

  field :name
  field :prefix
  field :source
  field :partial,  :type => Boolean, :default => false
  field :formats,  :default => "html"
  field :locale,   :default => "en"
  field :handlers, :default => "haml"

  validates :name, :prefix, :source, :presence => true
  validates_uniqueness_of :name, :scope => :prefix, :message => :duplicate

  before_validation :strip_whitespace

  after_save do
    MongoidResolver.instance.clear_cache
  end

  private

  def strip_whitespace
    self.name.strip!
    self.prefix.strip!
  end
end
