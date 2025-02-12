//
//  SelectCharacterUseCase.swift
//  EasyCombine
//
//  Created by 배정길 on 2/13/25.
//

import Combine

/// 캐릭터 선택 기능을 수행하는 UseCase 프로토콜
/// - 선택한 캐릭터 정보를 관리하고, 선택 시 말풍선 텍스트를 변경하는 역할을 수행
protocol SelectCharacterUseCase {
    /// 현재 선택된 캐릭터 ID (없으면 nil)
    var selectedCharacter: CurrentValueSubject<Int?, Never> { get }
    
    /// 말풍선에 표시될 텍스트
    var balloonText: CurrentValueSubject<String, Never> { get }
    
    /// 캐릭터를 선택하는 메서드
    /// - Parameter index: 선택한 캐릭터의 ID (0: 초딩, 1: 중딩, 2: 고딩)
    func selectCharacter(_ index: Int)
}

/// 캐릭터 선택 기능을 실제로 수행하는 기본 구현 클래스
/// - 캐릭터 선택 시 UserDefaults에 저장하고, 말풍선 텍스트를 변경함
final class DefaultSelectCharacterUseCase: SelectCharacterUseCase {
    /// 현재 선택된 캐릭터 ID를 관리하는 Subject (초기값: nil)
    let selectedCharacter = CurrentValueSubject<Int?, Never>(nil)
    
    /// 말풍선에 표시될 텍스트 (초기값: "기본문법 정복하러 가자!")
    let balloonText = CurrentValueSubject<String, Never>("기본문법 정복하러 가자!")
    
    /// 선택한 캐릭터를 저장하는 저장소 (UserDefaults 사용)
    private let repository: CharacterSelectionRepository
    
    /// UseCase 초기화 시 기존 저장된 선택 캐릭터 정보를 불러옴
    /// - Parameter repository: 캐릭터 선택 정보를 저장하고 불러오는 저장소
    init(repository: CharacterSelectionRepository) {
        self.repository = repository
        
        // 앱 실행 시 저장된 캐릭터 불러오기 (UserDefaults에서 데이터 로드)
        if let savedIndex = repository.getSelectedCharacter(),
           let savedCharacter = Character.getCharacter(by: savedIndex) {
            selectedCharacter.send(savedCharacter.id) // 저장된 캐릭터 선택
            balloonText.send(savedCharacter.description) // 말풍선 텍스트 업데이트
        }
    }
    
    /// 사용자가 캐릭터를 선택했을 때 실행되는 메서드
    /// - 선택한 캐릭터 인덱스를 업데이트하고, 말풍선 텍스트를 변경하며, UserDefaults에 저장함
    /// - Parameter index: 선택한 캐릭터의 ID (0: 초딩, 1: 중딩, 2: 고딩)
    func selectCharacter(_ index: Int) {
        guard let character = Character.getCharacter(by: index) else { return }
        
        selectedCharacter.send(character.id) // 선택된 캐릭터 ID 업데이트
        balloonText.send(character.description) // 말풍선 텍스트 변경
        
        // 선택한 캐릭터를 UserDefaults에 저장
        repository.saveSelectedCharacter(index: character.id)
    }
}
