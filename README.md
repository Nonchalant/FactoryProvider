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

- **Swift 4.1**
- **Xcode 9.4**


## Platforms

FactoryProvider works on the following platforms:

- **iOS 8+**
- **Mac OSX 10.9+**
- **watchOS 2+**
- **tvOS 9+**


## Supports

- **Enum**
- **Struct**


## FactoryProvider

### 1. Installation

#### CocoaPods

FactoryProvider runtime is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your test target in your Podfile:

```Ruby
pod "FactoryProvider"
```

And add the following `Run script` build phase to your test target's `Build Phases`:

```Bash
"${PODS_ROOT}/FactoryProvider/generate" --config .factory.yml
```

After running once, locate `Factories.generated.swift` and drag it into your Xcode test target group.

#### .factory.yml

```yml
includes: # paths of file or directory to generate
  - Input/SubInput1
  - Input/SubInput2/Source.swift
excludes: # paths of file or directory not to generate
  - Input/SubInput1/SubSubInput
  - Input/SubInput2/Source.swift
testables: # testable targets
  - target1
  - target2
output: output/Factories.generated.swift # path of generated file
```

### 2. Usage

You can get a instance to call `Factory<TypeName>.provide()`. Each properties are set to default value.

```swift
struct Climber {
    let name: String
    let age: Int
}

let climber = Factory<Climber>.provide()
// Climber(name: "", age: 0)

 let optClimber = Factory<Climber?>.provide()
// Optional(Climber(name: "", age: 0))

 let arrayClimber = Factory<[Climber]>.provide()
// [Climber(name: "", age: 0)]
```

### 3. Lens

`Factory<TypeName>.provide()` provides fixed instance. You can modify each property by Lens.

#### Get

```swift
let name = Factory<Climber>.provide().name or Climber._name.get(Factory<Climber>.provide())
// ""
```

#### Set

```swift
import FactoryProvider

let climber = Factory<Climber>.provide() |> Climber._name *~ "Climber"
// Climber(name: "Climber", age: 0)
```

#### Modify

```swift
import FactoryProvider

let name = Factory<Climber>.provide() |> Climber._name *~ { "Climber" |> { $0 + $0 } }()
// Climber(name: "ClimberClimber", age: 0)
```

#### Compose

```swift
import FactoryProvider

struct Climber {
    let id: Id
    let name: String
    
    struct Id {
        let value: String
    }
}

let climber1 = Factory<Climber>.provide()
// Climber(id: Id(value: ""), name: "")

let climber2 = climber1 |> Climber._id * Climber.Id._value *~ "id"
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
