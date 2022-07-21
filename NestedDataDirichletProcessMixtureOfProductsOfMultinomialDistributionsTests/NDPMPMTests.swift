import XCTest
@testable import NestedDataDirichletProcessMixtureOfProductsOfMultinomialDistributions

class NDPMPMTests: XCTestCase {
  func testAlgos() throws {
    let G: Int32 = 20
    let S: Int32 = 15
    let K: Int32 = 5
    let R: Int = 3
    let N: Int = 1

    let H: [Int32] = generateRandomArray(length: N, upperBound: G)
    let P: [[Int32]] = (0..<N).map({_ in generateRandomArray(length: R, upperBound: S)})
    let Q: [[Int32]] = (0..<N).map({ _ in generateRandomArray(length: R, upperBound: K)})

    let C1 = NDPMPM(
      G: Int(G),
      S: Int(S),
      K: Int(K),
      R: R,
      N: N,
      H: H,
      P: P,
      Q: Q)

    let flatP = P.flatMap({$0})
    let flatQ = Q.flatMap({$0})

    let C2 = NDPMPM2(
      G: Int(G),
      S: Int(S),
      K: Int(K),
      R: R,
      N: N,
      H: H,
      P: flatP,
      Q: flatQ)

    let computer = try NDPMPMComputer()
    let C3 = try computer.NDPMPMGPU(
      G: Int(G),
      S: Int(S),
      K: Int(K),
      R: R,
      N: N,
      H: H,
      P: flatP,
      Q: flatQ)

    for g in 0..<G {
      for s in 0..<S {
        for k in 0..<K {
          let index = Int(g * S * K + s * K + k)
          assert(C1[Int(g)][Int(s)][Int(k)] == C2[index])
          assert(C1[Int(g)][Int(s)][Int(k)] == C3[index])
        }
      }
    }
  }
}

