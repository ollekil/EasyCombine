//
//  IntroView.swift
//  EasyCombine
//
//  Created by 배정길 on 2/20/25.
//

import UIKit

/// ✅ 인트로 화면의 UI를 담당하는 뷰
class IntroView: UIView {
    
    /// 🔹 스토리 텍스트를 표시하는 레이블
    let storyLabel = UILabel()
    
    /// 🔹 "모험 시작!" 버튼
    let startButton = UIButton()
    
    /// 🔹 등장할 캐릭터 이미지
    let characterImageView = UIImageView()
    
    /// 🔹 배경 이미지 (인트로 화면의 배경)
    let backgroundImageView = UIImageView()

    /// ✅ 코드로 초기화할 때 실행되는 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()  // UI 설정 함수 호출
    }

    /// ✅ 스토리보드 또는 XIB로 초기화할 때 실행되는 생성자
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()  // UI 설정 함수 호출
    }

    /// ✅ UI를 구성하는 요소들을 추가하고 Auto Layout을 설정하는 메서드
    private func setupUI() {
        backgroundColor = .black  // 배경색을 검은색으로 설정

        // ✅ 배경 이미지 설정
        backgroundImageView.image = UIImage(named: "Introbackground") // 배경 이미지 파일명
        backgroundImageView.contentMode = .scaleAspectFill  // 화면을 꽉 채우도록 설정
        backgroundImageView.alpha = 0  // 초기에 투명하게 설정
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)

        // ✅ 스토리 텍스트 설정
        storyLabel.textColor = .white  // 글씨 색상을 흰색으로 설정
        storyLabel.textAlignment = .center  // 가운데 정렬
        storyLabel.numberOfLines = 0  // 여러 줄 지원
        storyLabel.font = UIFont.boldSystemFont(ofSize: 20)  // 볼드체, 크기 20
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(storyLabel)

        // ✅ 캐릭터 이미지 설정 (초기 크기를 50%로 설정)
        characterImageView.image = UIImage(named: "b")  // 캐릭터 이미지 파일명
        characterImageView.contentMode = .scaleAspectFit  // 비율 유지하면서 조절
        characterImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)  // 초기에 크기를 50%로 설정
        characterImageView.alpha = 0  // 초기에 숨김 상태
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(characterImageView)

        // ✅ 시작 버튼 설정
        startButton.setTitle("🚀 모험 시작!", for: .normal)  // 버튼 텍스트 설정
        startButton.backgroundColor = .systemBlue  // 버튼 배경색 파란색
        startButton.layer.cornerRadius = 10  // 버튼 모서리 둥글게
        startButton.alpha = 0  // 초기에 숨김 상태
        startButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startButton)

        // ✅ Auto Layout 설정
        NSLayoutConstraint.activate([
            // 🔹 배경 이미지 전체 화면 채우기
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // 🔹 스토리 텍스트 중앙 정렬
            storyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            storyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            storyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // 🔹 캐릭터 이미지 중앙 정렬 및 버튼 위로 50px 조정
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -50), // 🔥 버튼 위로 50px 이동
            characterImageView.widthAnchor.constraint(equalToConstant: 100),
            characterImageView.heightAnchor.constraint(equalToConstant: 100),

            // 🔹 시작 버튼 중앙 정렬
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
