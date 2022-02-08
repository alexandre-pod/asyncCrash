import Foundation

print("Start")
runAsync {

    let concurrentTaskCount = 100
    let repeatingTaskCount = 100

    let actor1 = Actor1()

    try await withThrowingTaskGroup(of: Void.self) { group in
        for _ in 0..<concurrentTaskCount {
            group.addTask {
                for _ in 0..<repeatingTaskCount {
                    _ = try await actor1.value()
                }
            }
        }
        try await group.waitForAll()
    }
}
print("End")

// MARK: - Actors

actor Actor1 {

    let actor2 = Actor2()

    func value() async throws {
        // Code causing crash :
//        if await actor2.cache.keys.contains("this contains call cause a use of deallocated memory") { return }

//        async let keys = self.actor2.cache.keys
//        if await keys.contains("this contains call cause a use of deallocated memory") { return }

//        _ = await actor2.cache.keys.map { _ in 0 }

//        _ = await actor2.cache.values.map { _ in 0 }

        // Non crashing alternatives

//        let keys = await actor2.cache.keys
//        if keys.contains("this contains call cause a use of deallocated memory") { return }

//        let keys2 = await actor2.cache.keys
//        _ = keys2.map { _ in 0 }

//        let values = await actor2.cache.values
//        _ = values.map { _ in 0 }

        try await actor2.updateCacheInMultipleContinuations()
    }
}


actor Actor2 {

    private(set) var cache: [String: String] = [:]

    func updateCacheInMultipleContinuations() async throws {
        cache[""] = ""
    }
}

// MARK: - Utils

func runAsync(_ body: @escaping () async throws -> Void) {
    let semaphore = DispatchSemaphore(value: 0)

    Task.detached {
        try await body()
        semaphore.signal()
    }

    semaphore.wait()
}
