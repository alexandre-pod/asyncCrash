//
//  File.swift
//  
//
//  Created by Alexandre Podlewski on 08/02/2022.
//

import Foundation

actor Loader {

    enum LoadingState {
        case inProgress(Task<String, Error>)
        case completed(String)
        case failed(Error)
    }

    private(set) var cache: [String: LoadingState] = [:]
    private(set) var cache2: [String: String] = [:]

    func set(key: String, value: String) {
//        cache[key] = .completed(value)
    }

    func value(for key: String) async throws -> String {
        if (0...1).randomElement() == 0 {
            let value = ""
            cache2[key] = "no"

            try await Task.sleep(nanoseconds: 1_000_000)

            cache2[key] = value
            return value
        } else {
            return cache2[key] ?? "--"
        }


        if let cached = cache[key] {
            switch cached {
            case .inProgress(let task):
                return try await task.value
            case .completed(let value):
                return value
            case .failed(let error):
                throw error
            }
        }

        let fetchTask = Task.detached {
            return try await self.fetchData(for: key)
        }

        cache[key] = .inProgress(fetchTask)

        do {
            let value = try await fetchTask.value
            set(key: key, value: value)
            return value
        } catch {
            cache[key] = .failed(error)
            throw error
        }
    }

    // MARK: - Private

    private func fetchData(for key: String) async throws -> String {
        try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * Double.random(in: 0...1) / 100))
        return randomString(length: (1...5).randomElement()!)
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
