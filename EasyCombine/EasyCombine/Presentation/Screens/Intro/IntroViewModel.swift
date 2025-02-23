//
//  IntroViewModel.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/19/25.
//

import Foundation
import Combine

/// 인트로 화면의 데이터 및 로직을 관리하는 ViewModel
class IntroViewModel {
    
    /// 인트로 스토리를 가져오는 유스케이스
    private let fetchIntroStoryUseCase: FetchIntroStoryUseCase
    
    /// 인트로에 표시될 스토리 목록
    private var storyTexts: [IntroStory] = []
    
    /// 현재 출력 중인 스토리의 인덱스
    private var currentStoryIndex = 0
    
    /// 타이머 관련 Combine 구독을 저장하는 컬렉션
    private var timerCancellables = Set<AnyCancellable>()

    /// 현재 표시될 텍스트 (한 글자씩 출력)
    let currentStoryText = CurrentValueSubject<String, Never>("")
    
    /// 캐릭터를 등장시키는 신호 (스토리 출력 후 실행)
    let showCharacter = PassthroughSubject<Void, Never>()
    
    /// 시작 버튼을 등장시키는 신호 (배경 등장 후 실행)
    let showStartButton = PassthroughSubject<Void, Never>()
    
    /// 배경을 등장시키는 신호 (캐릭터가 등장한 후 실행)
    let showBackground = PassthroughSubject<Void, Never>()

    /// ViewModel 초기화 (유스케이스 주입)
    init(fetchIntroStoryUseCase: FetchIntroStoryUseCase) {
        self.fetchIntroStoryUseCase = fetchIntroStoryUseCase
    }

    /// 인트로 스토리 애니메이션을 시작
    func startStoryAnimation() {
        fetchIntroStoryUseCase.execute()
            .sink { [weak self] stories in
                print("ViewModel: \(stories.count)개의 스토리를 로드함")
                self?.storyTexts = stories
                self?.currentStoryIndex = 0
                self?.displayNextStory()
            }
            .store(in: &timerCancellables)
    }

    /// 한 글자씩 출력하는 애니메이션 (타이핑 효과)
    private func displayNextStory() {
        // 모든 스토리를 출력했다면 캐릭터 등장 신호를 보냄
        guard currentStoryIndex < storyTexts.count else {
            print("모든 스토리 출력 완료 - 캐릭터 등장!")
            showCharacter.send(())
            return
        }

        let story = storyTexts[currentStoryIndex]  // 현재 출력할 스토리
        var currentText = ""  // 한 글자씩 추가할 변수
        currentStoryText.send("")  // UI 초기화

        timerCancellables.removeAll()  // 기존 타이머 구독 제거

        // 0.05초마다 한 글자씩 출력하는 타이머 실행
        Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if currentText.count < story.text.count {
                    let index = story.text.index(story.text.startIndex, offsetBy: currentText.count)
                    currentText.append(story.text[index])
                    self.currentStoryText.send(currentText)  // 한 글자씩 업데이트
                } else {
                    // 현재 문장 출력이 끝나면 다음 문장으로 이동
                    self.timerCancellables.removeAll()
                    DispatchQueue.main.asyncAfter(deadline: .now() + story.delay) {
                        self.currentStoryIndex += 1
                        self.displayNextStory()
                    }
                }
            }
            .store(in: &timerCancellables)
    }
}
