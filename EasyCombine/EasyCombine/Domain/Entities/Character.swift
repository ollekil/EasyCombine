//
//  Character.swift
//  EasyCombine
//
//  Created by 배정길 on 2/13/25.
//

import Foundation

/// 캐릭터 정보를 저장하는 데이터 모델 (Entity)
struct Character {
    let id: Int       // 캐릭터의 고유 ID (0: 초딩, 1: 중딩, 2: 고딩)
    let name: String  // 캐릭터 이름
    let description: String  // 캐릭터 설명
    
    /// 전체 캐릭터 목록 (고정 데이터)
    static let allCharacters: [Character] = [
        Character(id: 0, name: "초딩", description: "초딩 캐릭터 선택! 기본기를 다져보자!"),
        Character(id: 1, name: "중딩", description: "중딩 캐릭터 선택! 한 단계 레벨업!"),
        Character(id: 2, name: "고딩", description: "고딩 캐릭터 선택! 실전으로 가보자!")
    ]
    
    /// 캐릭터 ID로 특정 캐릭터 찾기
    static func getCharacter(by id: Int) -> Character? {
        return allCharacters.first { $0.id == id }
    }
}
