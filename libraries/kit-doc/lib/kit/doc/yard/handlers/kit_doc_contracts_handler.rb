require 'yard'

# Support for `Kit::Contract`.
#
# Currently this simply ignores `after` / `before` / `contract` directives and does not add anything to the generated documentation.
#
# ### References
# - https://github.com/sfcgeorge/yard-contracts
#
class Kit::Doc::Yard::KitDocContractsHandler < YARD::Handlers::Ruby::Base

  handles method_call(:contract)
  handles method_call(:before)
  handles method_call(:after)
  namespace_only # only match calls inside a namespace not inside a method

  def process
    # statement is a YARD attribute, subclassing YARD::Parser::Ruby::AstNode
    # Here it's class will be YARD::Parser::Ruby::MethodCallNode
    # MethodCallNode#line_range returns the lines the method call was over
    # AstNode#line gives the first line of the node
    # AstNode#traverse takes a block and yields child nodes
    # AstNode#jump returns the first node matching type, otherwise returns self

    # Go up the tree to namespace level, then jump to next def statement
    # NOTE: this won't document dynamicly defined methods.
    parent = statement.parent
    contract_last_line = statement.line_range.last
    # YARD::Parser::Ruby::MethodDefinitionNode
    def_method_ast = parent.traverse do |node|
      # Find the first def statement that comes after the contract we're on
      break node if node.line > contract_last_line && node.def?
    end

    ## Hacky way to test for class methods
    ## TODO: What about module methods? Probably broken.
    scope = def_method_ast.source.match(%r{def +self\.}) ? :class : :instance
    name  = def_method_ast.method_name true
    doc   = YARD::DocstringParser.new.parse(statement.docstring).to_docstring
    #params    = def_method_ast.parameters # YARD::Parser::Ruby::ParameterNode
    #contracts = statement.parameters # YARD::Parser::Ruby::AstNode

    # YARD hasn't got to the def method yet, so we create a stub of it with
    # our docstring, when YARD gets to it properly it will fill in the rest.
    YARD::CodeObjects::MethodObject.new(namespace, name, scope) do |o|
      o.docstring = doc
    end
    # No `register()` it breaks stuff! Above implicit return value is enough.
  end

end
