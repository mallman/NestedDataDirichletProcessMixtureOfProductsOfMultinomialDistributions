import Metal

struct NDPMPMComputer {
  private let device: MTLDevice
  private let commandQueue: MTLCommandQueue
  private let pipelineState: MTLComputePipelineState

  init() throws {
    device = MTLCreateSystemDefaultDevice()!
    guard let commandQueue = device.makeCommandQueue() else {
      throw "Failed to create Metal command queue"
    }
    self.commandQueue = commandQueue

    guard let bundle = Bundle(identifier: "ms.allman.NestedDataDirichletProcessMixtureOfProductsOfMultinomialDistributions") else {
      throw "Failed to load framework bundle"
    }

    let library = try device.makeDefaultLibrary(bundle: bundle)

    let NDPMPMFunctionName = "NDPMPM"
    guard let NDPMPMFunction = library.makeFunction(name: NDPMPMFunctionName) else {
      throw "Failed to create \(NDPMPMFunctionName) Metal function"
    }

    pipelineState = try device.makeComputePipelineState(function: NDPMPMFunction)
  }

  func NDPMPMGPU(
    G: Int, // number of hh classes
    S: Int, // number of person classes under each hh class
    K: Int, // number of values our discrete target can take
    R: Int, // number of members per HH
    N: Int, // number of households
    H: [Int32],
    P: [Int32],
    Q: [Int32]
  ) throws -> UnsafeBufferPointer<Int32> {
    guard let commandBuffer = commandQueue.makeCommandBuffer() else {
      throw "Failed to create Metal command buffer"
    }

    guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
      throw "Failed to create Metal compute encoder"
    }
    computeEncoder.setComputePipelineState(pipelineState)

    let SKR = [S, K, R]
    let SKRBuffer = device.makeBuffer(bytes: SKR, length: SKR.count * MemoryLayout<Int>.stride, options: .cpuCacheModeWriteCombined)!
    computeEncoder.setBuffer(SKRBuffer, offset: 0, index: 0)

    let HBuffer = device.makeBuffer(bytes: H, length: N * MemoryLayout<Int32>.stride, options: .cpuCacheModeWriteCombined)!
    computeEncoder.setBuffer(HBuffer, offset: 0, index: 1)

    let PBuffer = device.makeBuffer(bytes: P, length: N * R * MemoryLayout<Int32>.stride, options: .cpuCacheModeWriteCombined)!
    computeEncoder.setBuffer(PBuffer, offset: 0, index: 2)

    let QBuffer = device.makeBuffer(bytes: Q, length: N * R * MemoryLayout<Int32>.stride, options: .cpuCacheModeWriteCombined)!
    computeEncoder.setBuffer(QBuffer, offset: 0, index: 3)

    let CBuffer = device.makeBuffer(length: G * S * K * MemoryLayout<Int32>.stride)!
    computeEncoder.setBuffer(CBuffer, offset: 0, index: 4)

    let gridSize = MTLSizeMake(N, R, 1)
    let threadgroupSize = MTLSizeMake(pipelineState.threadExecutionWidth, R, 1)
    computeEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadgroupSize)
    computeEncoder.endEncoding()

    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()

    return UnsafeBufferPointer(start: CBuffer.contents().bindMemory(to: Int32.self, capacity: G * S * K), count: G * S * K)
  }
}
