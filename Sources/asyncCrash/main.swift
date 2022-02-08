import Foundation

print("Hello World")

let semaphore = DispatchSemaphore(value: 0)

print("Start")

Task {

    let keys = (0...1000).map { String($0) }

    try await withThrowingTaskGroup(of: Void.self) { group in
        for _ in 0..<100 {
            group.addTask {
                for key in keys {
//                    try await Task.sleep(nanoseconds: 1_000_000_000 / 10000)
                    _ = try await MyActor.shared.value(for: key)
                }
            }
        }
        print("Waiting for all")
        try await group.waitForAll()
        print("Waiting done")
    }

//    try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
    semaphore.signal()
}

semaphore.wait()

print("End")


@globalActor actor Runner {
    static let shared = Runner()
}

actor Container {
    private(set) var cache: [String: String] = [:]

    func set(key: String, value: String) {
        cache[key] = value
    }
}
