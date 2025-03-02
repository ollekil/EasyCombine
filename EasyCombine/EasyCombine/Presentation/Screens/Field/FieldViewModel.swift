//
//  FieldViewModel.swift
//  EasyCombine
//
//  Created by 배정길 on 3/3/25.
//
import UIKit
import Combine

// MARK: - FieldViewModel
/// 필드 화면의 상태를 관리하는 ViewModel
/// - 마법사와 몬스터의 등장, 대사 진행, 전투 화면 전환 등의 로직을 처리한다.
class FieldViewModel {
    private var cancellables = Set<AnyCancellable>() // Combine을 활용한 비동기 이벤트 구독 관리
    private let useCase: FieldUseCase // 필드 관련 유스케이스
    private var dialogues: [String] = [] // 현재 진행 중인 대사 목록
    private var dialogueIndex = 0 // 현재 대사 인덱스
    private var dialogueSource: String = "" // 현재 대사가 마법사 것인지, 몬스터 것인지 구분
    
    // 이벤트 발생을 위한 퍼블리셔
    let wizardAppeared = PassthroughSubject<Void, Never>() // 마법사 등장 이벤트
    let monsterAppeared = PassthroughSubject<Void, Never>() // 몬스터 등장 이벤트
    let dialogueText = PassthroughSubject<String, Never>() // 대사 출력 이벤트
    let moveToCenter = PassthroughSubject<Void, Never>() // 마법사와 몬스터가 중앙으로 이동하는 이벤트
    
    /// ViewModel 초기화
    /// - Parameter useCase: 필드 관련 유스케이스를 주입받음
    init(useCase: FieldUseCase) {
        self.useCase = useCase
    }
    
    /// 게임 시퀀스 시작 - 마법사 등장
    func startSequence() {
        useCase.showWizard().sink { [weak self] in
            self?.wizardAppeared.send() // 마법사 등장 이벤트 발생
        }.store(in: &cancellables)
    }
    
    /// 마법사의 대사 시작
    func startWizardDialogue() {
        useCase.getWizardDialogue().sink { [weak self] dialogues in
            self?.dialogues = dialogues // 마법사 대사 리스트 저장
            self?.dialogueSource = "wizard" // 현재 대사가 마법사 것임을 표시
            self?.dialogueIndex = 0 // 대사 인덱스 초기화
            self?.nextDialogue() // 첫 번째 대사 출력
        }.store(in: &cancellables)
    }
    
    /// 몬스터의 대사 시작
    func startMonsterDialogue() {
        useCase.getMonsterDialogue().sink { [weak self] dialogues in
            self?.dialogues = dialogues // 몬스터 대사 리스트 저장
            self?.dialogueSource = "monster" // 현재 대사가 몬스터 것임을 표시
            self?.dialogueIndex = 0 // 대사 인덱스 초기화
            self?.nextDialogue() // 첫 번째 대사 출력
        }.store(in: &cancellables)
    }
    
    /// 다음 대사 출력
    func nextDialogue() {
        guard dialogueIndex < dialogues.count else {
            if dialogueSource == "wizard" {
                // 마법사 대사가 끝나면 0.5초 후 몬스터 등장
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.monsterAppeared.send()
                }
            } else {
                // 몬스터 대사가 끝나면 마법사와 몬스터가 중앙으로 이동
                moveToCenter.send()
            }
            return
        }
        
        // 현재 대사 출력 후 인덱스 증가
        dialogueText.send(dialogues[dialogueIndex])
        dialogueIndex += 1
    }
    
    /// 전투 화면으로 전환하는 메서드 (추후 구현 예정)
    func transitionToBattle() {}
}
