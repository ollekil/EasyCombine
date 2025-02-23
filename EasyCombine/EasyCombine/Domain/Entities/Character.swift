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
    let title: String // 제목
    let message: String // 메시지
    let description: String  // 캐릭터 설명
    
    /// 전체 캐릭터 목록 (고정 데이터)
    static let allCharacters: [Character] = [
        Character(id: 0, name: "초딩", title: "초급 모험가!", message: "아직은 낯설지만,기초를 튼튼하게 다질 시간!", description: "초보자 전용 튜토리얼"),
        Character(id: 1, name: "중딩", title: "중급 도전자!", message: "이제 직접 코드를 작성하며 실력을 키울 차례!", description: "본격적인 전투 돌입"),
        Character(id: 2, name: "고딩", title: "고급 챌린저!", message: "실제 프로젝트를 만들며 실전 경험을 쌓아라!", description: "실전 보스전 돌입")
    ]
    
    /// 캐릭터 ID로 특정 캐릭터 찾기
    static func getCharacter(by id: Int) -> Character? {
        return allCharacters.first { $0.id == id }
    }
}
