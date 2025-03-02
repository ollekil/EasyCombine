//
//  DialogueRepository.swift
//  EasyCombine
//
//  Created by 배정길 on 3/3/25.
//
import UIKit
import Combine

// MARK: - Repository
/// 대화 데이터를 제공하는 저장소
/// - 마법사와 몬스터의 대사를 관리하고 필요한 데이터를 반환한다.
class DialogueRepository {
    
    /// 마법사의 대사를 반환
    /// - Returns: 마법사의 대사 배열을 `AnyPublisher<[String], Never>` 형태로 제공
    func getWizardDialogue() -> AnyPublisher<[String], Never> {
        return Just([
            "이곳에 데이터의 흐름이 어지럽혀지고 있어...", // 상황 설명
            "데이터가 흘러야 하는데... 네가 이를 막고 있군!", // 문제 제기
            "Combine 마법으로 네 정체를 밝혀주마!" // 결의
        ]).eraseToAnyPublisher()
    }
    
    /// 몬스터의 대사를 반환
    /// - Returns: 몬스터의 대사 배열을 `AnyPublisher<[String], Never>` 형태로 제공
    func getMonsterDialogue() -> AnyPublisher<[String], Never> {
        return Just([
            "하하하! 나는 '끊어진 스트림'! 데이터를 막는 자다!", // 몬스터 자기소개
            "Publisher가 데이터를 보내도, 난 절대 Subscriber에게 넘기지 않지!" // 데이터 흐름을 막겠다는 선언
        ]).eraseToAnyPublisher()
    }
}
