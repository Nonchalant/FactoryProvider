# :factory: FactoryProvider :factory:

[![Build Status](https://travis-ci.com/Nonchalant/FactoryProvider.svg?branch=master)](https://travis-ci.com/Nonchalant/FactoryProvider)
[![Version](http://img.shields.io/cocoapods/v/FactoryProvider.svg?style=flat)](http://cocoadocs.org/pods/FactoryProvider)
[![Platform](http://img.shields.io/cocoapods/p/FactoryProvider.svg?style=flat)](http://cocoadocs.org/pods/FactoryProvider)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Nonchalant/FactoryProvider/master/LICENSE.md)
[![GitHub release](https://img.shields.io/github/release/Nonchalant/FactoryProvider.svg)](https://github.com/Nonchalant/FactoryProvider/releases)
![Xcode](https://img.shields.io/badge/Xcode-9.4-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-4.1-brightgreen.svg)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-4.0.0-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Generate boilerplate of factory Swift framework.


## Requirements

FactoryProvider works on the following platforms:

- **iOS 8+**
- **Mac OSX 10.9+**
- **watchOS 2+**
- **tvOS 9+**


## Supports

Struct, Enum


## FactoryProvider

### 1. Installation

#### CocoaPods

FactoryProvider runtime is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your test target in your Podfile:

```Ruby
pod "FactoryProvider"
```

And add the following `Run script` build phase to your test target's `Build Phases`:

```Bash
"${PODS_ROOT}/FactoryProvider/generate" \
    "${PROJECT_DIR}/${PROJECT_NAME}"/Input1/**/*.swift \
    "${PROJECT_DIR}/${PROJECT_NAME}"/Input2/**/*.swift \
    --exclude "${PROJECT_DIR}/${PROJECT_NAME}/Input2/InputFile.swift" \
    --testable "$PROJECT_NAME" \
    --output "$PROJECT_DIR/${PROJECT_NAME}Tests/Factories.generated.swift"
```

After running once, locate `Factories.generated.swift` and drag it into your Xcode test target group.

#### --include

path of files to generate

#### --exclude

path of files not to generate

#### --testable

testable target

#### --output

path of generated file

### 2. Usage

You can get a instance to call `<TypeName>.provide()`. Each properties are set to default value.

```swift
struct Climber {
    let name: String
    let age: Int
}

let climber = Climber.provide()
```

### 3. Lens

`<TypeName>.provide()` provides fixed instance. You can modify each property by Lens.

#### Get

```swift
let name = Climber._name.get(Climber.provide())
// ""
```

#### Set

```swift
let climber = Climber._name.set(Climber.provide(), "Climber")
// Climber(name: "Climber", age: 0)
```

#### Modify

```swift
let climber1 = Climber._name.set(Climber.provide(), "Climber")
// Climber(name: "Climber", age: 0)

let climber = Climber._name.modify(climber1, f: { $0 + $0 })
// Climber(name: "ClimberClimber", age: 0)
```

#### Compose

```swift
struct Climber {
    let id: Id
    let name: String
    
    struct Id {
        let value: String
    }
}

let climber1 = Climber.provide()
// Climber(id: Id(value: ""), name: "")

let climber2 = Climber._id.compose(other: Climber.Id._value).set(climber1, "id")
// Climber(id: Id(value: "id"), name: "")
```


## Libraries

* [Commander](https://github.com/kylef/Commander)
* [PathKit](https://github.com/kylef/PathKit)
* [SourceKitten](https://github.com/jpsim/SourceKitten)
* [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit)
* [MirrorDiffKit](https://github.com/Kuniwak/MirrorDiffKit)


## License

FactoryProvider is available under the [MIT License](LICENSE).
