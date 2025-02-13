//
//  SelectCharacterUseCase.swift
//  EasyCombine
//
//  Created by 배정길 on 2/13/25.
//

import Combine

/// 캐릭터 선택 관련 UseCase 프로토콜
protocol SelectCharacterUseCase {
    var selectedCharacter: CurrentValueSubject<Int?, Never> { get }  // ✅ 현재 선택된 캐릭터 상태 관리
    var balloonText: CurrentValueSubject<String, Never> { get }  // ✅ 말풍선 텍스트 상태 관리

    func selectCharacter(_ index: Int)  // ✅ 캐릭터 선택 시 호출
    func resetCharacterSelection()  // ✅ 화면이 닫힐 때 선택 상태 초기화
}

/// 캐릭터 선택 UseCase의 기본 구현
final class DefaultSelectCharacterUseCase: SelectCharacterUseCase {
    let selectedCharacter = CurrentValueSubject<Int?, Never>(nil)
    let balloonText = CurrentValueSubject<String, Never>("기본문법 정복하러 가자!")  // ✅ 기본 값 유지

    private let repository: CharacterSelectionRepository

    /// UseCase 초기화 시 저장된 캐릭터 불러오기
    /// - Parameter repository: 선택한 캐릭터 데이터를 저장하고 불러오는 저장소
    init(repository: CharacterSelectionRepository) {
        self.repository = repository

        // ✅ 저장된 캐릭터가 있을 때만 업데이트
            if let savedIndex = repository.getSelectedCharacter() {
                selectedCharacter.send(savedIndex)
                balloonText.send(Character.getCharacter(by: savedIndex)?.description ?? "기본문법 정복하러 가자!")
            }
    }

    /// 캐릭터를 선택하고 저장
    /// - Parameter index: 선택한 캐릭터의 인덱스
    func selectCharacter(_ index: Int) {
        selectedCharacter.send(index)
        balloonText.send(Character.getCharacter(by: index)?.description ?? "기본문법 정복하러 가자!")
        repository.saveSelectedCharacter(index: index)  // ✅ 선택한 캐릭터 저장
    }

    /// ✅ 화면이 닫힐 때 캐릭터 선택 초기화
    func resetCharacterSelection() {
        selectedCharacter.send(nil)
        balloonText.send("기본문법 정복하러 가자!")
    }
}
