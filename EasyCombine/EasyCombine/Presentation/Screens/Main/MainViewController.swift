//
//  MainViewController.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 메인 화면
       - 메인 화면 뷰 컨트롤러
 */

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!

    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // ViewModel에서 사용자 데이터를 가져옴
        guard let users = viewModel?.users else { return }

        // 버튼 설정
        configureButtons(with: users)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let user = viewModel?.getUser(for: sender.tag) else { return }
        statusLabel.text = "\(user.level)입니다. 이름: \(user.name)"
    }

    private func configureButtons(with users: [User]) {
        for (index, user) in users.enumerated() {
            if let button = self.view.viewWithTag(index) as? UIButton {
                button.setTitle(user.level, for: .normal) // 버튼에 레벨 정보 표시
            }
        }
    }
    
    private func exButton() {
        let customButton = CustomButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        customButton.setTitle("클릭하세요", for: .normal)
        customButton.cornerRadius = 12
        customButton.borderWidth = 2
        customButton.borderColor = .red
        customButton.backgroundColorNormal = .green
        customButton.backgroundColorHighlighted = .yellow
        view.addSubview(customButton)
    }
}
