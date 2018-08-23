# language-ats 

## 1.7.0.3

  * Bump `recursion` version bounds

## 1.7.0.2

Bug fixes:
  
  * Support `llam@` keyword

Enhancements:
  
  * Use `recursion` library to incur fewer dependencies 

## 1.7.0.0

Bug Fixes:
  
  * Now accepts proof-level lambdas.
  * Include all test data

Breaking Changes:
  
  * `PrVar` and `PrVal` now take a `StaticExpression`
  * `PrFun`, `PrFn`, and `Praxi` now take a `StaticExpression`
  * Add a rewrite phase for `StaticExpression`s

## 1.6.0.0

Breaking Changes:

  * Remove types for `RecordValues` and instead rely on typed expressions.
  * Remove `Wildcard` constructor and instead treat `_` as a name
  * Remove `ParenType` and instead use tuples

Enhancements:

  * Better Error messages
  * Add support for boxed records
  * Add support for proof expressions introducing witnesses (`[ m | () ]`)

Bug Fixes:

  * Fix bug with formatting for type arguments
  * Fix formatting for `val ... and ...` declarations
  * Fix parse error on expressions like `list_vt_cons(x, _)`
  * Add support for patterns using binary operators.
