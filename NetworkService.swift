//
//  NetworkService.swift
//  Questionnaire
//
//  Created by Roman on 26/05/2023.
//

import Foundation

/// Network service protocol
protocol NetworkServiceProtocol {

	/// Fetch data
	/// - Parameters:
	///   - url: source url
	///   - completion: completion with the result
	func fetchData(by url: URL, completion: @escaping (Result<Data, Error>) -> Void)

	/// Upload data
	/// - Parameters:
	///   - url: destination url
	///   - data: data
	///   - completion: completion with the result
	func uploadData(by url: URL, data: Data, completion: @escaping (Result<Data, Error>) -> Void)
}

/// Network service
final class NetworkService: NetworkServiceProtocol {

	private var urlSession = URLSession.shared

	func fetchData(by url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
		urlSession.dataTask(with: url) { [weak self] data, response, error in
			DispatchQueue.main.async {
				self?.handleUrlSessionTaskResults(data: data, response: response, error: error, completion: completion)
			}
		}.resume()
	}

	func uploadData(by url: URL, data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
		var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
		request.httpMethod = "POST"

		urlSession.uploadTask(with: request, from: data) { [weak self] data, response, error in
			DispatchQueue.main.async {
				self?.handleUrlSessionTaskResults(data: data, response: response, error: error, completion: completion)
			}
		}.resume()
	}

	// MARK: - Private

	func handleUrlSessionTaskResults(data: Data?,
									 response: URLResponse?,
									 error: Error?,
									 completion: @escaping (Result<Data, Error>) -> Void) {
		if let error = error {
			completion(.failure(error))
		} else if let data = data,
				  !data.isEmpty {
			completion(.success(data))
		} else {
			let error = error ?? CustomError.customError("unknown")
			completion(.failure(error))
		}
	}
}
