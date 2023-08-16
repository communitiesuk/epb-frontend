# frozen_string_literal: true

require "fileutils"
require "sassc"

def build_sass(source, destination)
  scss = File.read(source)
  css = SassC::Engine.new(scss, style: :compressed, quiet_deps: true).render

  File.write(destination, css)
end

assets_version_file = File.join(__dir__, "../ASSETS_VERSION")
if ENV["ASSETS_VERSION"].nil? && File.exist?(assets_version_file)
  ENV["ASSETS_VERSION"] = File.read(assets_version_file).chomp
end

def public_target(default)
  unless ENV["ASSETS_VERSION"]
    return default
  end

  default.gsub "/public", "/public/static/#{ENV['ASSETS_VERSION']}"
end

unless File.directory?(public_target("./public"))
  FileUtils.mkdir_p(public_target("./public"))
end

puts "Building Application SASS files"
build_sass "./assets/sass/application.scss", public_target("./public/application.css")

puts "Building Print SASS files"
build_sass "./assets/sass/printable.scss", public_target("./public/printable.css")
build_sass "./assets/sass/print_certificates.scss",
           public_target("./public/print-certificates.css")

puts "Copying fonts"
FileUtils.copy_entry "./assets/fonts", public_target("./public/fonts")

puts "Copying images"
FileUtils.copy_entry "./assets/images", public_target("./public/images")

puts "Compiling and copying JavaScript"
unless File.directory?(public_target("./public/javascript"))
  FileUtils.mkdir(public_target("./public/javascript"))
end
puts "  Copying and renaming GOVUKFrontend js"
`npm run copy-without-comments #{File.realpath("./node_modules/govuk-frontend/govuk/all.js")} #{File.realpath(public_target("./public/javascript"))}/govuk.js`
`./node_modules/.bin/babel #{File.realpath("./assets/javascript")} --ignore #{File.realpath("./assets/javascript/__tests__")} --out-dir #{File.realpath(public_target("./public/javascript"))} --no-comments`

puts "Copying robots.txt"
FileUtils.copy_entry "./assets/robots.txt", "./public/robots.txt"
