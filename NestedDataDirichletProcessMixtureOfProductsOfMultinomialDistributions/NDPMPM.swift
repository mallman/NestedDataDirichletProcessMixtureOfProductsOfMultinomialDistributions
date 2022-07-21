/*
 G =20 number of hh classes
 S = 15 number of person classes under each hh class
 K =5 number of values our discrete target can take
 R =3 number of members per HH
 H: dim=N, Int32 vals [0,G)
 P: dim=N,R Int32 vals [0,S)
 Q: dim=N,R Int32 vals [0,K)
 C = zeros (G,S,K)
 FOR i in range(N)
 FOR j in range(3)
 C[H[i], P[i,j], Q[i,j]] += 1
 */

func NDPMPM(
  G: Int, // number of hh classes
  S: Int, // number of person classes under each hh class
  K: Int, // number of values our discrete target can take
  R: Int, // number of members per HH
  N: Int, // number of households
  H: [Int32],
  P: [[Int32]],
  Q: [[Int32]]
) -> [[[Int]]] {
  var C: [[[Int]]] = Array(repeating: Array(repeating: Array(repeating: 0, count: K), count: S), count: G)

  for i in 0..<N {
    for j in 0..<R {
      let q = Q[i][j]
      let p = P[i][j]
      let h = H[i]
      C[Int(h)][Int(p)][Int(q)] += 1
    }
  }

  return C
}

func NDPMPM2(
  G: Int, // number of hh classes
  S: Int, // number of person classes under each hh class
  K: Int, // number of values our discrete target can take
  R: Int, // number of members per HH
  N: Int, // number of households
  H: [Int32],
  P: [Int32],
  Q: [Int32]
) -> [Int] {
  var C: [Int] = Array(repeating: 0, count: G * S * K)

  for i in 0..<N {
    for j in 0..<R {
      let g = Int(H[i])
      let s = Int(P[i * R + j])
      let k = Int(Q[i * R + j])
      C[g * S * K + s * K + k] += 1
    }
  }

  return C
}
