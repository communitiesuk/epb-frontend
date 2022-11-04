require "yaml"

desc "Get and flatten translation keys"

def flatten_keys(hash, prefix = "")
  keys = []
  hash.each_key do |key|
    if hash[key].is_a? Hash
      current_prefix = prefix + "#{key}."
      keys << flatten_keys(hash[key], current_prefix)
    else
      keys << "#{prefix}#{key}"
    end
  end
  prefix == "" ? keys.flatten : keys
end

welsh = YAML.safe_load(File.open(File.expand_path("locales/cy.yml")))
english = YAML.safe_load(File.open(File.expand_path("locales/en.yml")))

welsh_keys = flatten_keys(welsh[welsh.keys.first])
english_keys = flatten_keys(english[english.keys.first])

desc "Identifies missing Welsh translations"

task :identify_missing_welsh_translations do
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

desc "Identifies missing English translations"

task :identify_missing_english_translations do
  missing = welsh_keys - english_keys
  if missing.any?
    puts "Missing from English:"
    missing.each do |key|
      array = %w[cy] + key.split(".")

      puts "#{key}: #{welsh.dig(*array)}"
    end
  else
    puts "Nothing missing from #{file}."
  end
end

desc "Iterate to convert dot-notation with quoted values to YAML"

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

desc "Convert dot-notation with quoted values to YAML"

task :convert_to_yaml do
  input_file = File.read(ENV["input_file"])

  output_object = {}

  input_file.split("\n").each do |row|
    key_value = row.split(":", 2)
    key = key_value[0]
    value = key_value[1].strip[1..]

    iterate!(key, value, output_object)
  end

  File.write(ENV["output_file"], output_object.to_yaml)
end
