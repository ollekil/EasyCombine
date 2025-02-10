//
//  QuizViewController.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # UI 및 화면 관련 계층 (UIKit 기반)
   - 화면별 ViewController 와 ViewModel
     - 퀴즈 화면
       - 퀴즈 화면 뷰 컨트롤러
 */

import UIKit

class QuizViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quiz = Quiz(id: 1, question: "What is Swift?", options: ["A", "B", "C"], correctAnswer: 0)
        LocalStorage.shared.save(quiz, forKey: "quizData")
    }
}
