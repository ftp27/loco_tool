# frozen_string_literal: true

require "paint"

# The Logger class provides utility methods for printing console logs with different formatting.
class Logger
  # Prints a string value.
  #
  # @param string [LocoString] The LocoString object to print.
  def self.string(string)
    puts Formatter.string(string.key, string.value)
  end

  # Prints a string value.
  #
  # @param key [String] The key of the string.
  # @param value [String] The value of the string.
  def self.string_value(key, value)
    puts Formatter.string(key, value)
  end

  # Prints a string and its duplicate.
  #
  # @param string [LocoString] The original string.
  # @param duplicate [LocoString] The duplicate string.
  def self.duplicate(string, duplicate)
    puts "#{Formatter.string(string.key, string.value)} ↔ #{Paint[duplicate.value.to_s, :blue]}"
  end

  # Prints a header.
  #
  # @param text [String] The text to print as the header.
  def self.header(text)
    puts "=" * text.length
    puts text
    puts "=" * text.length
  end

  # Prints a file not found error message.
  #
  # @param file [String] The file that was not found.
  def self.file_not_found(file)
    puts Paint["#{file} not found", :red]
  end

  # Prints the lost keys.
  #
  # @param keys [Array<String>] The lost keys to print.
  def self.lost_keys(keys)
    return if keys.empty?

    puts "Lost keys: #{keys.length}"
    puts keys.map { |key| Paint[key.to_s, :red] }.join(", ")
  end
end

# Provides utility methods for formatting strings
class Formatter
  # Formats a key-value pair as a string with colored output
  #
  # @param key [String] The key to be formatted
  # @param value [String] The value to be formatted
  #
  # @return [String] The formatted key-value pair as a string
  def self.string(key, value)
    "#{Paint[key, :green]} #{Paint[value, :blue]}"
  end
end
