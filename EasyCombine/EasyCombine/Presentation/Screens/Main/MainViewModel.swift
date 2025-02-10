//
//  MainViewModel.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 메인 화면
       - 메인 화면 상태 관리
 */
// ViewModel은 FetchQuizUseCase를 통해 데이터를 UI 상태로 관리.

import Foundation

final class MainViewModel {
    private let fetchQuizUseCase: FetchQuizUseCase
    private(set) var users: [User] = []

    init(fetchQuizUseCase: FetchQuizUseCase) {
        self.fetchQuizUseCase = fetchQuizUseCase
    }

//    func getQuizzes() -> [Quiz] {
//        return fetchQuizUseCase.execute()
//    }
    
    func getUser(for index: Int) -> User? {
        guard index < users.count else { return nil }
        return users[index]
    }
}
