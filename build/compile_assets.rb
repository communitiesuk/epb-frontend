# frozen_string_literal: true

require "fileutils"
require "sassc-embedded"

def build_sass(source, destination)
  scss = File.read(source)
  # The following deprecation warnings are suppressed because they are known issues from govuk-frontend:
  # mixed-decls: https://github.com/alphagov/govuk-frontend/issues/5143
  # global-builtin: https://github.com/alphagov/govuk-frontend/issues/1791
  # slash-div: https://github.com/alphagov/govuk-frontend/issues/2238
  # import: https://github.com/alphagov/govuk-frontend/issues/1791
  # To add to this list check the deprecations that can be added here https://sass-lang.com/documentation/cli/dart-sass/#silence-deprecation
  css = SassC::Engine.new(scss, style: :compressed, silence_deprecations: %w[mixed-decls global-builtin slash-div import]).render

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

unless File.directory?(public_target("./public/rebrand"))
  FileUtils.mkdir_p(public_target("./public/rebrand"))
end

puts "Building Application SASS files"
build_sass "./assets/sass/application.scss", public_target("./public/application.css")

puts "Building Print SASS files"
build_sass "./assets/sass/printable.scss", public_target("./public/printable.css")
build_sass "./assets/sass/print-certificates.scss",
           public_target("./public/print-certificates.css")

puts "Copying GOVUKFrontend fonts"
FileUtils.copy_entry "./node_modules/govuk-frontend/dist/govuk/assets/fonts", public_target("./public/fonts")

puts "Copying images"
FileUtils.copy_entry "./assets/images", public_target("./public/images")

puts "Copying GOVUKFrontend images"
FileUtils.copy_entry "./node_modules/govuk-frontend/dist/govuk/assets/images", public_target("./public/images")

puts "Copying GOVUKFrontend manifest"
FileUtils.copy_entry "./node_modules/govuk-frontend/dist/govuk/assets/manifest.json", public_target("./public/manifest.json")

puts "Copying GOVUKFrontend rebrand images"
FileUtils.copy_entry "./node_modules/govuk-frontend/dist/govuk/assets/rebrand/images", public_target("./public/rebrand/images")

puts "Copying GOVUKFrontend rebrand manifest"
FileUtils.copy_entry "./node_modules/govuk-frontend/dist/govuk/assets/rebrand/manifest.json", public_target("./public/rebrand/manifest.json")

puts "Compiling and copying JavaScript"
unless File.directory?(public_target("./public/javascript"))
  FileUtils.mkdir(public_target("./public/javascript"))
end
`./node_modules/.bin/babel #{File.realpath("./assets/javascript")} --ignore #{File.realpath("./assets/javascript/__tests__")} --out-dir #{File.realpath(public_target("./public/javascript"))} --no-comments`

puts "  Copying and renaming GOVUKFrontend js"
`npm run copy-without-comments #{File.realpath("./node_modules/govuk-frontend/dist/govuk/govuk-frontend.min.js")} #{File.realpath(public_target("./public/javascript"))}/govuk.js`

puts "Copying robots.txt"
FileUtils.copy_entry "./assets/robots.txt", "./public/robots.txt"
