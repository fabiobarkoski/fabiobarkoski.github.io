Have you ever had to chase a bug that only appeared under specific conditions? Or spent time trying to understand why some state changed unexpectedly? You probably already felt the pain that functional programming tries to solve.

The main idea is making your code more predictable. No hidden side effects, no data changing under your feet, errors as values instead of invisible exceptions flying through your call stack. Easier to reason about, easier to test, easier to trust.

I'm not saying you should rewrite everything in Haskell or go full functional overnight. But I do think some of these patterns can make a real difference in your Python code today, even in an OOP codebase. Let's take a look at: pattern matching, algebraic data types, the result pattern, railroad oriented programming, functional core/imperative shell, and parse don't validate.

### Pattern Matching
Let's start with one of the best ways to improve the code expressiveness, the [Pattern Matching](https://docs.python.org/3/tutorial/controlflow.html#tut-match),
pattern matching is a mechanism for checking values against some pattern and also meeting some condition.
Let's take a look:
```python
match status:
  case 400:
    return "Bad request"
  case 404:
    return "Not found"
  case _:
    # else equivalent
```
It looks a lot like a switch, having one of the best parts of switch, the easy readability. But let's explore more:
```python
# combining several literals
match status:
  case 500 | 501 | 503: 
    return "Some server error"

# accessing structure values
coordinate = (4, 2)
match coordinate:
  case (0, 0):
    print("Origin")
  case (0, y):
    print(f"just Y axis with the value: {y}")
  case (x, 0):
    print(f"just X axis with the value: {x}")
  case (x, y):
    print(f"current coordinate: X={x} and Y={y}")

# guards
arr = [1,2]
match arr:
  case []:
    print("empty")
  case [first, second] if second > first:
    print(f"second greater than first")
  case [_, second]:
    print(f"second value: {second}")
```
As you can see, pattern matching can be a great ally when you need to make complex conditions over structures and values, in an easy
way.

### Type System
I think everybody likes the type system in languages, maybe it isn't the best, but at least can help you find silly typos, but in fact it
is a very powerful tool. Let's check how it can improve your code reliability, readability.

#### Algebraic Data Types
Algebraic data types are a way of creating types by combining other types. This is helpful especially when you create your own types.
An ADT is defined for being a `sum` type or a `product` type, maybe the name isn't familiar, but you probably already use them.

A sum type is a range of values that can be chosen, like a boolean, that is an example of sum type. The name came from the number of
possibilities, that is the sum of all possible values.
Product types are different, they combine types instead of making you choose, an example is tuples or records. The name came from the
cartesian product of the sets of its component types, that means that it's the cartesian product of all possible values from each type
it combines.
They also are referred as `OR` and `AND`, because the sum type is a choice between the values, a `OR`, and the product type is a
combination of types, a `AND`.

