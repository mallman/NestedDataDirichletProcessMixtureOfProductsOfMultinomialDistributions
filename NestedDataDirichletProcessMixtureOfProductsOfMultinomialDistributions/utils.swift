import CwlUtils

func generateRandomArray(length: Int, upperBound: Int32) -> [Int32] {
  var generator = MersenneTwister()
  var result: [Int32] = Array(repeating: 0, count: length)
  for i in 0..<length {
    result[i] = Int32.random(in: 0..<upperBound, using: &generator)
  }
  return result
}

func generateRandom2DArray(length1: Int, length2: Int, upperBound: Int32) -> [[Int32]] {
  var generator = MersenneTwister()
  var result: [[Int32]] = Array(repeating: Array(repeating: 0, count: length2), count: length1)
  for i in 0..<length1 {
    for j in 0..<length2 {
      result[i][j] = Int32.random(in: 0..<upperBound, using: &generator)
    }
  }
  return result
}
