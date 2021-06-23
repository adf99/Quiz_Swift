//
//  ScoreModel.swift
//  Practica 1 Quizz
//
//  Created by angel on 13/10/2020.
//

import Foundation

class ScoreModel: ObservableObject {
    
    // Acertadas de manera persistente con UserDefault
    @Published var acertadas: Set <Int> = []
    
    // Lo pasa a UserDefaults para generar persistencia y a Array para evitar problemas en la config de UserDefault con los Set
    init() {
        if let acertadas = UserDefaults.standard.object(forKey: "acertadas") as? Array<Int>{self.acertadas = Set(acertadas)}
    }
    
    func check(respuesta: String, quiz: QuizItem) {
        let r1 = respuesta.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let r2 = quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if r1 == r2,
           !acertadas.contains(quiz.id){
            acertadas.insert(quiz.id)
            // Persistencia de acertadas
            UserDefaults.standard.set(Array<Int>(acertadas),forKey:"acertadas")
        }
    }
    func acertado (_ quiz:QuizItem) -> Bool {
        acertadas.contains(quiz.id)
    }
    func limpiar() { // Esta funcion es para borrar las acertadas con un popup dentro de donde contestas
        acertadas.removeAll()
        // Persistencia si reseteammos
        UserDefaults.standard
            .set(Array<Int>(acertadas),forKey:"acertadas")
    }
}
