//
//  User.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 비즈니스 로직 (순수한 비즈니스 계층, UI/외부 의존 없음)
   - 도메인 엔티티 정의
     - 사용자 모델
 */

import Foundation

struct User {
    let id: Int
    let name: String
    let level: String
}
