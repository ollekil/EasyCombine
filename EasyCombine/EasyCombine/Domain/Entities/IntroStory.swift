//
//  IntroStory.swift
//  EasyCombine
//
//  Created by 배정길 on 2/20/25.
//

import Foundation

/// 인트로 화면에서 한 줄씩 등장할 텍스트 모델
struct IntroStory {
    let text: String  // 출력할 텍스트
    let delay: TimeInterval  // 다음 문장까지 대기 시간
}
