# flt_bootstrap

Flutter Bootstrap project

##### setup
```sh
flutter create --platforms=windows,macos,linux .

flutterfire configure
```

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
