//
//  FieldUseCase.swift
//  EasyCombine
//
//  Created by 배정길 on 3/3/25.
//
import UIKit
import Combine

// MARK: - FieldUseCase
/// 필드 화면에서 발생하는 로직을 처리하는 UseCase
/// - 대화 데이터를 불러오고, 마법사 등장 및 몬스터 등장 타이밍을 제어한다.
class FieldUseCase {
    private let repository: DialogueRepository // 대화 데이터를 가져오는 저장소
    
    /// FieldUseCase 초기화
    /// - Parameter repository: 대화 데이터를 제공하는 저장소 객체
    init(repository: DialogueRepository) {
        self.repository = repository
    }
    
    /// 마법사가 등장하도록 트리거를 발생시킴
    /// - Returns: 1초 후 이벤트가 발생하는 `AnyPublisher<Void, Never>` 반환
    func showWizard() -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success(())) // 1초 후 이벤트 발생
            }
        }.eraseToAnyPublisher()
    }
    
    /// 마법사의 대사를 가져옴
    /// - Returns: 마법사의 대사 배열을 `AnyPublisher<[String], Never>` 형태로 반환
    func getWizardDialogue() -> AnyPublisher<[String], Never> {
        return repository.getWizardDialogue()
    }
    
    /// 몬스터의 대사를 가져옴
    /// - Returns: 몬스터의 대사 배열을 `AnyPublisher<[String], Never>` 형태로 반환
    func getMonsterDialogue() -> AnyPublisher<[String], Never> {
        return repository.getMonsterDialogue()
    }
}



