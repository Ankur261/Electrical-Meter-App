[33mcommit 3e21d6ffa8951a682a7db23e8e0fd73d10851b6c[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m)[m
Author: ankur261 <ankuragrawal911@gmail.com>
Date:   Sat Sep 2 11:49:38 2023 +0530

    Version 0.1

[1mdiff --git a/.gitignore b/.gitignore[m
[1mnew file mode 100644[m
[1mindex 0000000..3d0a24e[m
[1m--- /dev/null[m
[1m+++ b/.gitignore[m
[36m@@ -0,0 +1,46 @@[m
[32m+[m[32m# Miscellaneous[m
[32m+[m[32m*.class[m
[32m+[m[32m*.log[m
[32m+[m[32m*.pyc[m
[32m+[m[32m*.swp[m
[32m+[m[32m.DS_Store[m
[32m+[m[32m.atom/[m
[32m+[m[32m.buildlog/[m
[32m+[m[32m.history[m
[32m+[m[32m.svn/[m
[32m+[m[32mmigrate_working_dir/[m
[32m+[m
[32m+[m[32m# IntelliJ related[m
[32m+[m[32m*.iml[m
[32m+[m[32m*.ipr[m
[32m+[m[32m*.iws[m
[32m+[m[32m.idea/[m
[32m+[m
[32m+[m[32m# The .vscode folder contains launch configuration and tasks you configure in[m
[32m+[m[32m# VS Code which you may wish to be included in version control, so this line[m
[32m+[m[32m# is commented out by default.[m
[32m+[m[32m#.vscode/[m
[32m+[m
[32m+[m[32m# Flutter/Dart/Pub related[m
[32m+[m[32m**/doc/api/[m
[32m+[m[32m**/ios/Flutter/.last_build_id[m
[32m+[m[32m.dart_tool/[m
[32m+[m[32m.flutter-plugins[m
[32m+[m[32m.flutter-plugins-dependencies[m
[32m+[m[32m.packages[m
[32m+[m[32m.pub-cache/[m
[32m+[m[32m.pub/[m
[32m+[m[32m/build/[m
[32m+[m
[32m+[m[32m# Symbolication related[m
[32m+[m[32mapp.*.symbols[m
[32m+[m
[32m+[m[32m# Obfuscation related[m
[32m+[m[32mapp.*.map.json[m
[32m+[m
[32m+[m[32m# Android Studio will place build artifacts here[m
[32m+[m[32m/android/app/debug[m
[32m+[m[32m/android/app/profile[m
[32m+[m[32m/android/app/release[m
[32m+[m
[32m+[m[32m.fake[m
\ No newline at end of file[m
[1mdiff --git a/.metadata b/.metadata[m
[1mnew file mode 100644[m
[1mindex 0000000..3fdf532[m
[1m--- /dev/null[m
[1m+++ b/.metadata[m
[36m@@ -0,0 +1,45 @@[m
[32m+[m[32m# This file tracks properties of this Flutter project.[m
[32m+[m[32m# Used by Flutter tool to assess capabilities and perform upgrades etc.[m
[32m+[m[32m#[m
[32m+[m[32m# This file should be version controlled.[m
[32m+[m
[32m+[m[32mversion:[m
[32m+[m[32m  revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m  channel: stable[m
[32m+[m
[32m+[m[32mproject_type: app[m
[32m+[m
[32m+[m[32m# Tracks metadata for the flutter migrate command[m
[32m+[m[32mmigration:[m
[32m+[m[32m  platforms:[m
[32m+[m[32m    - platform: root[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m    - platform: android[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m    - platform: ios[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m    - platform: linux[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m    - platform: macos[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m    - platform: web[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m    - platform: windows[m
[32m+[m[32m      create_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m[32m      base_revision: b8f7f1f9869bb2d116aa6a70dbeac61000b52849[m
[32m+[m
[32m+[m[32m  # User provided section[m
[32m+[m
[32m+[m[32m  # List of Local paths (relative to this file) that should be[m
[32m+[m[32m  # ignored by the migrate tool.[m
[32m+[m[32m  #[m
[32m+[m[32m  # Files that are not part of the templates will be ignored by default.[m
[32m+[m[32m  unmanaged_files:[m
[32m+[m[32m    - 'lib/main.dart'[m
[32m+[m[32m    - 'ios/Runner.xcodeproj/project.pbxproj'[m
[1mdiff --git a/README.md b/README.md[m
[1mnew file mode 100644[m
[1mindex 0000000..17c4166[m
[1m--- /dev/null[m
[1m+++ b/README.md[m
[36m@@ -0,0 +1,16 @@[m
[32m+[m[32m# test_app2[m
[32m+[m
[32m+[m[32mA new Flutter project.[m
[32m+[m
[32m+[m[32m## Getting Started[m
[32m+[m
[32m+[m[32mThis project is a starting point for a Flutter application.[m
[32m+[m
[32m+[m[32mA few resources to get you started if this is your first Flutter project:[m
[32m+[m
[32m+[m[32m- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)[m
[32m+[m[32m- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)[m
[32m+[m
[32m+[m[32mFor help getting started with Flutter development, view the[m
[32m+[m[32m[online documentation](https://docs.flutter.dev/), which offers tutorials,[m
[32m+[m[32msamples, guidance on mobile development, and a full API reference.[m
[1mdiff --git a/analysis_options.yaml b/analysis_options.yaml[m
[1mnew file mode 100644[m
[1mindex 0000000..61b6c4d[m
[1m--- /dev/null[m
[1m+++ b/analysis_options.yaml[m
[36m@@ -0,0 +1,29 @@[m
[32m+[m[32m# This file configures the analyzer, which statically analyzes Dart code to[m
[32m+[m[32m# check for errors, warnings, and lints.[m
[32m+[m[32m#[m
[32m+[m[32m# The issues identified by the analyzer are surfaced in the UI of Dart-enabled[m
[32m+[m[32m# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be[m
[32m+[m[32m# invoked from the command line by running `flutter analyze`.[m
[32m+[m
[32m+[m[32m# The following line activates a set of recommended lints for Flutter apps,[m
[32m+[m[32m# packages, and plugins designed to encourage good coding practices.[m
[32m+[m[32minclude: package:flutter_lints/flutter.yaml[m
[32m+[m
[32m+[m[32mlinter:[m
[32m+[m[32m  # The lint rules applied to this project can be customized in the[m
[32m+[m[32m  # section below to disable rules from the `package:flutter_lints/flutter.yaml`[m
[32m+[m[32m  # included above or to enable additional rules. A list of all available lints[m
[32m+[m[32m  # and their documentation is published at[m
[32m+[m[32m  # https://dart-lang.github.io/linter/lints/index.html.[m
[32m+[m[32m  #[m
[32m+[m[32m  # Instead of disabling a lint rule for the entire project in the[m
[32m+[m[32m  # section below, it can also be suppressed for a single line of code[m
[32m+[m[32m  # or a specific dart file by using the `// ignore: name_of_lint` and[m
[32m+[m[32m  # `// ignore_for_file: name_of_lint` syntax on the line or in the file[m
[32m+[m[32m  # producing the lint.[m
[32m+[m[32m  rules:[m
[32m+[m[32m    # avoid_print: false  # Uncomment to disable the `avoid_print` rule[m
[32m+[m[32m    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule[m
[32m+[m
[32m+[m[32m# Additional information about this file can be found at[m
[32m+[m[32m# https://dart.dev/guides/language/analysis-options[m
[1mdiff --git a/android/.gitignore b/android/.gitignore[m
[1mnew file mode 100644[m
[1mindex 0000000..6f56801[m
[1m--- /dev/null[m
[1m+++ b/android/.gitignore[m
[36m@@ -0,0 +1,13 @@[m
[32m+[m[32mgradle-wrapper.jar[m
[32m+[m[32m/.gradle[m
[32m+[m[32m/captures/[m
[32m+[m[32m/gradlew[m
[32m+[m[32m/gradlew.bat[m
[32m+[m[32m/local.properties[m
[32m+[m[32mGeneratedPluginRegistrant.java[m
[32m+[m
[32m+[m[32m# Remember to never publicly share your keystore.[m
[32m+[m[32m# See https://flutter.dev/docs/deployment/android#reference-the-keystore-from-the-app[m
[32m+[m[32mkey.properties[m
[32m+[m[32m**/*.keystore[m
[32m+[m[32m**/*.jks[m
[1mdiff --git a/