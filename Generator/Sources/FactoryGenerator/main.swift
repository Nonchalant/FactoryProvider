//
//  main.swift
//  FactoryGenerator
//
//  Created by Ihara Takeshi on 2018/06/06.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Commander
import Core
import Generator
import Parser

let main = command(
    VariadicOption<String>("exclude", description: "The path of excluded *.swift"),
    VariadicOption<String>("testable", description: "The name of testable target"),
    Option("output", default: "./Factories.generated.swift", description: "The generated path of output"),
    VariadicArgument<String>("The path of input *.swift")
) { excludes, testables, output, includes in
    let options = Options(includes: includes, excludes: excludes, testables: testables, output: output)
    
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
