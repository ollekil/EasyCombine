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
import UIKit

final class MainViewModel {
    private let useCase: SelectCharacterUseCase
    private let coordinator: MainCoordinatorProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var balloonText: String = "기본문법 정복하러 가자!"
    @Published var selectedCharacter: Int? = nil
    @Published var characterSizes: [CGSize] = []
    
    private var originalCharacterSizes: [CGSize] = []
    private var defaultBalloonText: String = "기본문법 정복하러 가자!"

    init(useCase: SelectCharacterUseCase, coordinator: MainCoordinatorProtocol) {
        self.useCase = useCase
        self.coordinator = coordinator
        bind()
    }
    
    private func bind() {
        useCase.balloonText.assign(to: &$balloonText)
        useCase.selectedCharacter.assign(to: &$selectedCharacter)
    }

    func setInitialSizes(_ sizes: [CGSize]) {
        characterSizes = sizes
        originalCharacterSizes = sizes
    }

    func highlightSelectedCharacter(_ index: Int) {
        selectedCharacter = index
        if let character = Character.getCharacter(by: index) {
            balloonText = character.description
        }

        for i in 0..<characterSizes.count {
            characterSizes[i] = i == index ?
                CGSize(width: originalCharacterSizes[i].width * 1.1, height: originalCharacterSizes[i].height * 1.1) :
                originalCharacterSizes[i]
        }
    }

    func resetCharacterSize() {
        selectedCharacter = nil
        characterSizes = originalCharacterSizes
        balloonText = defaultBalloonText
    }

    func confirmCharacterSelection(index: Int) {
        useCase.selectCharacter(index)
        coordinator.navigateToMazeViewController()
    }

    /// ✅ MazeViewController가 닫힐 때 호출됨
    func handleMazeViewDismiss() {
        balloonText = "기본문법 정복하러 가자!"  // ✅ 초기 문구로 변경
        print("✅ Maze 화면이 닫힘 - MainViewModel에서 이벤트 감지됨")
    }
}
