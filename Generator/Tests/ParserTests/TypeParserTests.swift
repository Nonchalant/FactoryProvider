import MirrorDiffKit
import XCTest
@testable import Core
@testable import Parser
@testable import SourceKittenFramework

class TypeParserTests: XCTestCase {
    
    // MARK: - Type
    
    func testEnum() {
        let file = File(contents: """
        enum Wall {
            case hang
            case vertical
            case slab
        }
        """)
        let actual = try! TypesParser(file: file).run()

        let expected: [Type] = [
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
        ]

        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testProtocol() {
        let file = File(contents: """
        protocol Climbable {
            var condition: String { get }
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Protocol(
                name: "Climbable",
                generics: [],
                conforms: []
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testStruct() {
        let file = File(contents: """
        struct Climber {
            let name: String
            let age: Int
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climber",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String")),
                    Variable(name: "age", typeName: TypeName(name: "Int"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }

    // MARK: - Condition
    
    func testComputedProperty() {
        let file = File(contents: """
        struct Wall {
            let name: String
            let angle: Float
        
            var isSlab: Bool {
                return angle < 90.0
            }
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Wall",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String")),
                    Variable(name: "angle", typeName: TypeName(name: "Float"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }

    func testExtension() {
        let file = File(contents: """
        struct Hold {
            let name: String
            let type: Type
        }
        
        extension Hold {
            enum Type {
                case bucket
                case pocket
                case sloper
                case tip
                case under
            }
        }
        """)
        let actual = try! TypesParser(file: file).run()

        let expected: [Type] = [
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
        ]

        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testNested() {
        let file = File(contents: """
        struct Climbing {
            struct Hold {
                let name: String
                let type: Type
        
                enum Type {
                    case bucket
                    case pocket
                    case sloper
                    case tip
                    case under
                }
            }
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climbing",
                generics: [],
                conforms: [],
                variables: []
            ),
            Struct(
                name: "Climbing.Hold",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String")),
                    Variable(name: "type", typeName: TypeName(name: "Type"))
                ]
            ),
            Enum(
                name: "Climbing.Hold.Type",
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
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testGenerics() {
        let file = File(contents: """
        struct Climber<T: Equatable, U: Encodable & Decodable> {
            let name: T
            let age: U
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climber",
                generics: [
                    Generic(name: "T", conforms: [TypeName(name: "Equatable")]),
                    Generic(name: "U", conforms: [TypeName(name: "Encodable"), TypeName(name: "Decodable")])
                ],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "T")),
                    Variable(name: "age", typeName: TypeName(name: "U"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    // MARK: - Enum Option
    
    func testAssociatedValues() {
        let file = File(contents: """
        enum Place {
            case indoor
            case outdoor
            case other(String)
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Enum(
                name: "Place",
                generics: [],
                conforms: [],
                cases: [
                    Enum.Case(name: "indoor", variables: []),
                    Enum.Case(name: "outdoor", variables: []),
                    Enum.Case(name: "other", variables: [Variable(name: "", typeName: TypeName(name: "String"))])
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    // MARK: - Protocol Option
    
    func testConforms() {
        let file = File(contents: """
        protocol Climbable {
            var condition: String { get }
        }
        
        struct Wall: Climbable {
            let name: String
            let angle: Float
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Protocol(
                name: "Climbable",
                generics: [],
                conforms: []
            ),
            Struct(
                name: "Wall",
                generics: [],
                conforms: [TypeName(name: "Climbable")],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String")),
                    Variable(name: "angle", typeName: TypeName(name: "Float"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    // MARK: - Struct Option
    
    func testImmutableDefaultValue() {
        let file = File(contents: """
        struct Climber {
            let name: String
            let age: Int = 26
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climber",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testImmutableClosure() {
        let file = File(contents: """
        struct Climber {
            let name: String
            let age: Int = {
                return 26
            }()
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climber",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testMutableDefaultValue() {
        let file = File(contents: """
        struct Climber {
            let name: String
            var age: Int = 26
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climber",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String")),
                    Variable(name: "age", typeName: TypeName(name: "Int"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
    
    func testMutableClosure() {
        let file = File(contents: """
        struct Climber {
            let name: String
            var age: Int = {
                return 26
            }()
        }
        """)
        let actual = try! TypesParser(file: file).run()
        
        let expected: [Type] = [
            Struct(
                name: "Climber",
                generics: [],
                conforms: [],
                variables: [
                    Variable(name: "name", typeName: TypeName(name: "String")),
                    Variable(name: "age", typeName: TypeName(name: "Int"))
                ]
            )
        ]
        
        XCTAssert(actual =~ expected, diff(between: actual, and: expected))
    }
}
