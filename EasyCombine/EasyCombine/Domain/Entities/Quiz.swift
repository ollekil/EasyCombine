//
//  Quiz.swift
//  EasyCombine
//
//  Created by hb9879055 on 2/10/25.
//
/*!<
 # 비즈니스 로직 (순수한 비즈니스 계층, UI/외부 의존 없음)
   - 도메인 엔티티 정의
     - 퀴즈 모델
 */

//import Foundation
//
//struct Quiz: Decodable {
//    let id: Int
//    let question: String
//    let options: [String]
//    let correctAnswer: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id = "quiz_id"
//        case question = "quiz_question"
//        case options = "quiz_options"
//        case correctAnswer = "quiz_correctAnswer"
//    }
//}
import Foundation

struct Quiz: Codable {
    let id: Int
    let question: String
    let options: [String]
    let correctAnswer: Int
}

func testSaveQuiz() {
    let quiz = Quiz(id: 1, question: "What is Swift?", options: ["A", "B", "C"], correctAnswer: 0)
    LocalStorage.shared.save(quiz, forKey: "quizData")
    print("Quiz saved successfully!")
}

// 함수 호출
//testSaveQuiz()
