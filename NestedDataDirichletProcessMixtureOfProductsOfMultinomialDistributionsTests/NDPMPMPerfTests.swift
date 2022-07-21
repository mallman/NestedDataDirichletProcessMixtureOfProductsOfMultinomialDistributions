import XCTest

@testable import NestedDataDirichletProcessMixtureOfProductsOfMultinomialDistributions

let G: Int32 = 20
let S: Int32 = 15
let K: Int32 = 5
let R: Int = 3
let N: Int = 1_000_000

class NDPMPMPerfTests: XCTestCase {
  func testCPUAlgo1() throws {
    print("Generating data")

    let H: [Int32] = generateRandomArray(length: N, upperBound: G)
    let P: [[Int32]] = generateRandom2DArray(length1: N, length2: R, upperBound: S)
    let Q: [[Int32]] = generateRandom2DArray(length1: N, length2: R, upperBound: K)

    print("Running test")

    for _ in 0..<2 {
      let _ = NDPMPM(
        G: Int(G),
        S: Int(S),
        K: Int(K),
        R: R,
        N: N,
        H: H,
        P: P,
        Q: Q)
    }

    measure {
      let _ = NDPMPM(
        G: Int(G),
        S: Int(S),
        K: Int(K),
        R: R,
        N: N,
        H: H,
        P: P,
        Q: Q)
    }
  }

  func testCPUAlgo2() throws {
    print("Generating data")

    let H: [Int32] = generateRandomArray(length: N, upperBound: G)
    let P: [Int32] = generateRandomArray(length: N * R, upperBound: S)
    let Q: [Int32] = generateRandomArray(length: N * R, upperBound: K)

    print("Running test")

    for _ in 0..<2 {
      let _ = NDPMPM2(
        G: Int(G),
        S: Int(S),
        K: Int(K),
        R: R,
        N: N,
        H: H,
        P: P,
        Q: Q)
    }

    measure {
      let _ = NDPMPM2(
        G: Int(G),
        S: Int(S),
        K: Int(K),
        R: R,
        N: N,
        H: H,
        P: P,
        Q: Q)
    }
  }

  func testGPUAlgo() throws {
    print("Generating data")

    let H: [Int32] = generateRandomArray(length: N, upperBound: G)
    let P: [Int32] = generateRandomArray(length: N * R, upperBound: S)
    let Q: [Int32] = generateRandomArray(length: N * R, upperBound: K)

    let computer = try NDPMPMComputer()

    print("Running test")

    for _ in 0..<2 {
      let _ = try computer.NDPMPMGPU(
        G: Int(G),
        S: Int(S),
        K: Int(K),
        R: R,
        N: N,
        H: H,
        P: P,
        Q: Q)
    }

    measure {
      let _ = try! computer.NDPMPMGPU(
        G: Int(G),
        S: Int(S),
        K: Int(K),
        R: R,
        N: N,
        H: H,
        P: P,
        Q: Q)
    }
  }
}
