# frozen_string_literal: true

require "fileutils"
require "sassc"

puts "Building SASS files"
input_file = "./assets/sass/application.scss"
output_file = "./public/application.css"

scss = File.read(input_file)
css = SassC::Engine.new(scss, style: :compressed).render

File.write(output_file, css)

puts "Copying fonts"
FileUtils.copy_entry "./assets/fonts", "./public/fonts"

puts "Copying images"
FileUtils.copy_entry "./assets/images", "./public/images"

puts "Copying robots.txt"
FileUtils.copy_entry "./assets/robots.txt", "./public/robots.txt"
