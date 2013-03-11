###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def stuff
#     "stuff"
#   end
# end

data.apps.each do |app|

  proxy "/#{app.smallname}/index.html", "/app.html", :locals => { :app => app }, :ignore => true

  if app.versions
    app.versions.each.with_index do |version, index|
      proxy "/#{app.smallname}/#{version.number}.html", "/release_notes.html", locals: { versions: app.versions.take(index+1) }, ignore: true
    end

    proxy "/#{app.smallname}/appcast.xml", "/appcast.xml", locals: { app: app }, ignore: true
  end

  if app.my_store
    proxy "/#{app.smallname}/store.html", "/store.html", :locals => { :app => app }, :ignore => true
  end

end

set :css_dir, 'etc/css'

set :js_dir, 'etc/js'

set :images_dir, 'etc/img'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end
