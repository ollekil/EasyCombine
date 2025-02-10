//
//  FetchUsersUseCase.swift
//  EasyCombine
//
//  Created by 배정길 on 2/11/25.
//

import Foundation

final class FetchUsersUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute() -> [User] {
        return userRepository.fetchUsers()
    }
}
