//
//  CharacterSelectionRepository.swift
//  EasyCombine
//
//  Created by 배정길 on 2/13/25.
//

import Foundation
import Combine

/// 캐릭터 선택 정보를 저장하는 저장소 인터페이스 (Repository)
/// - UserDefaults를 활용하여 캐릭터 선택 상태를 저장하고 불러오는 기능 제공
protocol CharacterSelectionRepository {
    /// 선택한 캐릭터를 저장
    /// - Parameter index: 선택한 캐릭터의 인덱스 (0: 초딩, 1: 중딩, 2: 고딩)
    func saveSelectedCharacter(index: Int)
    
    /// 저장된 선택한 캐릭터를 불러옴
    /// - Returns: 저장된 캐릭터 인덱스 (없으면 nil 반환)
    func getSelectedCharacter() -> Int?
}

/// UserDefaults를 활용하여 선택한 캐릭터 정보를 관리하는 클래스
final class UserDefaultsCharacterRepository: CharacterSelectionRepository {
    /// UserDefaults에서 사용할 저장 키
    private let key = "selectedCharacter"
    
    /// 선택한 캐릭터 인덱스를 UserDefaults에 저장
    /// - Parameter index: 선택한 캐릭터의 인덱스
    func saveSelectedCharacter(index: Int) {
        UserDefaults.standard.set(index, forKey: key)
    }
    
    /// 저장된 캐릭터 인덱스를 UserDefaults에서 불러옴
    /// - Returns: 저장된 캐릭터 인덱스 (없으면 nil 반환)
    func getSelectedCharacter() -> Int? {
        return UserDefaults.standard.value(forKey: key) as? Int
    }
}
