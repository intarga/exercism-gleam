import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type ProgItem {
  Word(String)
  Number(Int)
}

pub type Forth {
  Forth(
    stack: List(Int),
    words: Dict(String, List(ProgItem)),
    prog: List(ProgItem),
  )
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub fn new() -> Forth {
  Forth([], dict.new(), [])
}

pub fn format_stack(f: Forth) -> String {
  f.stack |> list.map(int.to_string) |> list.reverse |> string.join(" ")
}

fn parse_prog(raw: String) -> List(ProgItem) {
  raw
  |> string.uppercase
  |> string.split(" ")
  |> list.map(fn(raw_item) {
    case int.parse(raw_item) {
      Ok(i) -> Number(i)
      Error(_) -> Word(raw_item)
    }
  })
}

fn prog_replace(prog: List(ProgItem), w: String, d: List(ProgItem)) {
  prog
  |> list.flat_map(fn(item) {
    case item == Word(w) {
      True -> d
      False -> [item]
    }
  })
}

fn define_word(f: Forth) -> Result(Forth, ForthError) {
  use #(word, def, prog_rest) <- result.try(case
    list.split_while(f.prog, fn(item) { item != Word(";") })
  {
    #([Word(word), ..def], [Word(";"), ..prog_rest]) ->
      Ok(#(word, def, prog_rest))
    _ -> Error(InvalidWord)
  })

  let def = dict.fold(f.words, def, fn(def, w, d) { prog_replace(def, w, d) })
  let new_words = dict.insert(f.words, word, def)
  Ok(Forth(..f, words: new_words, prog: prog_rest))
}

fn stack_op_1(
  f: Forth,
  op: fn(Int) -> Result(List(Int), ForthError),
) -> Result(Forth, ForthError) {
  case f.stack {
    [l, ..rest] -> {
      use out <- result.try(op(l))
      Ok(Forth(..f, stack: list.append(out, rest)))
    }
    _ -> Error(StackUnderflow)
  }
}

fn stack_op_2(
  f: Forth,
  op: fn(Int, Int) -> Result(List(Int), ForthError),
) -> Result(Forth, ForthError) {
  case f.stack {
    [l, r, ..rest] -> {
      use out <- result.try(op(l, r))
      Ok(Forth(..f, stack: list.append(out, rest)))
    }
    _ -> Error(StackUnderflow)
  }
}

fn handle_primitive(f: Forth, instruction: String) -> Result(Forth, ForthError) {
  case instruction {
    "+" -> stack_op_2(f, fn(l, r) { Ok([r + l]) })
    "-" -> stack_op_2(f, fn(l, r) { Ok([r - l]) })
    "*" -> stack_op_2(f, fn(l, r) { Ok([r * l]) })
    "/" ->
      stack_op_2(f, fn(l, r) {
        case l != 0 {
          True -> Ok([r / l])
          False -> Error(DivisionByZero)
        }
      })
    "DUP" -> stack_op_1(f, fn(x) { Ok([x, x]) })
    "DROP" -> stack_op_1(f, fn(_) { Ok([]) })
    "SWAP" -> stack_op_2(f, fn(l, r) { Ok([r, l]) })
    "OVER" -> stack_op_2(f, fn(l, r) { Ok([r, l, r]) })
    ":" -> define_word(f)
    _ -> Error(UnknownWord)
  }
}

fn eval_to_end(f: Forth) -> Result(Forth, ForthError) {
  case f.prog {
    [instruction, ..rest] -> {
      use f <- result.try(case instruction {
        Number(i) -> Ok(Forth(..f, stack: [i, ..f.stack], prog: rest))
        Word(w) ->
          case dict.get(f.words, w) {
            Ok(def) -> Ok(Forth(..f, prog: list.append(def, rest)))
            Error(_) -> handle_primitive(Forth(..f, prog: rest), w)
          }
      })
      eval_to_end(f)
    }
    [] -> Ok(f)
  }
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  let f = Forth(..f, prog: parse_prog(prog))
  eval_to_end(f)
}
