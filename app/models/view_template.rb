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

  after_save do
    MongoidResolver.instance.clear_cache
  end
end
