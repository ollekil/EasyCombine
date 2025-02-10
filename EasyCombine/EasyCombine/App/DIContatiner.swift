//
//  DIContatiner.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 앱의 진입점과 핵심 관리 역할
   - 의존성 주입 컨테이너
 */

import Foundation

final class DIContainer {
    // MARK: - Properties

    // Network
    private let apiClient: APIClient

    // Repositories
    private let quizRepository: QuizRepository
    private let userRepository: UserRepository

    // UseCases
    private let fetchQuizUseCase: FetchQuizUseCase

    // MARK: - Initializer
    init() {
        // APIClient 초기화
        self.apiClient = DefaultAPIClient()

        // Repository 초기화
        self.quizRepository = DefaultQuizRepository(apiClient: apiClient)
        self.userRepository = DefaultUserRepository()

        // UseCase 초기화
        self.fetchQuizUseCase = FetchQuizUseCase(quizRepository: quizRepository)
    }

    // MARK: - ViewModel Factory
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(fetchQuizUseCase: fetchQuizUseCase)
    }

    func makeQuizViewModel() -> QuizViewModel {
        return QuizViewModel(fetchQuizUseCase: fetchQuizUseCase)
    }

    func makeMazeViewModel() -> MazeViewModel {
        return MazeViewModel(userRepository: userRepository)
    }
}
