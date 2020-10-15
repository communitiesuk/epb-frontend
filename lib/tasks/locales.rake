require "yaml"

desc "Get missing strings in Welsh"

def flatten_keys(hash, prefix = "")
  keys = []
  hash.keys.each do |key|
    if hash[key].is_a? Hash
      current_prefix = prefix + "#{key}."
      keys << flatten_keys(hash[key], current_prefix)
    else
      keys << "#{prefix}#{key}"
    end
  end
  prefix == "" ? keys.flatten : keys
end

task :identify_missing_welsh_translations do
  welsh = YAML.load(File.open(File.expand_path("locales/cy.yml")))
  english = YAML.load(File.open(File.expand_path("locales/en.yml")))

  welsh_keys = flatten_keys(welsh[welsh.keys.first])
  english_keys = flatten_keys(english[english.keys.first])

  missing = english_keys - welsh_keys
  if missing.any?
    puts "Missing from Welsh:"
    missing.each do |key|
      array = %w[en] + key.split(".")

      puts "#{key}: #{english.dig(*array)}"
    end
  else
    puts "Nothing missing from #{file}."
  end
end

desc "Convert dot-notation with quoted values to YAML"

def iterate!(key, value, hashicorp)
  keys = key.split(".", 2)

  if keys[1].nil?
    hashicorp[keys[0]] = value
  else
    unless hashicorp.key?(keys[0])
      hashicorp[keys[0]] = {}
    end
    iterate!(keys[1], value, hashicorp[keys[0]])
  end
end

task :convert_to_yaml do
  input_file = File.read(ENV["input_file"])

  output_object = {}

  input_file.split("\n").each do |row|
    key_value = row.split(":", 2)
    key = key_value[0]
    value = key_value[1].strip[1..-1]

    iterate!(key, value, output_object)
  end

  File.write(ENV["output_file"], output_object.to_yaml)
end
