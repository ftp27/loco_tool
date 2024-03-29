# LocoTool

[![Gem Version](https://badge.fury.io/rb/loco_tool.svg)](https://badge.fury.io/rb/loco_tool)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

LocoTool is a command-line tool for localization tasks, designed to simplify the management and validation of localization strings in iOS and Android projects.

## Features

- Find duplicate keys between localization files.
- Sync and move missing strings between files.
- Validate and verify localization files.
- Transform localization files between different formats.
- Identify oversized strings in localization files.

### TODO

- Convert strings between different formats.

## Installation

LocoTool can be installed via RubyGems. Make sure you have Ruby installed on your system, then run the following command:

```
$ gem install loco_tool
```

## Usage

LocoTool provides various commands to perform localization tasks. Here are some examples:

### Find Duplicate Keys

```
$ locotool duplicates [FILE_A] [FILE_B]
```

This command compares two localization files and identifies duplicate keys between them.

### Sync Localization Files

```
$ locotool sync [PATH_A] [PATH_B] [BASE_LANG] [TARGET_LANG]
```

This command synchronizes localization files between two directories (`PATH_A` and `PATH_B`). It compares the base language (`BASE_LANG`) with the target language (`TARGET_LANG`) and moves missing strings from the base file to the target file.

### Sync iOS Localization Files Automatically

```
$ locotool sync_ios_auto [PATH_A] [PATH_B] [BASE_LANG]
```

This command automatically finds and syncs iOS localization files in the specified directories (`PATH_A` and `PATH_B`). It iterates over the available target languages, excluding the base language (`BASE_LANG`), and performs the synchronization operation.

### Transform Localization Files

```
$ locotool export [PATH_A] [PATH_B] -s [SORT] -c [CASE]
```

This command transforms localization files from `PATH_A` to `PATH_B`. It can sort the keys in the output files (`SORT`) and change the case of the keys (`CASE`). The `SORT` parameter can be set to `asc`, or `desc`. The `CASE` parameter can be set to `lower`, or `upper`. Both parameters are optional.

### Identify Oversized Strings

```
$ locotool oversize [PATH_A] [TARGET_LANG] [GAP]
```

This command identifies oversized strings in the localization files in the specified directory (`PATH_A`). It compares the length of the strings in the target language (`TARGET_LANG`) with the base language and reports the strings that exceed the specified gap (`GAP`).

## Examples

Export Localization file from iOS to Android

```sh
$ locotool export en.lproj/Localizable.strings en.xml -s asc -c lower
```

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request on the [LocoTool GitHub repository](https://github.com/ftp27/loco_tool).

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
