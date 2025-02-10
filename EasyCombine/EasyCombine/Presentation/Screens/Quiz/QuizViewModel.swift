//
//  QuizViewModel.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 퀴즈 화면
       - 퀴즈 화면 뷰 컨트롤러
 */

import Foundation
import Combine

final class QuizViewModel {
    private let fetchQuizUseCase: FetchQuizUseCase
    private var cancellables = Set<AnyCancellable>()

    @Published var quizzes: [Quiz] = []

    init(fetchQuizUseCase: FetchQuizUseCase) {
            self.fetchQuizUseCase = fetchQuizUseCase
        }

    func fetchQuizzes() {
        fetchQuizUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Fetched quizzes successfully")
                case .failure(let error):
                    print("Failed to fetch quizzes: \(error)")
                }
            }, receiveValue: { [weak self] quizzes in
                self?.quizzes = quizzes
            })
            .store(in: &cancellables)
    }
}
