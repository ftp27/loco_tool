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

    desc "sync_ios_auto PATH_A PATH_B BASE_LANG", "Find and sync iOS localization files"
    def sync_ios_auto(path_a, path_b, base_lang)
        target_langs = self.find_lproj(path_a)
        target_langs.each do |target_lang|
            if target_lang == base_lang
                next
            end
            header = "Language #{Paint["#{target_lang}", :green]}"
            puts "=" * header.length
            puts header
            puts "=" * header.length
            self.sync_ios(path_a, path_b, base_lang, target_lang)
        end
    end

    desc "sync PATH_A PATH_B BASE_LANG TARGET_LANG", "Sync iOS localization files"
    def sync_ios(path_a, path_b, base_lang, target_lang)
        file_a_base = "#{path_a}/#{base_lang}.lproj/Localizable.strings"
        file_a_target = "#{path_a}/#{target_lang}.lproj/Localizable.strings"
        file_b_base = "#{path_b}/#{base_lang}.lproj/Localizable.strings"
        file_b_target = "#{path_b}/#{target_lang}.lproj/Localizable.strings"
        if !File.exist?(file_b_target) 
            puts Paint["#{file_b_target} not found", :red]
            return
        end
        self.sync(file_a_base, file_a_target, file_b_base, file_b_target)
    end

    desc "sync FILE_A_BASE FILE_A_TARGET FILE_B_BASE FILE_B_TARGET", "Sync localization files"
    def sync(file_a_base, file_a_target, file_b_base, file_b_target)
        strings_a_file = LocoStrings.load(file_a_target)
        strings_a_target = strings_a_file.read
        strings_b_file = LocoStrings.load(file_b_target)
        strings_b_target = strings_b_file.read

        lost_keys = self.missing(file_b_base, file_b_target)
        keys_b_to_a = self.make_keys_dict(file_a_base, file_b_base)

        strings_a_target.each do |key, string_a_target|
            key_b = keys_b_to_a[key]
            if !key_b
                next
            end
            if lost_keys.include?(key_b)
                strings_b_file.update(key_b, string_a_target.value)
                lost_keys.delete(key_b)
                puts Paint["#{key_b}", :green] + " " + Paint["#{string_a_target.value}", :blue]
            end
        end

        puts "Lost keys:" if lost_keys.length > 0
        puts lost_keys.map { |key| Paint["#{key}", :red] }.join(", ")

        strings_b_file.write
    end

    desc "missing FILE_A FILE_B", "Find missing keys in localization files"
    def missing(file_a, file_b)
        strings_a = LocoStrings.load(file_a).read
        strings_b = LocoStrings.load(file_b).read

        lost_keys = []
        strings_a.each do |key, string_a|
            if !strings_b.has_key?(key)
                lost_keys << key
            end
        end
        return lost_keys
    end

    desc "keys BASE_FILE TARGET_FILE", "Find keys between localization files"
    def make_keys_dict(base_file, target_file)
        strings_base = LocoStrings.load(base_file).read
        strings_target = LocoStrings.load(target_file).read
        keys = {}
        strings_base.each do |key_base, string_base|
            strings_target.each do |key_target, string_target|
                if string_base.value == string_target.value
                    keys[key_base] = key_target
                end
            end
        end
        return keys
    end

    desc "find PATH", "Find localization files"
    def find_lproj(path)
        lproj_files = Dir.glob("#{path}/*.lproj").select { |f| File.directory? f }
        return lproj_files.map { |f| File.basename(f, ".lproj") }
    end
end
    
Locotool.start(ARGV)
