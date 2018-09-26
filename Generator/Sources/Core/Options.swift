import PathKit
import Yaml

public struct Options {
    private let includes: [String]
    private let excludes: [String]
    
    public private(set) var inputs: [String] = []
    public let testables: [String]
    public let output: String
    
    public init?(raw: String) {
        guard let config = try? Yaml.load(raw) else {
            return nil
        }
        
        self.includes = config["includes"].array?.compactMap({ $0.string }) ?? [config["includes"].string].compactMap({ $0 })
        self.excludes = config["excludes"].array?.compactMap({ $0.string }) ?? [config["excludes"].string].compactMap({ $0 })
        self.testables = config["testables"].array?.compactMap({ $0.string }) ?? [config["testables"].string].compactMap({ $0 })
        self.output = config["output"].string ?? "./Factories.generated.swift"
        
        self.inputs = Array(Set(includes.map(children).flatMap({ $0 })).subtracting(Set(excludes.map(children).flatMap({ $0 }))))
    }
    
    private func children(with path: String) -> [String] {
        let content = Path(path)
        
        guard content.isDirectory else {
            return [content.string]
        }
        
        guard let children = try? Path(path).recursiveChildren() else {
            return []
        }
        
        return children.map({ $0.string }).filter({ $0.hasSuffix(".swift") })
    }
}
