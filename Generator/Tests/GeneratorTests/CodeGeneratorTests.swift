import MirrorDiffKit
import XCTest
@testable import Core
@testable import Generator

class CodeGeneratorTests: XCTestCase {
    
    private var options: Options!
    
    override func setUp() {
        options = Options(raw: "")
    }
    
    // MARK: - Header
    
    func testTestables() {
        options = Options(raw: """
        testables:
          - Testable1
          - Testable2
        """)
        
        let actual = try! CodeGenerator.run(
            types: [],
            by: .header,
            with: options
        )
        
        let expected: String = """
        // Generated using FactoryProvider \(Version.current) — https://github.com/Nonchalant/FactoryProvider
        // DO NOT EDIT
        
        import FactoryProvider
        @testable import Testable1
        @testable import Testable2
        
        
        """
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    // MARK: - Factory
    
    // MARK: - Type
    
    func testEnum() {
        let actual = try! CodeGenerator.run(
            types: [
                Enum(
                    name: "Wall",
                    generics: [],
                    conforms: [],
                    cases: [
                        Enum.Case(name: "hang", variables: []),
                        Enum.Case(name: "vertical", variables: []),
                        Enum.Case(name: "slab", variables: [])
                    ]
                )
            ],
            by: .factory,
            with: options
        )

        let expected = TemplateHelper.factory(
            enums: """
                extension Factory where Type == Wall {
                    static func provide() -> Type {
                        return .hang
                    }
                }
                """
        )

        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    func testProtocol() {
        let actual = try! CodeGenerator.run(
            types: [
                Protocol(
                    name: "Climbable",
                    generics: [],
                    conforms: []
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            protocols: nil
        )

        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }

    func testStruct() {
        let actual = try! CodeGenerator.run(
            types: [
                Struct(
                    name: "Climber",
                    generics: [],
                    conforms: [],
                    variables: [
                        Variable(name: "name", typeName: TypeName(name: "String")),
                        Variable(name: "age", typeName: TypeName(name: "Int"))
                    ]
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            structs: """
                extension Factory where Type == Climber {
                    static func provide(name: String = Factory<String>.provide(), age: Int = Factory<Int>.provide()) -> Type {
                        return Climber(
                            name: name,
                            age: age
                        )
                    }
                }
                """
        )
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }

    // MARK: - Condition

    func testNested() {
        let actual = try! CodeGenerator.run(
            types: [
                Struct(
                    name: "Hold",
                    generics: [],
                    conforms: [],
                    variables: [
                        Variable(name: "name", typeName: TypeName(name: "String")),
                        Variable(name: "type", typeName: TypeName(name: "Type"))
                    ]
                ),
                Enum(
                    name: "Hold.Type",
                    generics: [],
                    conforms: [],
                    cases: [
                        Enum.Case(name: "bucket", variables: []),
                        Enum.Case(name: "pocket", variables: []),
                        Enum.Case(name: "sloper", variables: []),
                        Enum.Case(name: "tip", variables: []),
                        Enum.Case(name: "under", variables: [])
                    ]
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            enums: """
                extension Factory where Type == Hold.Type {
                    static func provide() -> Type {
                        return .bucket
                    }
                }
                """,
            structs: """
                extension Factory where Type == Hold {
                    static func provide(name: String = Factory<String>.provide(), type: Type = Factory<Type>.provide()) -> Type {
                        return Hold(
                            name: name,
                            type: type
                        )
                    }
                }
                """
        )
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }

    func testConforms() {
        let actual = try! CodeGenerator.run(
            types: [
                Protocol(
                    name: "Climbable",
                    generics: [],
                    conforms: []
                ),
                Protocol(
                    name: "Climbable2",
                    generics: [],
                    conforms: [TypeName(name: "Climbable")]
                ),
                Struct(
                    name: "Wall",
                    generics: [],
                    conforms: [TypeName(name: "Climbable2")],
                    variables: []
                ),
                Struct(
                    name: "Hold",
                    generics: [],
                    conforms: [TypeName(name: "Climbable2")],
                    variables: [
                        Variable(name: "name", typeName: TypeName(name: "Climbable3"))
                    ]
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            protocols: nil,
            structs: """
                extension Factory where Type == Wall {
                    static func provide() -> Type {
                        return Wall(
                        )
                    }
                }

                extension Factory where Type == Hold {
                    static func provide(name: Climbable3 = Factory<Climbable3>.provide()) -> Type {
                        return Hold(
                            name: name
                        )
                    }
                }
                """
        )
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    func testGenerics() {
        let actual = try! CodeGenerator.run(
            types: [
                Struct(
                    name: "Wall",
                    generics: [
                        Generic(name: "T", conforms: []),
                        Generic(name: "S", conforms: [TypeName(name: "Climbable")])
                    ],
                    conforms: [],
                    variables: [
                        Variable(name: "name", typeName: TypeName(name: "String")),
                        Variable(name: "angle", typeName: TypeName(name: "Float"))
                    ]
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            structs: """
                extension Factory {
                    static func provide<T, S>(name: String = Factory<String>.provide(), angle: Float = Factory<Float>.provide()) -> Type where Type == Wall<T, S> {
                        return Wall(
                            name: name,
                            angle: angle
                        )
                    }
                }
                """
        )
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    // MARK: - Enum Option

    func testAssociatedValues() {
        let actual = try! CodeGenerator.run(
            types: [
                Enum(
                    name: "Place",
                    generics: [],
                    conforms: [],
                    cases: [
                        Enum.Case(
                            name: "other",
                            variables: [
                                Variable(name: "", typeName: TypeName(name: "String")),
                                Variable(name: "", typeName: TypeName(name: "Float"))
                            ]
                        )
                    ]
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            enums: """
                extension Factory where Type == Place {
                    static func provide() -> Type {
                        return .other(
                            Factory<String>.provide(),
                            Factory<Float>.provide()
                        )
                    }
                }
                """
        )
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    func testAssociatedValuesWithLabel() {
        let actual = try! CodeGenerator.run(
            types: [
                Enum(
                    name: "Place",
                    generics: [],
                    conforms: [],
                    cases: [
                        Enum.Case(
                            name: "other",
                            variables: [
                                Variable(name: "label1", typeName: TypeName(name: "String")),
                                Variable(name: "label2", typeName: TypeName(name: "Encodable & Decodable")),
                            ]
                        ),
                    ]
                )
            ],
            by: .factory,
            with: options
        )
        
        let expected = TemplateHelper.factory(
            enums: """
                extension Factory where Type == Place {
                    static func provide() -> Type {
                        return .other(
                            label1: Factory<String>.provide(),
                            label2: Factory<Encodable>.provide()
                        )
                    }
                }
                """
        )
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    // MARK: - Lens
    
    // MARK: - Type
    
    func testLens() {
        let actual = try! CodeGenerator.run(
            types: [
                Struct(
                    name: "Climber",
                    generics: [],
                    conforms: [],
                    variables: [
                        Variable(name: "name", typeName: TypeName(name: "String")),
                        Variable(name: "age", typeName: TypeName(name: "Int"))
                    ]
                )
            ],
            by: .lens,
            with: options
        )
        
        let expected: String = TemplateHelper.lens(structs: """
            extension Lens where Type == Climber {
                static func name() -> Lens<Climber, String> {
                    return Lens<Climber, String>(
                        getter: { $0.name },
                        setter: { name, base in
                            Climber(name: name, age: base.age)
                        }
                    )
                }
                static func age() -> Lens<Climber, Int> {
                    return Lens<Climber, Int>(
                        getter: { $0.age },
                        setter: { age, base in
                            Climber(name: base.name, age: age)
                        }
                    )
                }
            }
            """)
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
    
    func testGenericsLens() {
        let actual = try! CodeGenerator.run(
            types: [
                Struct(
                    name: "Climber",
                    generics: [
                        Generic(name: "T", conforms: [TypeName(name: "Equatable")])
                    ],
                    conforms: [],
                    variables: [
                        Variable(name: "name", typeName: TypeName(name: "String")),
                        Variable(name: "age", typeName: TypeName(name: "T"))
                    ]
                )
            ],
            by: .lens,
            with: options
        )
        
        let expected: String = TemplateHelper.lens(structs: """
            extension Lens {
                static func name<T>() -> Lens<Climber, String> where Type == Climber<T> {
                    return Lens<Climber, String>(
                        getter: { $0.name },
                        setter: { name, base in
                            Climber(name: name, age: base.age)
                        }
                    )
                }
                static func age<T>() -> Lens<Climber, T> where Type == Climber<T> {
                    return Lens<Climber, T>(
                        getter: { $0.age },
                        setter: { age, base in
                            Climber(name: base.name, age: age)
                        }
                    )
                }
            }
            """)
        
        XCTAssertEqual(actual, expected, diff(between: actual, and: expected))
    }
}
