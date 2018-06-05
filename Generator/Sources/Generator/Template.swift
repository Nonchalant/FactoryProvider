//
//  Template.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/07.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

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
            // MARK: - Factory
            
            // MARK: - Enum
            
            {% for enum in types.enums where not enum.cases.count == 0 %}
            extension {{ enum.name }}: Providable{% if enum.generics.count != 0 %} where{% for generic in enum.generics %} {{ generic.name }}: Providable{% if not forloop.last %},{% endif %}{% endfor %}{% endif %} {
                public static func provide() -> {{ enum.name }} {
                    return .{{ enum.cases.first.name }}{% if not enum.cases.first.variables.count == 0 %}(
                        {% for variable in enum.cases.first.variables %}
                        {% if not variable.name == "" %}{{ variable.name }}: {% endif %}{{ variable.typeName.name }}.provide(){% if not forloop.last %},{% endif %}
                        {% endfor %}
                    ){% endif %}
                }
            }
            
            {% endfor %}
            // MARK: - Struct
            
            {% for struct in types.structs %}
            extension {{ struct.name }}: Providable{% if struct.generics.count != 0 %} where{% for generic in struct.generics %} {{ generic.name }}: Providable{% if not forloop.last %},{% endif %}{% endfor %}{% endif %} {
                public static func provide() -> {{ struct.name }} {
                    return {{ struct.name }}(
                        {% for variable in struct.variables %}
                        {{ variable.name }}: {{ variable.typeName.name }}.provide(){% if not forloop.last %},{% endif %}
                        {% endfor %}
                    )
                }
            }
            
            {% endfor %}
            """
        case .lens:
            return """
            // MARK: - Lens
            
            {% for struct in types.structs %}
            extension {{ struct.name }} {
                {% for variable in struct.variables %}
                static var _{{ variable.name }}: Lens<{{ struct.name }}, {{ variable.typeName.name }}> {
                    return Lens<{{ struct.name }}, {{ variable.typeName.name }}>(
                        getter: { $0.{{ variable.name }} },
                        setter: { base, {{ variable.name }} in
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
