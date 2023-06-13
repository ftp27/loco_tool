require "paint"

# The Logger class provides utility methods for printing console logs with different formatting.
class Logger
    # Prints a string value.
    #
    # @param string [LocoString] The LocoString object to print.
    def self.string(string)
        puts Paint["#{string.key}", :green] + " " + Paint["#{string.value}", :blue]
    end
  
    # Prints a string value.
    #
    # @param key [String] The key of the string.
    # @param value [String] The value of the string.
    def self.string_value(key, value)
        puts Paint["#{key}", :green] + " " + Paint["#{value}", :blue]
    end
  
    # Prints a string and its duplicate.
    #
    # @param string [LocoString] The original string.
    # @param duplicate [LocoString] The duplicate string.
    def self.duplicate(string, duplicate)
        puts Paint["#{string.key}", :red] + " " + Paint["#{string.value}", :blue] + " ↔ " + Paint["#{duplicate.value}", :blue]
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
        puts keys.map { |key| Paint["#{key}", :red] }.join(", ")
    end
end  