# frozen_string_literal: true

require "fileutils"
require "sassc"

def build_sass(source, destination)
  scss = File.read(source)
  css = SassC::Engine.new(scss, style: :compressed).render

  File.write(destination, css)
end

puts "Building Application SASS files"
build_sass "./assets/sass/application.scss", "./public/application.css"

puts "Building Print SASS files"
build_sass "./assets/sass/printable.scss", "./public/printable.css"

puts "Copying fonts"
FileUtils.copy_entry "./assets/fonts", "./public/fonts"

puts "Copying images"
FileUtils.copy_entry "./assets/images", "./public/images"

puts "Compiling and copying JavaScript"
unless File.directory?("./public/javascript")
  FileUtils.mkdir("./public/javascript")
end
`./node_modules/.bin/babel #{File.realpath("./assets/javascript")} --out-dir #{File.realpath("./public/javascript")}`

puts "Copying robots.txt"
if ENV["DEPLOY_APPNAME"] && ENV["DEPLOY_APPNAME"].end_with?("production")
  FileUtils.copy_entry "./assets/robots_public.txt", "./public/robots.txt"
else
  FileUtils.copy_entry "./assets/robots.txt", "./public/robots.txt"
end
