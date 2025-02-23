//
//  MazeViewController.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 미로 화면
       - 미로 화면 뷰 컨트롤러
 */
/*!<
 
 */

import UIKit

/// MazeViewController가 종료될 때 알림을 보내는 델리게이트 프로토콜
protocol MazeViewControllerDelegate: AnyObject {
    func mazeViewDidDisappear()
}

class MazeViewController: UIViewController {
    var viewModel: MazeViewModel!  // DIContainer에서 주입되는 ViewModel
    var coordinator: AppCoordinator?  // DIContainer에서 주입되는 Coordinator
    weak var delegate: MazeViewControllerDelegate?  // DIContainer에서 주입되는 Delegate

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 사용자가 뒤로 가기 버튼을 눌렀을 때만 델리게이트 메서드 호출
        if self.isMovingFromParent {
            delegate?.mazeViewDidDisappear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
        
        // ViewModel이 정상적으로 주입되었는지 확인
        print("MazeViewModel이 주입됨: \(viewModel != nil)")
    }
}
