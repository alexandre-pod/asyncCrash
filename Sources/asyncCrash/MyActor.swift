
@globalActor actor MyActor {

    static let shared = MyActor()

    let loader = Loader()

    func value(for key: String) async throws -> String {
        if await loader.cache2.keys.contains(key) {
            return try await loader.value(for: key)
        }

        // Add other cache levels

        return try await loader.value(for: key)
    }
}
