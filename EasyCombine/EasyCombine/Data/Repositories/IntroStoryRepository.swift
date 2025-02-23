//
//  IntroStoryRepository.swift
//  EasyCombine
//
//  Created by 배정길 on 2/20/25.
//

import Combine

/// 인트로 텍스트 데이터를 관리하는 저장소 프로토콜
/// - 다양한 데이터 소스 (로컬, 네트워크 등)에서 인트로 스토리를 가져올 수 있도록 인터페이스를 정의
protocol IntroStoryRepository {
    /// 인트로 스토리 데이터를 가져오는 함수
    /// - Returns: `AnyPublisher<[IntroStory], Never>` 형태로 데이터를 비동기 제공
    func fetchIntroStory() -> AnyPublisher<[IntroStory], Never>
}

/// 인트로 텍스트 데이터를 제공하는 기본 저장소 구현체
/// - 현재는 로컬 데이터(고정된 배열)에서 데이터를 가져오지만, 추후 네트워크 연동 가능
class DefaultIntroStoryRepository: IntroStoryRepository {
    /// 저장된 인트로 스토리 데이터를 반환
    /// - Returns: `AnyPublisher<[IntroStory], Never>` 형태로 Combine을 활용해 반환
    func fetchIntroStory() -> AnyPublisher<[IntroStory], Never> {
        let stories = [
            IntroStory(text: "📜 오래 전, 데이터 왕국은 평화로웠다...", delay: 1.5),
            IntroStory(text: "하지만, 갑자기 데이터 흐름이 끊기고 왕국은 혼돈에 빠졌다!", delay: 1.5),
            IntroStory(text: "데이터를 정화하고 원래 상태로 되돌릴 유일한 방법은...", delay: 1.5),
            IntroStory(text: "'Combine 마법'을 깨우는 것뿐!", delay: 1.5),
            IntroStory(text: "🔥 당신은 이제 초급 모험가로서 첫걸음을 내딛는다!", delay: 1.5),
            IntroStory(text: "Publisher와 Subscriber의 힘을 배워 데이터를 복구해야 한다!", delay: 1.5)
        ]

        print("fetchIntroStory() 호출됨 - 데이터 개수: \(stories.count)")
        return Just(stories)
            .eraseToAnyPublisher()
    }
}
