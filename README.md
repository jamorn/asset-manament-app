# asset_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
```
asset_app
├─ .metadata
├─ README.md
├─ analysis_options.yaml
├─ android
│  ├─ app
│  │  ├─ build.gradle
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ example
│  │     │  │        └─ asset_app
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  ├─ local.properties
│  └─ settings.gradle
├─ firebase.json
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ Generated.xcconfig
│  │  ├─ Release.xcconfig
│  │  └─ flutter_export_environment.sh
│  ├─ Podfile
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
│  │  ├─ GoogleService-Info.plist
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     ├─ WorkspaceSettings.xcsettings
│  │  │     └─ swiftpm
│  │  │        └─ configuration
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ Validation
│  │  └─ temp_photo_validator.dart
│  ├─ configs
│  │  └─ routes.dart
│  ├─ firebase_options.dart
│  ├─ main.dart
│  ├─ providers
│  │  ├─ asset_provider.dart
│  │  ├─ audit_provider.dart
│  │  ├─ auth_provider.dart
│  │  └─ temp_photo_provider.dart
│  ├─ screens
│  │  ├─ dashboard_screen.dart
│  │  ├─ search_screen.dart
│  │  ├─ survey_screen.dart
│  │  └─ temp_photo_accept_dialog.dart
│  ├─ services
│  │  └─ rbac_service.dart
│  ├─ utils
│  │  ├─ image_picker.dart
│  │  └─ temp_photo_utils.dart
│  └─ widgets
│     ├─ asset_class_picker.dart
│     ├─ asset_search_bar.dart
│     ├─ asset_table_list.dart
│     ├─ audit_form.dart
│     ├─ condition_select.dart
│     ├─ cost_center_selector.dart
│     ├─ image_uploader.dart
│     ├─ load_more_list.dart
│     ├─ temp_photo_accept_modal.dart
│     ├─ temp_photo_card.dart
│     ├─ temp_photo_edit_form.dart
│     └─ temp_photo_panel.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ file_selector_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ README.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ README.md
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  ├─ get_directory_page.dart
│  │  │     │  │  │  ├─ get_multiple_directories_page.dart
│  │  │     │  │  │  ├─ home_page.dart
│  │  │     │  │  │  ├─ main.dart
│  │  │     │  │  │  ├─ open_image_page.dart
│  │  │     │  │  │  ├─ open_multiple_images_page.dart
│  │  │     │  │  │  ├─ open_text_page.dart
│  │  │     │  │  │  └─ save_text_page.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  └─ pubspec.yaml
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ file_selector_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     └─ messages.g.dart
│  │  │     │  ├─ linux
│  │  │     │  │  ├─ CMakeLists.txt
│  │  │     │  │  ├─ file_selector_plugin.cc
│  │  │     │  │  ├─ file_selector_plugin_private.h
│  │  │     │  │  ├─ include
│  │  │     │  │  │  └─ file_selector_linux
│  │  │     │  │  │     └─ file_selector_plugin.h
│  │  │     │  │  ├─ messages.g.cc
│  │  │     │  │  ├─ messages.g.h
│  │  │     │  │  └─ test
│  │  │     │  │     ├─ file_selector_plugin_test.cc
│  │  │     │  │     └─ test_main.cc
│  │  │     │  ├─ pigeons
│  │  │     │  │  ├─ copyright.txt
│  │  │     │  │  └─ messages.dart
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  └─ test
│  │  │     │     └─ file_selector_linux_test.dart
│  │  │     ├─ image_picker_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ README.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ README.md
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  └─ pubspec.yaml
│  │  │     │  ├─ lib
│  │  │     │  │  └─ image_picker_linux.dart
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  └─ test
│  │  │     │     ├─ image_picker_linux_test.dart
│  │  │     │     └─ image_picker_linux_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ README.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ README.md
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ LICENSE
│  │  │        ├─ README.md
│  │  │        ├─ example
│  │  │        │  ├─ README.md
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ pubspec.yaml
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           └─ shared_preferences_linux_async_test.dart
│  │  ├─ generated_plugin_registrant.cc
│  │  ├─ generated_plugin_registrant.h
│  │  └─ generated_plugins.cmake
│  └─ runner
│     ├─ CMakeLists.txt
│     ├─ main.cc
│     ├─ my_application.cc
│     └─ my_application.h
├─ macos
│  ├─ Flutter
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  ├─ GeneratedPluginRegistrant.swift
│  │  └─ ephemeral
│  │     ├─ Flutter-Generated.xcconfig
│  │     └─ flutter_export_environment.sh
│  ├─ Podfile
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  └─ AppIcon.appiconset
│  │  │     ├─ Contents.json
│  │  │     ├─ app_icon_1024.png
│  │  │     ├─ app_icon_128.png
│  │  │     ├─ app_icon_16.png
│  │  │     ├─ app_icon_256.png
│  │  │     ├─ app_icon_32.png
│  │  │     ├─ app_icon_512.png
│  │  │     └─ app_icon_64.png
│  │  ├─ Base.lproj
│  │  │  └─ MainMenu.xib
│  │  ├─ Configs
│  │  │  ├─ AppInfo.xcconfig
│  │  │  ├─ Debug.xcconfig
│  │  │  ├─ Release.xcconfig
│  │  │  └─ Warnings.xcconfig
│  │  ├─ DebugProfile.entitlements
│  │  ├─ GoogleService-Info.plist
│  │  ├─ Info.plist
│  │  ├─ MainFlutterWindow.swift
│  │  └─ Release.entitlements
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  └─ xcshareddata
│  │  │     └─ IDEWorkspaceChecks.plist
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     └─ IDEWorkspaceChecks.plist
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ pubspec.lock
├─ pubspec.yaml
├─ test
│  └─ widget_test.dart
├─ web
│  ├─ favicon.png
│  ├─ icons
│  │  ├─ Icon-192.png
│  │  ├─ Icon-512.png
│  │  ├─ Icon-maskable-192.png
│  │  └─ Icon-maskable-512.png
│  ├─ index.html
│  └─ manifest.json
└─ windows
   ├─ CMakeLists.txt
   ├─ flutter
   │  ├─ CMakeLists.txt
   │  ├─ ephemeral
   │  │  └─ .plugin_symlinks
   │  │     ├─ cloud_firestore
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ LICENSE
   │  │     │  ├─ README.md
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ local-config.gradle
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ java
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ firestore
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreException.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreExtension.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreMessageCodec.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestorePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreRegistrar.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreTransactionResult.java
   │  │     │  │  │                       ├─ GeneratedAndroidFirebaseFirestore.java
   │  │     │  │  │                       ├─ streamhandler
   │  │     │  │  │                       │  ├─ DocumentSnapshotsStreamHandler.java
   │  │     │  │  │                       │  ├─ LoadBundleStreamHandler.java
   │  │     │  │  │                       │  ├─ OnTransactionResultListener.java
   │  │     │  │  │                       │  ├─ QuerySnapshotsStreamHandler.java
   │  │     │  │  │                       │  ├─ SnapshotsInSyncStreamHandler.java
   │  │     │  │  │                       │  └─ TransactionStreamHandler.java
   │  │     │  │  │                       └─ utils
   │  │     │  │  │                          ├─ ExceptionConverter.java
   │  │     │  │  │                          ├─ ExpressionHelpers.java
   │  │     │  │  │                          ├─ ExpressionParsers.java
   │  │     │  │  │                          ├─ PigeonParser.java
   │  │     │  │  │                          ├─ PipelineParser.java
   │  │     │  │  │                          ├─ PipelineStageHandlers.java
   │  │     │  │  │                          └─ ServerTimestampBehaviorConverter.java
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ dartpad
   │  │     │  │  ├─ dartpad_metadata.yaml
   │  │     │  │  └─ lib
   │  │     │  │     └─ main.dart
   │  │     │  ├─ example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebase
   │  │     │  │  │  │     │  │              └─ firestore
   │  │     │  │  │  │     │  │                 └─ example
   │  │     │  │  │  │     │  │                    └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ firebase.json
   │  │     │  │  ├─ integration_test
   │  │     │  │  │  ├─ collection_reference_e2e.dart
   │  │     │  │  │  ├─ document_change_e2e.dart
   │  │     │  │  │  ├─ document_reference_e2e.dart
   │  │     │  │  │  ├─ e2e_test.dart
   │  │     │  │  │  ├─ field_value_e2e.dart
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  ├─ firebase_options_secondary.dart
   │  │     │  │  │  ├─ geo_point_e2e.dart
   │  │     │  │  │  ├─ instance_e2e.dart
   │  │     │  │  │  ├─ load_bundle_e2e.dart
   │  │     │  │  │  ├─ query_e2e.dart
   │  │     │  │  │  ├─ second_database.dart
   │  │     │  │  │  ├─ settings_e2e.dart
   │  │     │  │  │  ├─ snapshot_metadata_e2e.dart
   │  │     │  │  │  ├─ timestamp_e2e.dart
   │  │     │  │  │  ├─ transaction_e2e.dart
   │  │     │  │  │  ├─ vector_value_e2e.dart
   │  │     │  │  │  ├─ web_snapshot_listeners.dart
   │  │     │  │  │  └─ write_batch_e2e.dart
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  ├─ AppIcon.appiconset
   │  │     │  │  │  │  │  │  ├─ Contents.json
   │  │     │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  │  └─ LaunchImage.imageset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ LaunchImage.png
   │  │     │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │     │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │     │  │  │  │  │     └─ README.md
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ Runner-Bridging-Header.h
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     ├─ WorkspaceSettings.xcsettings
   │  │     │  │  │  │  │     └─ swiftpm
   │  │     │  │  │  │  │        └─ configuration
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │     ├─ WorkspaceSettings.xcsettings
   │  │     │  │  │  │     └─ swiftpm
   │  │     │  │  │  │        └─ configuration
   │  │     │  │  │  └─ firebase_app_id_file.json
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     └─ app_icon_64.png
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     └─ swiftpm
   │  │     │  │  │  │  │        └─ configuration
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │     └─ swiftpm
   │  │     │  │  │  │        └─ configuration
   │  │     │  │  │  ├─ RunnerTests
   │  │     │  │  │  │  └─ RunnerTests.swift
   │  │     │  │  │  └─ firebase_app_id_file.json
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ test_driver
   │  │     │  │  │  └─ integration_test.dart
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  ├─ manifest.json
   │  │     │  │  │  └─ wasm_index.html
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ cloud_firestore
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ cloud_firestore
   │  │     │  │  │        ├─ FLTDocumentSnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreExtension.m
   │  │     │  │  │        ├─ FLTFirebaseFirestorePlugin.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreReader.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreUtils.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreWriter.m
   │  │     │  │  │        ├─ FLTFirestoreClientLanguage.mm
   │  │     │  │  │        ├─ FLTLoadBundleStreamHandler.m
   │  │     │  │  │        ├─ FLTPipelineParser.m
   │  │     │  │  │        ├─ FLTQuerySnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTSnapshotsInSyncStreamHandler.m
   │  │     │  │  │        ├─ FLTTransactionStreamHandler.m
   │  │     │  │  │        ├─ FirestoreMessages.g.m
   │  │     │  │  │        ├─ FirestorePigeonParser.m
   │  │     │  │  │        ├─ Resources
   │  │     │  │  │        └─ include
   │  │     │  │  │           └─ cloud_firestore
   │  │     │  │  │              ├─ Private
   │  │     │  │  │              │  ├─ FLTDocumentSnapshotStreamHandler.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreExtension.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreReader.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreUtils.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreWriter.h
   │  │     │  │  │              │  ├─ FLTLoadBundleStreamHandler.h
   │  │     │  │  │              │  ├─ FLTPipelineParser.h
   │  │     │  │  │              │  ├─ FLTQuerySnapshotStreamHandler.h
   │  │     │  │  │              │  ├─ FLTSnapshotsInSyncStreamHandler.h
   │  │     │  │  │              │  ├─ FLTTransactionStreamHandler.h
   │  │     │  │  │              │  └─ FirestorePigeonParser.h
   │  │     │  │  │              └─ Public
   │  │     │  │  │                 ├─ CustomPigeonHeaderFirestore.h
   │  │     │  │  │                 ├─ FLTFirebaseFirestorePlugin.h
   │  │     │  │  │                 └─ FirestoreMessages.g.h
   │  │     │  │  └─ cloud_firestore.podspec
   │  │     │  ├─ lib
   │  │     │  │  ├─ cloud_firestore.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ aggregate_query.dart
   │  │     │  │     ├─ aggregate_query_snapshot.dart
   │  │     │  │     ├─ collection_reference.dart
   │  │     │  │     ├─ document_change.dart
   │  │     │  │     ├─ document_reference.dart
   │  │     │  │     ├─ document_snapshot.dart
   │  │     │  │     ├─ field_value.dart
   │  │     │  │     ├─ filters.dart
   │  │     │  │     ├─ firestore.dart
   │  │     │  │     ├─ load_bundle_task.dart
   │  │     │  │     ├─ load_bundle_task_snapshot.dart
   │  │     │  │     ├─ persistent_cache_index_manager.dart
   │  │     │  │     ├─ pipeline.dart
   │  │     │  │     ├─ pipeline_aggregate.dart
   │  │     │  │     ├─ pipeline_distance.dart
   │  │     │  │     ├─ pipeline_execute_options.dart
   │  │     │  │     ├─ pipeline_expression.dart
   │  │     │  │     ├─ pipeline_ordering.dart
   │  │     │  │     ├─ pipeline_sample.dart
   │  │     │  │     ├─ pipeline_search.dart
   │  │     │  │     ├─ pipeline_snapshot.dart
   │  │     │  │     ├─ pipeline_source.dart
   │  │     │  │     ├─ pipeline_stage.dart
   │  │     │  │     ├─ query.dart
   │  │     │  │     ├─ query_document_snapshot.dart
   │  │     │  │     ├─ query_snapshot.dart
   │  │     │  │     ├─ snapshot_metadata.dart
   │  │     │  │     ├─ transaction.dart
   │  │     │  │     ├─ utils
   │  │     │  │     │  └─ codec_utility.dart
   │  │     │  │     └─ write_batch.dart
   │  │     │  ├─ macos
   │  │     │  │  ├─ cloud_firestore
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ cloud_firestore
   │  │     │  │  │        ├─ FLTDocumentSnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreExtension.m
   │  │     │  │  │        ├─ FLTFirebaseFirestorePlugin.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreReader.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreUtils.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreWriter.m
   │  │     │  │  │        ├─ FLTLoadBundleStreamHandler.m
   │  │     │  │  │        ├─ FLTPipelineParser.m
   │  │     │  │  │        ├─ FLTQuerySnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTSnapshotsInSyncStreamHandler.m
   │  │     │  │  │        ├─ FLTTransactionStreamHandler.m
   │  │     │  │  │        ├─ FirestoreMessages.g.m
   │  │     │  │  │        ├─ FirestorePigeonParser.m
   │  │     │  │  │        ├─ Resources
   │  │     │  │  │        └─ include
   │  │     │  │  │           └─ cloud_firestore
   │  │     │  │  │              ├─ Private
   │  │     │  │  │              │  ├─ FLTDocumentSnapshotStreamHandler.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreExtension.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreReader.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreUtils.h
   │  │     │  │  │              │  ├─ FLTFirebaseFirestoreWriter.h
   │  │     │  │  │              │  ├─ FLTLoadBundleStreamHandler.h
   │  │     │  │  │              │  ├─ FLTPipelineParser.h
   │  │     │  │  │              │  ├─ FLTQuerySnapshotStreamHandler.h
   │  │     │  │  │              │  ├─ FLTSnapshotsInSyncStreamHandler.h
   │  │     │  │  │              │  ├─ FLTTransactionStreamHandler.h
   │  │     │  │  │              │  └─ FirestorePigeonParser.h
   │  │     │  │  │              └─ Public
   │  │     │  │  │                 ├─ CustomPigeonHeaderFirestore.h
   │  │     │  │  │                 ├─ FLTFirebaseFirestorePlugin.h
   │  │     │  │  │                 └─ FirestoreMessages.g.h
   │  │     │  │  └─ cloud_firestore.podspec
   │  │     │  ├─ pipeline_example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle.kts
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ com
   │  │     │  │  │  │     │  │     └─ example
   │  │     │  │  │  │     │  │        └─ pipeline_example
   │  │     │  │  │  │     │  │           └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle.kts
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle.kts
   │  │     │  │  ├─ integration_test
   │  │     │  │  │  └─ pipeline
   │  │     │  │  │     ├─ pipeline_add_fields_e2e.dart
   │  │     │  │  │     ├─ pipeline_aggregate_e2e.dart
   │  │     │  │  │     ├─ pipeline_execute_options_e2e.dart
   │  │     │  │  │     ├─ pipeline_expressions_e2e.dart
   │  │     │  │  │     ├─ pipeline_filter_sort_e2e.dart
   │  │     │  │  │     ├─ pipeline_find_nearest_e2e.dart
   │  │     │  │  │     ├─ pipeline_live_test.dart
   │  │     │  │  │     ├─ pipeline_remove_fields_e2e.dart
   │  │     │  │  │     ├─ pipeline_replace_with_e2e.dart
   │  │     │  │  │     ├─ pipeline_sample_e2e.dart
   │  │     │  │  │     ├─ pipeline_search_e2e.dart
   │  │     │  │  │     ├─ pipeline_seed.dart
   │  │     │  │  │     ├─ pipeline_select_e2e.dart
   │  │     │  │  │     ├─ pipeline_test_helpers.dart
   │  │     │  │  │     └─ pipeline_unnest_union_e2e.dart
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  ├─ AppIcon.appiconset
   │  │     │  │  │  │  │  │  ├─ Contents.json
   │  │     │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  │  └─ LaunchImage.imageset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ LaunchImage.png
   │  │     │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │     │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │     │  │  │  │  │     └─ README.md
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ Runner-Bridging-Header.h
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │     │  │  │  └─ RunnerTests
   │  │     │  │  │     └─ RunnerTests.swift
   │  │     │  │  ├─ lib
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     └─ app_icon_64.png
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  └─ RunnerTests
   │  │     │  │  │     └─ RunnerTests.swift
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ test
   │  │     │  │  │  └─ widget_test.dart
   │  │     │  │  ├─ test_driver
   │  │     │  │  │  └─ integration_test.dart
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  └─ manifest.json
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ test
   │  │     │  │  ├─ cloud_firestore_test.dart
   │  │     │  │  ├─ collection_reference_test.dart
   │  │     │  │  ├─ field_value_test.dart
   │  │     │  │  ├─ mock.dart
   │  │     │  │  ├─ pipeline_aggregate_test.dart
   │  │     │  │  ├─ pipeline_distance_test.dart
   │  │     │  │  ├─ pipeline_execute_options_test.dart
   │  │     │  │  ├─ pipeline_expression_test.dart
   │  │     │  │  ├─ pipeline_ordering_test.dart
   │  │     │  │  ├─ pipeline_sample_test.dart
   │  │     │  │  ├─ pipeline_snapshot_test.dart
   │  │     │  │  ├─ pipeline_source_test.dart
   │  │     │  │  ├─ pipeline_stage_test.dart
   │  │     │  │  ├─ query_test.dart
   │  │     │  │  └─ test_firestore_message_codec.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ cloud_firestore_plugin.cpp
   │  │     │     ├─ cloud_firestore_plugin.h
   │  │     │     ├─ cloud_firestore_plugin_c_api.cpp
   │  │     │     ├─ firestore_codec.cpp
   │  │     │     ├─ firestore_codec.h
   │  │     │     ├─ include
   │  │     │     │  └─ cloud_firestore
   │  │     │     │     └─ cloud_firestore_plugin_c_api.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     ├─ plugin_version.h.in
   │  │     │     └─ test
   │  │     │        └─ cloud_firestore_plugin_test.cpp
   │  │     ├─ file_selector_windows
   │  │     │  ├─ AUTHORS
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ LICENSE
   │  │     │  ├─ README.md
   │  │     │  ├─ example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ get_directory_page.dart
   │  │     │  │  │  ├─ get_multiple_directories_page.dart
   │  │     │  │  │  ├─ home_page.dart
   │  │     │  │  │  ├─ main.dart
   │  │     │  │  │  ├─ open_image_page.dart
   │  │     │  │  │  ├─ open_multiple_images_page.dart
   │  │     │  │  │  ├─ open_text_page.dart
   │  │     │  │  │  └─ save_text_page.dart
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  ├─ CMakeLists.txt
   │  │     │  │     │  └─ generated_plugins.cmake
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ lib
   │  │     │  │  ├─ file_selector_windows.dart
   │  │     │  │  └─ src
   │  │     │  │     └─ messages.g.dart
   │  │     │  ├─ pigeons
   │  │     │  │  ├─ copyright.txt
   │  │     │  │  └─ messages.dart
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ test
   │  │     │  │  ├─ file_selector_windows_test.dart
   │  │     │  │  ├─ file_selector_windows_test.mocks.dart
   │  │     │  │  └─ test_api.g.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ file_dialog_controller.cpp
   │  │     │     ├─ file_dialog_controller.h
   │  │     │     ├─ file_selector_plugin.cpp
   │  │     │     ├─ file_selector_plugin.h
   │  │     │     ├─ file_selector_windows.cpp
   │  │     │     ├─ include
   │  │     │     │  └─ file_selector_windows
   │  │     │     │     └─ file_selector_windows.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     ├─ string_utils.cpp
   │  │     │     ├─ string_utils.h
   │  │     │     └─ test
   │  │     │        ├─ file_selector_plugin_test.cpp
   │  │     │        ├─ test_file_dialog_controller.cpp
   │  │     │        ├─ test_file_dialog_controller.h
   │  │     │        ├─ test_main.cpp
   │  │     │        ├─ test_utils.cpp
   │  │     │        └─ test_utils.h
   │  │     ├─ firebase_core
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ LICENSE
   │  │     │  ├─ README.md
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ gradle
   │  │     │  │  │  └─ wrapper
   │  │     │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  ├─ gradle.properties
   │  │     │  │  ├─ local-config.gradle
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ java
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ core
   │  │     │  │  │                       ├─ FlutterFirebaseCorePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebaseCoreRegistrar.java
   │  │     │  │  │                       ├─ FlutterFirebasePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebasePluginRegistry.java
   │  │     │  │  │                       └─ GeneratedAndroidFirebaseCore.java
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebasecoreexample
   │  │     │  │  │  │     │  │              └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.h
   │  │     │  │  │  │  ├─ AppDelegate.m
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  ├─ AppIcon.appiconset
   │  │     │  │  │  │  │  │  ├─ Contents.json
   │  │     │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  │  └─ LaunchImage.imageset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ LaunchImage.png
   │  │     │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │     │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │     │  │  │  │  │     └─ README.md
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ main.m
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        └─ IDEWorkspaceChecks.plist
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     └─ app_icon_64.png
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │        └─ WorkspaceSettings.xcsettings
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  └─ manifest.json
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ firebase_core
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_core
   │  │     │  │  │        ├─ FLTFirebaseCorePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePluginRegistry.m
   │  │     │  │  │        ├─ Resources
   │  │     │  │  │        ├─ dummy.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  └─ firebase_core
   │  │     │  │  │        │     ├─ FLTFirebaseCorePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePluginRegistry.h
   │  │     │  │  │        │     ├─ dummy.h
   │  │     │  │  │        │     └─ messages.g.h
   │  │     │  │  │        └─ messages.g.m
   │  │     │  │  ├─ firebase_core.podspec
   │  │     │  │  └─ firebase_sdk_version.rb
   │  │     │  ├─ lib
   │  │     │  │  ├─ firebase_core.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ firebase.dart
   │  │     │  │     ├─ firebase_app.dart
   │  │     │  │     └─ port_mapping.dart
   │  │     │  ├─ macos
   │  │     │  │  ├─ firebase_core
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_core
   │  │     │  │  │        ├─ FLTFirebaseCorePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePluginRegistry.m
   │  │     │  │  │        ├─ Resources
   │  │     │  │  │        ├─ dummy.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  ├─ dummy.h
   │  │     │  │  │        │  └─ firebase_core
   │  │     │  │  │        │     ├─ FLTFirebaseCorePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePluginRegistry.h
   │  │     │  │  │        │     └─ messages.g.h
   │  │     │  │  │        └─ messages.g.m
   │  │     │  │  └─ firebase_core.podspec
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ test
   │  │     │  │  └─ firebase_core_test.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ firebase_core_plugin.cpp
   │  │     │     ├─ firebase_core_plugin.h
   │  │     │     ├─ firebase_core_plugin_c_api.cpp
   │  │     │     ├─ flutter_firebase_plugin_registry.cpp
   │  │     │     ├─ flutter_firebase_plugin_registry.h
   │  │     │     ├─ include
   │  │     │     │  └─ firebase_core
   │  │     │     │     ├─ firebase_core_plugin_c_api.h
   │  │     │     │     └─ flutter_firebase_plugin.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     └─ plugin_version.h.in
   │  │     ├─ firebase_storage
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ LICENSE
   │  │     │  ├─ README.md
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ gradle.properties
   │  │     │  │  ├─ local-config.gradle
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ kotlin
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ storage
   │  │     │  │  │                       ├─ FlutterFirebaseAppRegistrar.kt
   │  │     │  │  │                       ├─ FlutterFirebaseStorageException.kt
   │  │     │  │  │                       ├─ FlutterFirebaseStoragePlugin.kt
   │  │     │  │  │                       ├─ FlutterFirebaseStorageTask.kt
   │  │     │  │  │                       ├─ GeneratedAndroidFirebaseStorage.g.kt
   │  │     │  │  │                       └─ TaskStateChannelStreamHandler.kt
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebasestorageexample
   │  │     │  │  │  │     │  │              └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ assets
   │  │     │  │  │  └─ hello.txt
   │  │     │  │  ├─ cors.json
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.h
   │  │     │  │  │  │  ├─ AppDelegate.m
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │     └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ main.m
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ swiftpm
   │  │     │  │  │  │  │        └─ configuration
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │     └─ swiftpm
   │  │     │  │  │  │        └─ configuration
   │  │     │  │  │  └─ firebase_app_id_file.json
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  ├─ main.dart
   │  │     │  │  │  └─ save_as
   │  │     │  │  │     ├─ save_as.dart
   │  │     │  │  │     ├─ save_as_html.dart
   │  │     │  │  │     └─ save_as_interface.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     └─ app_icon_64.png
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     └─ swiftpm
   │  │     │  │  │  │  │        └─ configuration
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │     └─ swiftpm
   │  │     │  │  │  │        └─ configuration
   │  │     │  │  │  └─ firebase_app_id_file.json
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  └─ manifest.json
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ firebase_storage
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_storage
   │  │     │  │  │        ├─ FLTFirebaseStoragePlugin.swift
   │  │     │  │  │        ├─ FirebaseStorageMessages.g.swift
   │  │     │  │  │        ├─ Resources
   │  │     │  │  │        └─ TaskStateChannelStreamHandler.swift
   │  │     │  │  └─ firebase_storage.podspec
   │  │     │  ├─ lib
   │  │     │  │  ├─ firebase_storage.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ firebase_storage.dart
   │  │     │  │     ├─ list_result.dart
   │  │     │  │     ├─ reference.dart
   │  │     │  │     ├─ task.dart
   │  │     │  │     ├─ task_snapshot.dart
   │  │     │  │     └─ utils.dart
   │  │     │  ├─ macos
   │  │     │  │  ├─ firebase_storage
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_storage
   │  │     │  │  │        ├─ FLTFirebaseStoragePlugin.swift
   │  │     │  │  │        ├─ FirebaseStorageMessages.g.swift
   │  │     │  │  │        ├─ Resources
   │  │     │  │  │        └─ TaskStateChannelStreamHandler.swift
   │  │     │  │  └─ firebase_storage.podspec
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ test
   │  │     │  │  ├─ firebase_storage_test.dart
   │  │     │  │  ├─ list_result_test.dart
   │  │     │  │  ├─ mock.dart
   │  │     │  │  ├─ reference_test.dart
   │  │     │  │  ├─ task_snapshot_test.dart
   │  │     │  │  ├─ task_test.dart
   │  │     │  │  └─ utils_test.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ firebase_storage_plugin.cpp
   │  │     │     ├─ firebase_storage_plugin.h
   │  │     │     ├─ firebase_storage_plugin_c_api.cpp
   │  │     │     ├─ include
   │  │     │     │  └─ firebase_storage
   │  │     │     │     └─ firebase_storage_plugin_c_api.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     └─ plugin_version.h.in
   │  │     ├─ image_picker_windows
   │  │     │  ├─ AUTHORS
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ LICENSE
   │  │     │  ├─ README.md
   │  │     │  ├─ example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ lib
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  ├─ CMakeLists.txt
   │  │     │  │     │  └─ generated_plugins.cmake
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ lib
   │  │     │  │  └─ image_picker_windows.dart
   │  │     │  ├─ pubspec.yaml
   │  │     │  └─ test
   │  │     │     ├─ image_picker_windows_test.dart
   │  │     │     └─ image_picker_windows_test.mocks.dart
   │  │     ├─ path_provider_windows
   │  │     │  ├─ AUTHORS
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ LICENSE
   │  │     │  ├─ README.md
   │  │     │  ├─ example
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ integration_test
   │  │     │  │  │  └─ path_provider_test.dart
   │  │     │  │  ├─ lib
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ test_driver
   │  │     │  │  │  └─ integration_test.dart
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  ├─ CMakeLists.txt
   │  │     │  │     │  └─ generated_plugins.cmake
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ run_loop.cpp
   │  │     │  │        ├─ run_loop.h
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ lib
   │  │     │  │  ├─ path_provider_windows.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ folders.dart
   │  │     │  │     ├─ folders_stub.dart
   │  │     │  │     ├─ guid.dart
   │  │     │  │     ├─ path_provider_windows_real.dart
   │  │     │  │     ├─ path_provider_windows_stub.dart
   │  │     │  │     └─ win32_wrappers.dart
   │  │     │  ├─ pubspec.yaml
   │  │     │  └─ test
   │  │     │     ├─ guid_test.dart
   │  │     │     └─ path_provider_windows_test.dart
   │  │     └─ shared_preferences_windows
   │  │        ├─ AUTHORS
   │  │        ├─ CHANGELOG.md
   │  │        ├─ LICENSE
   │  │        ├─ README.md
   │  │        ├─ example
   │  │        │  ├─ AUTHORS
   │  │        │  ├─ LICENSE
   │  │        │  ├─ README.md
   │  │        │  ├─ integration_test
   │  │        │  │  └─ shared_preferences_test.dart
   │  │        │  ├─ lib
   │  │        │  │  └─ main.dart
   │  │        │  ├─ pubspec.yaml
   │  │        │  ├─ test_driver
   │  │        │  │  └─ integration_test.dart
   │  │        │  └─ windows
   │  │        │     ├─ CMakeLists.txt
   │  │        │     ├─ flutter
   │  │        │     │  ├─ CMakeLists.txt
   │  │        │     │  └─ generated_plugins.cmake
   │  │        │     └─ runner
   │  │        │        ├─ CMakeLists.txt
   │  │        │        ├─ Runner.rc
   │  │        │        ├─ flutter_window.cpp
   │  │        │        ├─ flutter_window.h
   │  │        │        ├─ main.cpp
   │  │        │        ├─ resource.h
   │  │        │        ├─ resources
   │  │        │        │  └─ app_icon.ico
   │  │        │        ├─ run_loop.cpp
   │  │        │        ├─ run_loop.h
   │  │        │        ├─ runner.exe.manifest
   │  │        │        ├─ utils.cpp
   │  │        │        ├─ utils.h
   │  │        │        ├─ win32_window.cpp
   │  │        │        └─ win32_window.h
   │  │        ├─ lib
   │  │        │  └─ shared_preferences_windows.dart
   │  │        ├─ pubspec.yaml
   │  │        └─ test
   │  │           ├─ fake_path_provider_windows.dart
   │  │           ├─ legacy_shared_preferences_windows_test.dart
   │  │           └─ shared_preferences_windows_async_test.dart
   │  ├─ generated_plugin_registrant.cc
   │  ├─ generated_plugin_registrant.h
   │  └─ generated_plugins.cmake
   └─ runner
      ├─ CMakeLists.txt
      ├─ Runner.rc
      ├─ flutter_window.cpp
      ├─ flutter_window.h
      ├─ main.cpp
      ├─ resource.h
      ├─ resources
      │  └─ app_icon.ico
      ├─ runner.exe.manifest
      ├─ utils.cpp
      ├─ utils.h
      ├─ win32_window.cpp
      └─ win32_window.h

```