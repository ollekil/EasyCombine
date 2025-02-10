//
//  UserRepository.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 외부 데이터 관리 (API, DB, 로컬 저장소 등)
   - 데이터 저장소 인터페이스 및 구현
     - 사용자 관련 데이터 관리
 */

import Foundation

protocol UserRepository {
    func fetchUsers() -> [User]
}

final class DefaultUserRepository: UserRepository {
    func fetchUsers() -> [User] {
        // 더미 데이터 반환
        return [
            User(id: 1, name: "철수", level: "초딩"),
            User(id: 2, name: "영희", level: "중딩"),
            User(id: 3, name: "민수", level: "고딩")
        ]
    }
}
