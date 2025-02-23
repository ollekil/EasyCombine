//
//  Timer+Extensions.swift
//  EasyCombine
//
//  Created by 배정길 on 2/20/25.
//

import Foundation
import Combine

extension Timer {
    /// 일정 간격으로 값을 방출하는 Combine 기반 타이머
    static func publishTypingTimer(interval: TimeInterval = 0.05) -> AnyPublisher<Void, Never> {
        return Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .map { _ in () }  // Void 타입으로 변환 (타이핑 효과에 사용하기 쉽게)
            .eraseToAnyPublisher()
    }
}
