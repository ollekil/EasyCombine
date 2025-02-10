//
//  CustomButton.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 재사용 가능한 UI 컴포넌트
     - 공통 버튼 UI
 */

import UIKit

/// `CustomButton`은 둥근 모서리, 테두리, 배경색 변경이 가능한 커스텀 UIButton 클래스입니다.
/// `@IBInspectable`을 사용하여 인터페이스 빌더에서 속성을 직접 조정할 수 있습니다.
@IBDesignable
class CustomButton: UIButton {

    // MARK: - 속성 (Properties)

    /// 버튼의 모서리를 둥글게 만들기 위한 속성입니다. (인터페이스 빌더에서 설정 가능)
    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    /// 버튼 테두리의 두께를 설정하는 속성입니다. (인터페이스 빌더에서 설정 가능)
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    /// 버튼 테두리의 색상을 설정하는 속성입니다. (인터페이스 빌더에서 설정 가능)
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    /// 버튼의 기본(normal) 상태 배경색을 설정하는 속성입니다. (인터페이스 빌더에서 설정 가능)
    @IBInspectable var backgroundColorNormal: UIColor = .systemBlue {
        didSet {
            setBackgroundColor(backgroundColorNormal, for: .normal)
        }
    }

    /// 버튼이 눌렸을 때(highlighted) 배경색을 설정하는 속성입니다. (인터페이스 빌더에서 설정 가능)
    @IBInspectable var backgroundColorHighlighted: UIColor = .systemGray {
        didSet {
            setBackgroundColor(backgroundColorHighlighted, for: .highlighted)
        }
    }

    // MARK: - 초기화 (Initialization)

    /// 코드로 버튼을 생성할 때 실행되는 초기화 메서드입니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    /// 스토리보드에서 버튼을 생성할 때 실행되는 초기화 메서드입니다.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // MARK: - 버튼 설정 (Setup Methods)

    /// 버튼의 기본 스타일을 설정하는 메서드입니다.
    private func setupButton() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        setBackgroundColor(backgroundColorNormal, for: .normal)
        setBackgroundColor(backgroundColorHighlighted, for: .highlighted)
    }

    // MARK: - 유틸리티 메서드 (Helper Methods)

    /// 버튼의 특정 상태별 배경색을 설정하는 메서드입니다.
    ///
    /// - Parameters:
    ///   - color: 설정할 배경색
    ///   - state: 적용할 버튼 상태 (예: `.normal`, `.highlighted`)
    private func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        // 1x1 크기의 이미지에 배경색을 적용하여 버튼의 배경색을 변경하는 방식
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // 생성된 색상을 버튼의 배경 이미지로 설정
        setBackgroundImage(colorImage, for: state)
    }
}
