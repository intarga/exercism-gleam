import gleam/bit_array
import gleam/list
import gleam/result

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0
    Cytosine -> 1
    Guanine -> 2
    Thymine -> 3
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0 -> Ok(Adenine)
    1 -> Ok(Cytosine)
    2 -> Ok(Guanine)
    3 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  dna
  |> list.map(fn(nucleotide) { <<encode_nucleotide(nucleotide):2>> })
  |> bit_array.concat
}

fn dna_to_list(dna: BitArray, dna_list: List(Int)) -> Result(List(Int), Nil) {
  case dna {
    <<nucleotide:2, rest:bits>> ->
      dna_to_list(rest, list.append(dna_list, [nucleotide]))
    <<>> -> Ok(dna_list)
    _ -> Error(Nil)
  }
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  use dna_list <- result.try(dna_to_list(dna, []))
  dna_list |> list.try_map(decode_nucleotide)
}
