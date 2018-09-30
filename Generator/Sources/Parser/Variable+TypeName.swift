import Core

extension Variable {
    func setParent(with parentName: String) -> Variable {
        return Variable(name: name, typeName: TypeName(name: "\(parentName).\(typeName.name)"))
    }
}
