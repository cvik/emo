## Emo - Erlang Mustache rendering library

Simple Mustache rendering app with mostly basic functionality implemented.
Doesnt yet support tripple curlies(or &-tags), partials or set delimiters.


Latest Tag: emo-0.2.0

## Exports

```erlang
-spec emo:render(Template::string(), Context::[{atom(), term()}]) -> iolist().
```

## Example usage

```erlang
1> l(emo).
ok
2> Context = [{type, "Fruits"},
              {inventory, [[{name, "apple"}, {amount, "12"}],
                           [{name, "banana"}, {amount, "3"}, {pear, false}]]}].
[{type,"Fruits"},
 {inventory,[[{name,"apple"},{amount,"12"}],
              [{name,"banana"},{amount,"3"},{pear,false}]]}]
3> Template = "<h4>{{type}}</h4><ul>{{#inventory}}<li>{{name}} - {{amount}}</li>{{/inventory}}</ul>{{not_shown}}{{^show_on_undef}}Default!{{/show_on_undef}}".
"<h4>{{type}}</h4><ul>{{#inventory}}<li>{{name}} - {{amount}}</li>{{/inventory}}</ul>{{not_shown}}{{^show_on_undef}}Default!{{/show_on_undef}}"
4> iolist_to_binary(emo:render(Template, Context)).
<<"<h4>Fruits</h4><ul><li>apple - 12</li><li>banana - 3</li></ul>Default!">>
```

## License

Apache license version 2.0. See the LICENSE file for details.
