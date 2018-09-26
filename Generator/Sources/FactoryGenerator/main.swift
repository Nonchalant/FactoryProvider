import Commander
import Core
import Generator
import Parser
import PathKit

let main = command(
    Option("config", default: ".factory.yml", description: "The path of config")
) { config in
    guard let options = (try? Path(config).read()).flatMap(Options.init) else {
        print("Load Error is occured 😱 \(config)")
        return
    }

    do {
        let types = try Parser(paths: options.inputs).run()
        try Generator(types: types).run(with: options)
    } catch let error {
        switch error {
        case _ as ParseError:
            print("Parse Error is occured 😱")
        case _ as GenerateError:
            print("Generate Error is occured 😱")
        default:
            print("Unknown Error is occured 😱")
        }
        return
    }

    print("\(options.output) is generated 🎉")
}

main.run(Version.current)
