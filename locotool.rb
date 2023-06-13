require "thor"
require "loco_strings"
require './lib/logger'
require './lib/helper'

class Locotool < Thor
    desc "dublicates FILE_A FILE_B", "Find duplicate keys in localization files"
    def dublicates(file_a, file_b)
        strings_a = LocoStrings.load(file_a).read
        strings_b = LocoStrings.load(file_b).read

        strings_a.each do |key, string_a|
            if strings_b.has_key?(key)
                string_b = strings_b[key]
                if string_a.value == string_b.value
                    Logger.string(string_a)
                else
                    Logger.dublicate(string_a, string_b)
                end
            end
        end
    end

    desc "sync_ios_auto PATH_A PATH_B BASE_LANG", "Find and sync iOS localization files"
    def sync_ios_auto(path_a, path_b, base_lang)
        target_langs = Helper.find_lproj(path_a)
        target_langs.each do |target_lang|
            if target_lang == base_lang
                next
            end
            Logger.header("Language #{Paint["#{target_lang}", :green]}")
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
            Logger.file_not_found(file_b_target)
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

        lost_keys = Helper.find_missing(file_b_base, file_b_target)
        keys_b_to_a = Helper.make_keys_dict(file_a_base, file_b_base)

        strings_a_target.each do |key, string_a_target|
            key_b = keys_b_to_a[key]
            if !key_b
                next
            end
            if lost_keys.include?(key_b)
                strings_b_file.update(key_b, string_a_target.value)
                lost_keys.delete(key_b)
                Logger.string_value(key_b, string_a_target.value)
            end
        end

        Logger.lost_keys(lost_keys)

        strings_b_file.write
    end
end
    
Locotool.start(ARGV)
