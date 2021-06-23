//
//  Practica_1_QuizzApp.swift
//  Practica 1 Quizz
//
//  Created by angel on 08/10/2020.
//

import SwiftUI

@main
struct Practica_1_QuizzApp: App {
    // Iniciar los quizzes
    let quizModel: QuizModel = {
        let qm = QuizModel()
        qm.load()
        return qm
    }()
    let imageStore = ImageStore()
    let scoreModel = ScoreModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageStore)
                .environmentObject(scoreModel)
                .environmentObject(quizModel)
        }
    }
}
