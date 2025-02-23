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

///  `MazeViewController`가 종료될 때 알림을 보내는 델리게이트 프로토콜
protocol MazeViewControllerDelegate: AnyObject {
    func mazeViewDidDisappear()
}

class MazeViewController: UIViewController {
    weak var delegate: MazeViewControllerDelegate?  //  델리게이트 추가

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {  //  사용자가 뒤로 가기 버튼을 눌렀을 때만 호출
            delegate?.mazeViewDidDisappear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
    }
}
