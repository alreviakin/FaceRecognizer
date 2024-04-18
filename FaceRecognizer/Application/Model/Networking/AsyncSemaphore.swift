//
//  AsyncSemaphore.swift
//
//
//  Created by alexandr galkin on 16.04.2024.
//

import Foundation

final class AsyncSemaphore: @unchecked Sendable {

    private class Suspension: @unchecked Sendable {
        enum State {
            case pending
            case suspendedUnlessCancelled(UnsafeContinuation<Void, Error>)
            case suspended(UnsafeContinuation<Void, Never>)
            case cancelled
        }
        
        var state: State
        
        init(state: State) {
            self.state = state
        }
    }
    
    // MARK: - Internal State
    
    private var value: Int
    private var suspensions: [Suspension] = []
    private let _lock = NSRecursiveLock()

    init(value: Int) {
        precondition(value >= 0, "AsyncSemaphore requires a value equal or greater than zero")
        self.value = value
    }
    
    deinit {
        precondition(suspensions.isEmpty, "AsyncSemaphore is deallocated while some task(s) are suspended waiting for a signal.")
    }

    private func lock() { _lock.lock() }
    private func unlock() { _lock.unlock() }
    
    func waitUnlessCancelled() async throws {
        lock()
        
        value -= 1
        if value >= 0 {
            defer { unlock() }
            
            do {
                try Task.checkCancellation()
            } catch {
                value += 1
                throw error
            }
            
            return
        }

        let suspension = Suspension(state: .pending)
        
        try await withTaskCancellationHandler {
            try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
                if case .cancelled = suspension.state {
                    unlock()
                    continuation.resume(throwing: CancellationError())
                } else {
                    suspension.state = .suspendedUnlessCancelled(continuation)
                    suspensions.insert(suspension, at: 0) // FIFO
                    unlock()
                }
            }
        } onCancel: {
            lock()
            value += 1
            if let index = suspensions.firstIndex(where: { $0 === suspension }) {
                suspensions.remove(at: index)
            }
            
            if case let .suspendedUnlessCancelled(continuation) = suspension.state {
                unlock()
                continuation.resume(throwing: CancellationError())
            } else {
                suspension.state = .cancelled
                unlock()
            }
        }
    }

    @discardableResult
    public func signal() -> Bool {
        lock()
        
        value += 1
        
        switch suspensions.popLast()?.state { // FIFO
        case let .suspendedUnlessCancelled(continuation):
            unlock()
            continuation.resume()
            return true
        case let .suspended(continuation):
            unlock()
            continuation.resume()
            return true
        default:
            unlock()
            return false
        }
    }
}
