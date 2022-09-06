## Nested Data Dirichlet Process Mixture Of Products Of Multinomial Distributions for Metal

This is a low-level, Swift+Metal implementation of the algorithm described in [Dirichlet Process Mixture Models for Modeling and Generating Synthetic Versions of Nested Categorical Data](https://projecteuclid.org/journals/bayesian-analysis/volume-13/issue-1/Dirichlet-Process-Mixture-Models-for-Modeling-and-Generating-Synthetic-Versions/10.1214/16-BA1047.full).

This project can be built and run with Apple's CLI build tools or Xcode. With Xcode, simply open `NestedDataDirichletProcessMixtureOfProductsOfMultinomialDistributions.xcodeproj`. There is a single scheme for building and testing. Both unit and performance tests are available, with the performance tests comparing two CPU versus one Metal implementation of this algorithm. On my MacBook Pro M1 Max, I see a performance improvement of about 280x from the second CPU implementation versus GPU, though the GPU measurement is so slight I can't put much stock in that number. Let's just say it's _a lot_ faster.

To be fair, both of the CPU implementations are rather naive, using nested `for` loops. An implementation based on Accelerate could provide a more meaningful performance comparison between CPU and GPU.

### Implementation Note

The Metal implementation, though low-level, is fairly straightforward. I will only note that I use C++ atomics to ensure safe concurrent access to a shared array in the Metal compute kernel. Without this (or some) essential concurrency safety, our implementation is fatally flawed and will produce incorrect results.
