//
//  QuizeRepository.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 외부 데이터 관리 (API, DB, 로컬 저장소 등)
   - 데이터 저장소 인터페이스 및 구현
     - 퀴즈 관련 데이터 관리
 */
// 추후 DefaultQuizRepository 파일은 분리하자
// 이유는 클린 아키텍처의 의존성 역전 원칙(DIP)에 적합하지 않다.
// QuizRepository는 데이터 출처와 관련된 책임만.

//import Foundation
import Combine

protocol QuizRepository {
    func fetchQuizzes() -> AnyPublisher<[Quiz], Error>
}

final class DefaultQuizRepository: QuizRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchQuizzes() -> AnyPublisher<[Quiz], Error> {
        let endpoint = Endpoint(
            path: "/quizzes",
            method: .get,
            headers: ["Authorization": "Bearer YOUR_API_KEY"],
            queryItems: nil,
            body: nil
        )
        return apiClient.request(endpoint)
    }
}
