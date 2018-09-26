import Core
import PathKit

struct FileGenerator {
    static func run(render: String, with options: Options) throws {
        try Path(options.output).write(render)
    }
}
