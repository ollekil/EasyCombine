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

import Combine

/// Main 화면의 ViewModel
/// - 캐릭터 선택 상태를 관리하고, UseCase와 연결하여 UI 업데이트를 담당함.
final class MainViewModel {
    private let useCase: SelectCharacterUseCase
    private var cancellables = Set<AnyCancellable>() // Combine에서 사용되는 구독 관리 객체
    
    /// 말풍선에 표시될 텍스트 (기본값: "기본문법 정복하러 가자!")
    @Published var balloonText: String = "기본문법 정복하러 가자!"
    
    /// 현재 선택된 캐릭터 (0: 초딩, 1: 중딩, 2: 고딩)
    @Published var selectedCharacter: Int? = nil
    
    /// - Parameter useCase: 캐릭터 선택 관련 비즈니스 로직을 담당하는 UseCase
    init(useCase: SelectCharacterUseCase) {
        self.useCase = useCase
        bind()
    }
    
    /// UseCase와 ViewModel의 데이터를 바인딩하여 UI가 자동으로 갱신되도록 설정
    private func bind() {
        // 말풍선 텍스트를 UseCase에서 받아와 자동 업데이트
        useCase.balloonText
            .assign(to: &$balloonText)
        
        // 선택된 캐릭터 인덱스를 UseCase에서 받아와 자동 업데이트
        useCase.selectedCharacter
            .assign(to: &$selectedCharacter)
    }
    
    /// 캐릭터 선택 시 호출 (UI에서 버튼을 눌렀을 때 실행됨)
    /// - Parameter index: 선택한 캐릭터의 인덱스 (0: 초딩, 1: 중딩, 2: 고딩)
    func selectCharacter(_ index: Int) {
        useCase.selectCharacter(index)
    }
}
