//
//  NetworkRequestProtocol+Execution.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Holds the default implementation of actual request executions, as defined in `NetworkRequest.execute(_:)`.
///
/// Supports multiplatforms such as macOS, iOS and Linux / Heroku.
public extension NetworkRequest {
    
    // MARK: - Default Execution
    
    /// Executes the `NetworkRequest.getter:request` asynchronously and returns the `NetworkRequestResult`.
    ///
    ///  Failed requests are to be retried `n` times, according to the `numberOfRetries` of `NetworkRequest.getter:settings`.
    ///
    /// - Returns: `NetworkRequestResult`.
    func execute(attemptNumber: Int = 1) async -> NetworkRequestResult {
        let urlRequest: URLRequest
        do {
            urlRequest = try request
        } catch {
            return .failure(.invalidRequest(error: error))
        }
        
        let result: NetworkRequestResult
#if os(macOS) || os(iOS)
        result = await runOnApplePlatforms(request: urlRequest)
#elseif canImport(FoundationNetworking)
        result = await runOnLinux(request: urlRequest)
#endif
        switch result {
        case .success:
            return result
        case .failure:
            if attemptNumber <= settings.numberOfRetries {
                log(message: "Retrying... \(attemptNumber) of \(settings.numberOfRetries)")
                try? await Task.sleep(nanoseconds: 1_000_000_000 * settings.delayBetweenRetries)
                return await execute(attemptNumber: attemptNumber + 1)
            } else {
                return result
            }
        }
    }
}

// MARK: - Private

private extension NetworkRequest {
    
#if os(macOS) || os(iOS)
    /// `async/await` can be simply called on macOS and iOS platforms; no further action is needed.
    func runOnApplePlatforms(request: URLRequest) async -> NetworkRequestResult {
        do {
            let (data, response) = try await session.data(for: request)
            return handleResult(data: data, response: response)
        } catch {
            return .failure(.requestFailed(error: error))
        }
    }
#endif
    
    /// `async/await` isn't fully ported to Linux; use "**withCheckedContinuation(function:_:)**" instead.
    func runOnLinux(request: URLRequest) async -> NetworkRequestResult {
        let (data, response, error) = await withCheckedContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                continuation.resume(returning: (data, response, error))
            }.resume()
        }
        return handleResult(data: data, response: response, error: error)
    }
}
