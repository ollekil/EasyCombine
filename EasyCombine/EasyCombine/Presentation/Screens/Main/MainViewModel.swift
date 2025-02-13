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

 ✅ 비즈니스 로직(confirmCharacterSelection, handleMazeViewDismiss)을 UseCase로 이동
 ✅ ViewModel에서는 UI 상태를 관리하고, 핵심 로직은 UseCase에 위임
 ✅ ViewController → ViewModel → UseCase → Repository의 흐름을 유지하면서 클린 아키텍처 준수
 
 •    ViewModel → UI 상태 관리 + UseCase 호출
 •    UseCase → 캐릭터 선택/초기화 로직
 •    Repository → UserDefaults 저장

 */
// ViewModel은 FetchQuizUseCase를 통해 데이터를 UI 상태로 관리.

import Combine
import UIKit

/// 메인 화면의 ViewModel
/// - 캐릭터 선택 상태를 관리하고, UseCase와 Coordinator를 통해 화면 전환을 수행
final class MainViewModel {
    private let useCase: SelectCharacterUseCase  // ✅ 캐릭터 선택 비즈니스 로직을 담당하는 UseCase
    private let coordinator: MainCoordinatorProtocol  // ✅ 화면 전환을 담당하는 Coordinator
    private var cancellables = Set<AnyCancellable>()  // ✅ Combine에서 사용되는 구독 관리 객체
    
    @Published var balloonText: String = "기본문법 정복하러 가자!"  // ✅ 말풍선 텍스트 상태 관리
    @Published var selectedCharacter: Int? = nil  // ✅ 현재 선택된 캐릭터 인덱스
    @Published var characterSizes: [CGSize] = []  // ✅ 캐릭터 크기 변경 상태 관리

    private var originalCharacterSizes: [CGSize] = []  // ✅ 캐릭터 원본 크기 저장 (애니메이션 원복용)
    private var defaultBalloonText: String = "기본문법 정복하러 가자!"  // ✅ 초기 문구 저장 (취소 시 원래대로 복귀)

    /// ViewModel 초기화
    /// - Parameters:
    ///   - useCase: 캐릭터 선택 로직을 처리하는 UseCase
    ///   - coordinator: 화면 전환을 담당하는 Coordinator
    init(useCase: SelectCharacterUseCase, coordinator: MainCoordinatorProtocol) {
        self.useCase = useCase
        self.coordinator = coordinator
        bind()
    }
    
    /// Combine을 활용한 데이터 바인딩
    private func bind() {
        useCase.balloonText.assign(to: &$balloonText)  // ✅ UseCase의 말풍선 텍스트와 바인딩
        useCase.selectedCharacter.assign(to: &$selectedCharacter)  // ✅ 선택된 캐릭터 상태 바인딩
    }

    /// 초기 캐릭터 크기를 설정
    /// - Parameter sizes: 각 캐릭터의 원본 크기 배열
    func setInitialSizes(_ sizes: [CGSize]) {
        characterSizes = sizes
        originalCharacterSizes = sizes
    }

    /// 선택된 캐릭터의 크기를 확대하고 말풍선 텍스트를 변경
    /// - Parameter index: 선택한 캐릭터의 인덱스 (0, 1, 2)
    func highlightSelectedCharacter(_ index: Int) {
        selectedCharacter = index
        if let character = Character.getCharacter(by: index) {
            balloonText = character.description  // ✅ 선택한 캐릭터에 맞는 문구 설정
        }

        for i in 0..<characterSizes.count {
            characterSizes[i] = i == index ?
                CGSize(width: originalCharacterSizes[i].width * 1.1, height: originalCharacterSizes[i].height * 1.1) :
                originalCharacterSizes[i]  // ✅ 선택된 캐릭터는 크기 확대, 나머지는 원래 크기 유지
        }
    }

    /// 선택 취소 시 크기를 원래대로 복귀
    func resetCharacterSize() {
        selectedCharacter = nil
        characterSizes = originalCharacterSizes
        balloonText = defaultBalloonText  // ✅ 초기 문구로 변경
    }

    /// 캐릭터 선택 확정 후 `UseCase`를 통해 저장 및 화면 전환 처리
    /// - Parameter index: 선택한 캐릭터의 인덱스 (0, 1, 2)
    func confirmCharacterSelection(index: Int) {
        useCase.selectCharacter(index)  // ✅ UseCase에 캐릭터 선택 처리 위임
        coordinator.navigateToMazeViewController()  // ✅ 화면 이동은 Coordinator가 처리
    }

    /// ✅ MazeViewController가 닫힐 때 `UseCase`에서 상태 초기화
    func handleMazeViewDismiss() {
        useCase.resetCharacterSelection()  // ✅ UseCase에서 선택된 캐릭터 초기화
        print("✅ Maze 화면이 닫힘 - ViewModel에서 이벤트 감지됨")
    }
}
