require "thor"
require "loco_strings"
require "paint"

class Locotool < Thor
    desc "dublicates FILE_A FILE_B", "Find duplicate keys in localization files"
    def dublicates(file_a, file_b)
        strings_a = LocoStrings.load(file_a).read
        strings_b = LocoStrings.load(file_b).read

        strings_a.each do |key, string_a|
            if strings_b.has_key?(key)
                string_b = strings_b[key]
                if string_a.value == string_b.value
                    puts Paint["#{key}", :green] + " " + Paint["#{string_a.value}", :blue]
                else
                    puts Paint["#{key}", :red] + " " + Paint["#{string_a.value}", :blue] + " ↔ " + Paint["#{string_b.value}", :blue]
                end
            end
        end
    end
end
    
Locotool.start(ARGV)
