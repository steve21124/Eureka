
struct Property {
    static let TypeKey = "type";
    static let Properties = "properties";
    static let Items = "items";
    static let AdditionalItems = "additionalItems";
    static let Required = "required";
    static let PatternProperties = "patternProperties";
    static let AdditionalProperties = "additionalProperties";
    static let Requires = "requires";
    static let Dependencies = "dependencies";
    static let Minimum = "minimum";
    static let Maximum = "maximum";
    static let ExclusiveMinimum = "exclusiveMinimum";
    static let ExclusiveMaximum = "exclusiveMaximum";
    static let MinimumItems = "minItems";
    static let MaximumItems = "maxItems";
    static let Pattern = "pattern";
    static let MaximumLength = "maxLength";
    static let MinimumLength = "minLength";
    static let Enum = "enum";
    static let ReadOnly = "readonly";
    static let Title = "title";
    static let Description = "description";
    static let Format = "format";
    static let Default = "default";
    static let Transient = "transient";
    static let DivisibleBy = "divisibleBy";
    static let MultipleOf = "multipleOf";
    static let Hidden = "hidden";
    static let Disallow = "disallow";
    static let Extends = "extends";
    static let Id = "id";
    static let UniqueItems = "uniqueItems";
    static let MinimumProperties = "minProperties";
    static let MaximumProperties = "maxProperties";
    
    static let AnyOf = "anyOf";
    static let AllOf = "allOf";
    static let OneOf = "oneOf";
    static let Not = "not";
    
    static let Ref = "$ref";
    static let Schema = "$schema";
}

struct Format
{
    static let Draft3Hostname = "host-name";
    static let Draft3IPv4 = "ip-address";
    static let Hostname = "hostname";
    static let DateTime = "date-time";
    static let Date = "date";
    static let Time = "time";
    static let Countdown = "countdown";
    static let UtcMilliseconds = "utc-millisec";
    static let Regex = "regex";
    static let Color = "color";
    static let Style = "style";
    static let Phone = "phone";
    static let Uri = "uri";
    static let IPv6 = "ipv6";
    static let IPv4 = "ipv4";
    static let Email = "email";
}

struct SchemaType
{
    static let String = "string";
    static let Object = "object";
    static let Integer = "integer";
    static let Number = "number";
    static let Null = "null";
    static let Boolean = "boolean";
    static let Array = "array";
    
    static let AnyObj = "any";
}

struct FormProperties {
    static let FormKey = "key";
    static let FormAllKey = "*";
    static let FormType = "type";
}

struct FormType {
    static let Text = "text";
    static let Textarea = "textarea";
    static let Checkboxes = "checkboxes";

}


