//
//  FetchIntroStoryUseCase.swift
//  EasyCombine
//
//  Created by 배정길 on 2/20/25.
//

import Combine

///  인트로 화면에서 사용할 스토리 데이터를 가져오는 유스케이스
/// - ViewModel이 직접 Repository를 호출하지 않고, UseCase를 통해 데이터를 가져올 수 있도록 함
class FetchIntroStoryUseCase {
    ///  스토리 데이터를 제공하는 저장소 (Repository)
    private let repository: IntroStoryRepository

    ///  저장소를 주입받아 초기화
    /// - Parameter repository: `IntroStoryRepository` 프로토콜을 따르는 저장소 객체
    init(repository: IntroStoryRepository) {
        self.repository = repository
    }

    /// 인트로 스토리 데이터를 가져오는 함수
    /// - Returns: `AnyPublisher<[IntroStory], Never>` 형태로 스토리 데이터를 비동기적으로 반환
    func execute() -> AnyPublisher<[IntroStory], Never> {
        return repository.fetchIntroStory()
    }
}
