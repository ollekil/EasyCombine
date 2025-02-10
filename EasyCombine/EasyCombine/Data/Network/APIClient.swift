//
//  APIClient.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 외부 데이터 관리 (API, DB, 로컬 저장소 등)
   - 네트워크 관련 계층
     - API 호출 로직
 */

import Foundation
import Combine

protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
}

final class DefaultAPIClient: APIClient {
    private let urlSession: URLSession

    init(session: URLSession = .shared) {
        self.urlSession = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let urlRequest = endpoint.urlRequest else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
