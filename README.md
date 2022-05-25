# flt_bootstrap

Flutter Bootstrap project

##### setup
```sh
flutter create --platforms=windows,macos,linux .

flutterfire configure
```

* adding firebase cli
```sh
curl -sL https://firebase.tools | bash
```
* login to firebase
```sh
firebase login
firebase projects:list
```
* adding flutterfire cli globally
```sh
dart pub global activate flutterfire_cli
```

* configure flutterfire
```sh
flutterfire configure

flutter pub add firebase_core firebase_auth cloud_firestore
flutter pub add flutterfire_ui

flutter pub add flutter_hooks hooks_riverpod


flutter pub add freezed_annotation
flutter pub add --dev build_runner freezed json_serializable

```
* update `build target` to `10.12` for macOS by `open macos/Runner.xcodeproj`
* network permissions `macOS` to `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`
```
<key>com.apple.security.network.client</key>
<true/>
```

##### run
```sh
flutter run -d macOS
flutter run -d Chrome
```

##### generating freezed parts
```sh
flutter packages pub run build_runner watch --delete-conflicting-outputs
```
