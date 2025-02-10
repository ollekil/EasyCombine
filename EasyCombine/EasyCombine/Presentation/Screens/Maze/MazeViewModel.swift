//
//  MazeViewModel.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 미로 화면
       - 미로 화면 상태 관리
 */

import Foundation

final class MazeViewModel {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

//    func getUser() -> User {
//        return userRepository.fetchUser()
//    }
}
