//
//  FetchQuizUseCase.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 비즈니스 로직 (순수한 비즈니스 계층, UI/외부 의존 없음)
   - 유스케이스 (도메인 로직 처리)
     - 퀴즈 데이터를 가져오는 유스케이스
 */
// FetchQuizUseCase는 비즈니스 로직 처리.

import Combine

final class FetchQuizUseCase {
    private let quizRepository: QuizRepository

    init(quizRepository: QuizRepository) {
        self.quizRepository = quizRepository
    }

    func execute() -> AnyPublisher<[Quiz], Error> {
        return quizRepository.fetchQuizzes()
    }
}
