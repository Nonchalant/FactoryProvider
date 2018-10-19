import Core

enum Template {
    case header
    case factory
    case lens

    var rawValue: String {
        switch self {
        case .header:
            return """
            // Generated using FactoryProvider \(Version.current) — https://github.com/Nonchalant/FactoryProvider
            // DO NOT EDIT
            
            import FactoryProvider
            {% for testable in testables %}
            @testable import {{ testable }}
            {% endfor %}
            
            
            """
        case .factory:
            return """
            // MARK: - Enum
            
            {% for enum in types.enums where not enum.cases.count == 0 and enum.generics.count == 0 %}
            extension Factory where Type == {{ enum.name }} {
                static func provide() -> Type {
                    return .{{ enum.cases.first.name }}{% if not enum.cases.first.variables.count == 0 %}(
                        {% for variable in enum.cases.first.variables %}
                        {% if not variable.name == "" %}{{ variable.name }}: {% endif %}Factory<{{ variable.typeName.name }}>.provide(){% if not forloop.last %},{% endif %}
                        {% endfor %}
                    ){% endif %}
                }
            }
            
            {% endfor %}
            // MARK: - Struct
            
            {% for struct in types.structs where struct.generics.count == 0 %}
            extension Factory where Type == {{ struct.name }} {
                static func provide({% for variable in struct.variables %}{{ variable.name }}: {{ variable.typeName.name }} = Factory<{{ variable.typeName.name }}>.provide(){% if not forloop.last %}, {% endif %}{% endfor %}) -> Type {
                    return {{ struct.name }}(
                        {% for variable in struct.variables %}
                        {{ variable.name }}: {{ variable.name }}{% if not forloop.last %},{% endif %}
                        {% endfor %}
                    )
                }
            }
            
            {% endfor %}
            """
        case .lens:
            return """
            // MARK: - Lens
            
            {% for struct in types.structs where struct.generics.count == 0 %}
            extension Lens where Type == {{ struct.name }} {
                {% for variable in struct.variables %}
                static func {{ variable.name }}() -> LensOver<{{ struct.name }}, {{ variable.typeName.name }}> {
                    return LensOver<{{ struct.name }}, {{ variable.typeName.name }}>(
                        getter: { $0.{{ variable.name }} },
                        setter: { {{ variable.name }}, base in
                            {{ struct.name }}({% for argument in struct.variables %}{{ argument.name }}: {% if variable.name == argument.name %}{{ variable.name }}{% else %}base.{{ argument.name }}{% endif %}{% if not forloop.last %}, {% endif %}{% endfor %})
                        }
                    )
                }{% endfor %}
            }
            
            {% endfor %}
            """
        }
    }
    
    static var allCases: [Template] {
        return [.header, .factory, .lens]
    }
}