Ok, give a quick summary of what they are, no code, poor examples, but how you can improve your code using ADT's, right? Well,
like said earlier, the possibility of creating types is a powerful way to model the business logic into your code. To give an example,
let's think about an order that can have a status of `open` or `closed`, you can define it using ADT's like that.
```python
from typing import Literal
from dataclasses import dataclass

@dataclass(frozen=True) # ensure our immutability
class Order: # product type
  status: Literal["open", "closed"] # sum type
```
That way you ensure that the only possible values for status is `open` or `closed` and every time you create an order structure it
needs to follow that pattern or will not pass the type checker.
Another cool thing that will help you ensure that the business logic is being applied right, is using [exhaustiveness checking](https://rustc-dev-guide.rust-lang.org/pat-exhaustive-checking.html).
The idea is that in a condition it will never reach some pattern/condition, like:
```python
from typing import assert_never

order = Order(status="open")
match order.status:
  case "open":
    print("order with status open")
  case "closed":
    print("order with status closed")
  case _ as unreachable:
    assert_never(unreachable)
```
If we add a new status to our order structure, the type checker will complain about reaching a pattern that was to be unreachable,
since the new status is not defined on the previous pattern matching. This is awesome because it will help you modify your business logic
without ignoring the modifications.
#### Bounded Types/New Types
Bounded types or new types are just a fancy name for subtyping and of course it is useful for code readability and type narrowing, for example:
Let's say you have the values name and email from your user and also `send_email` function, to make it safer you could do:
```python
from typing import NewType

UserEmail = NewType("UserEmail", str)
UserName = NewType("UserName", str)

name = UserName("john")
email = UserEmail("john@email.com")

def send_email(email: UserEmail):
  # send the email
```
and if you pass the name to the `send_email` func instead of the email, you're going to receive a type error. Also,
you can use narrow typing, that way you not only guarantee that you pass the correct type value, but also ensure that the
value indeed follows what the type means, like being a real email. The only catch is that in python, the `NewType` does not check at
runtime, so make sure to make strict validations or use runtime check validations.

### Result Pattern
One of the worst things of some languages are the way they handle errors, exceptions are not the best approach, and can be
very confusing when you just "goto" some place on the code that you're not expecting or bubbling up the exception to the
exception of the caller, and bubbling up to another exception...
Returning the error as a value is easier to understand, but just that still needs checking and we are on the same problem of bubbling up
exceptions. That's why some functional languages(Haskell, Rust) use the result pattern, a way of returning either the error or the
value. Enough poor explanation, let's check out how we can do it in Python:

First, we're going to create the result type to use
```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Ok[T, E]:
  value: T

@dataclass(frozen=True)
class Err[T, E]:
  error: E

type Result[T, E] = Ok[T, E] | Err[T, E]
```
Now let's use it on some function:
```python
type Errors = Literal["InvalidEmail"]

def validate_email(email: str) -> Result[UserEmail, Errors]:
  if "@" in email:
    return Ok(UserEmail(email))
  return Err("InvalidEmail")

# calling the function
value = validate_email("wrong_email") # will return Err("InvalidEmail")
```
Look how it makes the code more concise and easy to read, of course I still need to show you how to solve the bubbling up problem and
that's what we're going to do right below.

### Railroad Oriented Programming
So you already implemented the result pattern but don't want a lot of condition checking on your code, how you can avoid that? Using
the railroad oriented programming, and what is that? It's the idea of just following the "success" railway only if it gets success values,
the `Ok()` values in our case, otherwise "switch" to the "failure" railway. That way we can chain function calls and get back the
result of these operations or the error.

To use ROP, let's modify our result, make it a class, add `bind` method to make the "switch" and some helpers, `unwrap` to get the value
on `Ok` and `unwrap_err` to get the `Err` error:
```python
from __future__ import annotations
from dataclasses import dataclass
from typing import Callable, cast

class Result[T, E]:
  def bind[U](self, fn: Callable[[T], Result[U, E]]) -> Result[U, E]:
    if isinstance(self, Ok):
      return fn(self.value)
    return cast(Result[U, E], self)

  def unwrap(self) -> T:
    match self:
      case Ok(value=value):
        return value
      case Err(error=error):
        raise ValueError(f"Unwrap called on Err: {error}")

  def unwrap_err(self) -> E:
    match self:
      case Err(error=error):
        return error
      case Ok(value=value):
        raise ValueError(f"Unwrap_err called on Ok: {value}")


@dataclass(frozen=True)
class Ok[T, E](Result[T, E]):
  value: T

@dataclass(frozen=True)
class Err[T, E](Result[T, E]):
  error: E

```
Nice, here's the breakdown: the `bind` is our "main" function, it will do the "switch" if necessary. The `unwrap`, `unwrap_err` functions
are just helpers to deal with the inner values and the `from __future__ import annotations` is for Python to understand that we're going to use
the class declaration on itself.
Using it:
```python
email = (
  cast(Result[str, Errors], Ok("user_email"))
  .bind(validate_email)
)

result = email.bind(send_email)

match result:
  case Ok():
    print("email sent")
  case Err("InvalidEmail"):
    print("invalid email")
  ... # other errors
```
We're going to use `cast` so the type checker doesn't complain about `Result[str, Never]`, since declaring `Ok` directly will give you this type. To avoid these little catches, I recommend you use the [returns library](https://github.com/dry-python/returns), it will
give all the type safety with easy to use helpers.

But, we have our chaining functions and if some of them give an error we can receive and pattern match the error, awesome right? Not just
that but when you're going to break a bigger chain into a smaller one, using result pattern makes middle checking unnecessary, since if we
got some error we can check it later.

### Functional Core, Imperative Shell
Until now I showed you how you can structure your code using pattern matching, ADT's and ROP, making it more clean, readable and reliable.
But one thing that we can't predict, is how our code deals with the external world, a.k.a IO, and for that the functional programming
has a name: impure/side effect functions.
These are functions that you need to make sure to not mix with your business logic or try, at least, for that you gonna want to "move to
the edge" of your program execution flow, that way will be easier to reason, test and determine your business logic.
For that you can use the [functional core, imperative shell](https://functional-architecture.org/functional_core_imperative_shell/) pattern,
and yes, it looks a lot like port and adapters, that's why I just want to say about the main idea of both, separate what you can predict
from what you can't.
Let's see how it looks using the `send_email` example:
```python
# functional core: pure, no IO
def process_email(raw_email: str) -> Result[UserEmail, Errors]:
  return validate_email(raw_email)

# imperative shell: IO lives here
def handle_email(raw_email: str):
  match process_email(raw_email):
    case Ok(value=email):
      send_email(email)
    case Err(error=error):
      print(f"Error: {error}")
```
`process_email` is pure and easy to test, `handle_email` is where the IO lives. That separation makes a real difference,
because you can test all your business logic without mocking anything, and when something breaks you already know
if the problem is in the logic or in the IO.

### Parse, Don't Validate
If you use FastAPI you're using this idea, and in summary it is about parsing your values at the edge of your program to trusted types instead
of validate them.
Parse the structure from the external world, parse from one "stage" to another, use new types to enforce a constraint and even type your
return.
Still foggy? Let's see some code:
```python
from enum import StrEnum
from dataclasses import dataclass

class OrderStatus(StrEnum):
  open = "open"
  closed = "closed"

@dataclass(frozen=True)
class RawOrder:
  status: str

@dataclass(frozen=True)
class Order:
  status: OrderStatus

@dataclass(frozen=True)
class InvalidOrder:
  reason: str

def parse_order(raw: RawOrder) -> Order | InvalidOrder:
  match raw.status:
    case OrderStatus.open | OrderStatus.closed:
      return Order(status=OrderStatus(raw.status))
    case _:
      return InvalidOrder(
        reason="Invalid order status"
      )
```
This is an example of parsing on the edge of your program and even on error/invalid input you're still returning an expressive value instead of throwing an exception or returning a raw string error.

<br/>
Hope you learned something new or are thinking to start applying some of these patterns. You don't need to change your whole codebase,
just pick what fits you better. Type system messy? Start annotating more. Error handling painful? Try the result pattern.
Complex conditionals? Pattern matching is your friend. I do think that functional programming will make your code more readable and reliable and
the idea of these concepts are, besides the classic ones (pure/impure functions and immutability) are about making your code more expressive while
making good constraints about its behavior.

The idea for this post came from reading the [Rastrian's blog post](https://blog.rastrian.dev/post/why-reliability-demands-functional-programming-adts-safety-and-critical-infrastructure),
I really recommend you to give it a shot. The references below are also a great next step if you want to go deeper.

Also if you wanna give it a shot on these ideas in Python, please, use the [returns library](https://github.com/dry-python/returns), it's a more robust,
production-ready tool for that and has a lot more type-safety, helpers to just get started using.

### References

<.ref_link name="Rastrian blog post" link="https://blog.rastrian.dev/post/why-reliability-demands-functional-programming-adts-safety-and-critical-infrastructure" />
<.ref_link name="Parse, Don't validate" link="https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/" />
<.ref_link name="ADT" link="https://en.wikipedia.org/wiki/Algebraic_data_type" />
<.ref_link name="ROP" link="https://fsharpforfunandprofit.com/posts/recipe-part2/" />
<.ref_link name="Functional core, Imperative shell" link="https://functional-architecture.org/functional_core_imperative_shell/" />
<.ref_link name="Bounded/New Types" link="https://www.learningtypescript.com/articles/branded-types" />
