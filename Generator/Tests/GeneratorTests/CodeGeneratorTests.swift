//
//  TypeParserTests.swift
//  GeneratorTests
//
//  Created by Ihara Takeshi on 2018/06/08.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

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
                extension Wall: Providable {
                    public static func provide() -> Wall {
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
            protocols: """
                """
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
                extension Climber: Providable {
                    public static func provide() -> Climber {
                        return Climber(
                            name: String.provide(),
                            age: Int.provide()
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
                extension Hold.Type: Providable {
                    public static func provide() -> Hold.Type {
                        return .bucket
                    }
                }
                """,
            structs: """
                extension Hold: Providable {
                    public static func provide() -> Hold {
                        return Hold(
                            name: String.provide(),
                            type: Type.provide()
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
            protocols: """
                """,
            structs: """
                extension Wall: Providable {
                    public static func provide() -> Wall {
                        return Wall(
                        )
                    }
                }

                extension Hold: Providable {
                    public static func provide() -> Hold {
                        return Hold(
                            name: Climbable3.provide()
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
                extension Wall: Providable where T: Providable, S: Providable {
                    public static func provide() -> Wall {
                        return Wall(
                            name: String.provide(),
                            angle: Float.provide()
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
                extension Place: Providable {
                    public static func provide() -> Place {
                        return .other(
                            String.provide(),
                            Float.provide()
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
                extension Place: Providable {
                    public static func provide() -> Place {
                        return .other(
                            label1: String.provide(),
                            label2: Encodable.provide()
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
            extension Climber {
                static var _name: Lens<Climber, String> {
                    return Lens<Climber, String>(
                        getter: { $0.name },
                        setter: { name, base in
                            Climber(name: name, age: base.age)
                        }
                    )
                }
                static var _age: Lens<Climber, Int> {
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
            extension Climber {
                static var _name: Lens<Climber, String> {
                    return Lens<Climber, String>(
                        getter: { $0.name },
                        setter: { name, base in
                            Climber(name: name, age: base.age)
                        }
                    )
                }
                static var _age: Lens<Climber, T> {
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
