//
//  DialogBubble.swift
//  EasyCombine
//
//  Created by 배정길 on 3/3/25.
//

import UIKit

// MARK: - DialogueBubble
/// 대화를 표시하는 말풍선 UI 컴포넌트
/// - 마법사와 몬스터의 대사를 표시하는 역할을 한다.
class DialogueBubble: UIView {
    private let label = UILabel() // 대사 내용을 표시할 라벨
    
    /// 초기화 (코드로 생성할 경우 호출됨)
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    /// 스토리보드 사용 불가능 (필수 구현)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 설정 메서드
    private func setupUI() {
        backgroundColor = .white // 말풍선 배경색 (흰색)
        layer.cornerRadius = 10 // 말풍선 모서리를 둥글게 처리
        layer.borderWidth = 1 // 테두리 두께 설정
        layer.borderColor = UIColor.black.cgColor // 테두리 색상 설정
        
        label.textAlignment = .center // 텍스트를 가운데 정렬
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold) // 폰트 설정
        label.numberOfLines = 0 // 여러 줄 지원
        label.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈 설정
        label.textColor = .black 
        addSubview(label) // 라벨을 말풍선에 추가
        
        // 오토레이아웃 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    /// 대사 텍스트 설정 메서드
    /// - Parameter text: 말풍선에 표시할 텍스트
    func setText(_ text: String) {
        label.text = text // 라벨에 텍스트 적용
        label.sizeToFit() // 텍스트 크기에 맞게 조정
        self.frame.size.height = label.frame.height + 20 // 말풍선 크기 조정
    }
}
