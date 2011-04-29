class PagesController < ApplicationController
  prepend_view_path MongoidResolver.instance

  def home
    @world = "World!"
  end
end
