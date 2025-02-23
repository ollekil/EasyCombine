//
//  IntroView.swift
//  EasyCombine
//
//  Created by 배정길 on 2/20/25.
//

import UIKit

/// 인트로 화면의 UI를 구성하는 뷰
class IntroView: UIView {
    
    /// 스토리 텍스트를 표시하는 레이블
    let storyLabel = UILabel()
    
    /// "모험 시작" 버튼
    let startButton = UIButton()
    
    /// 등장할 캐릭터 이미지
    let characterImageView = UIImageView()
    
    /// 배경 이미지
    let backgroundImageView = UIImageView()

    /// 코드로 뷰를 초기화할 때 호출되는 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    /// 스토리보드(XIB)에서 뷰를 불러올 때 호출되는 생성자
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    /// UI 요소를 추가하고 레이아웃을 설정하는 메서드
    private func setupUI() {
        backgroundColor = .black // 전체 배경색을 검은색으로 설정

        // 배경 이미지 설정
        backgroundImageView.image = UIImage(named: "Introbackground") // 배경 이미지 파일명
        backgroundImageView.contentMode = .scaleAspectFill // 화면을 꽉 채우도록 설정
        backgroundImageView.alpha = 0 // 초기에는 숨김 상태
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)

        // 스토리 텍스트 설정
        storyLabel.textColor = .white // 글씨 색상을 흰색으로 설정
        storyLabel.textAlignment = .center // 가운데 정렬
        storyLabel.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정
        storyLabel.font = UIFont.boldSystemFont(ofSize: 20) // 볼드체, 크기 20
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(storyLabel)

        // 캐릭터 이미지 설정
        characterImageView.image = UIImage(named: "b") // 캐릭터 이미지 파일명
        characterImageView.contentMode = .scaleAspectFit // 비율을 유지하면서 크기 조절
        characterImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // 초기 크기를 50%로 설정
        characterImageView.alpha = 0 // 초기에는 숨김 상태
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(characterImageView)

        // 시작 버튼 설정
        startButton.setTitle("모험 시작!", for: .normal)
        startButton.backgroundColor = .systemBlue // 버튼 배경색을 파란색으로 설정
        startButton.layer.cornerRadius = 10 // 버튼 모서리를 둥글게 설정
        startButton.alpha = 0 // 초기에는 숨김 상태
        startButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startButton)

        // Auto Layout 설정
        NSLayoutConstraint.activate([
            // 배경 이미지: 화면 전체를 채우도록 설정
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // 스토리 텍스트: 화면 상단에서 일정 거리 떨어진 위치에 배치
            storyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            storyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            storyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // 캐릭터 이미지: 화면 중앙에 배치하고, 시작 버튼 위로 약간 띄움
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -50),
            characterImageView.widthAnchor.constraint(equalToConstant: 100),
            characterImageView.heightAnchor.constraint(equalToConstant: 100),

            // 시작 버튼: 화면 하단에 배치
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
