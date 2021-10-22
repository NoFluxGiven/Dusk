import sys

from lark import Lark, Transformer, v_args

kv_grammar = r"""
    ?start: pair

    ?value: string -> string
            | object

    string: ESCAPED_STRING
    object: "{" [(pair)*] "}"
    pair: string value

    COMMENT: "//" /[^\n]*/ _NEWLINE
    _NEWLINE: "\n"
    %ignore COMMENT

    %import common.ESCAPED_STRING
    %import common.WS

    %ignore WS
"""

kv_parser = Lark(kv_grammar, parser='lalr')

class KVToJSON(Transformer):
    def pair(self, key_value):
        k,v = key_value
        return k,v
    def object(self, items):
        return dict(items)
    def string(self, s):
        (s,) = s
        return s[0:].replace('"','')

def Parse(input):
    tree = kv_parser.parse(input)
    output = KVToJSON().transform(tree)
    newdict = { output[0]: output[1] }
    return newdict
# print( tree.pretty() )