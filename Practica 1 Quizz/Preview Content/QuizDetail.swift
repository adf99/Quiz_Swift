//
//  QuizDetail.swift
//  Practica 1 Quizz
//
//  Created by angel on 08/10/2020.
//

import SwiftUI

struct QuizDetail: View {
    
    @Binding var quiz :QuizItem // Referencia a donde esta el quiz para actualizarse el favorito!
    
    @State var answer: String = ""
    @State var showAlert = false
    @State var showResp = false
    @State var reset = false
    @State var textorespuesta: String = ""
    
    @EnvironmentObject var imageStore: ImageStore
    @EnvironmentObject var scoreModel: ScoreModel
    @EnvironmentObject var quizModel: QuizModel

    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text(quiz.question)
                    .font(.largeTitle)
                    .padding()
                Button(action: {
                    self.quizModel.toggleFavourite(quiz)
                })
                {
                    Image(quiz.favourite ? "estrella": "estrellanegra") // Pa actualizar foto si es fav o no
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFit()
                }
            }
            Spacer()
            Text("Puntos = \(scoreModel.acertadas.count)")
            Spacer()
            TextField("escriba su respuesta",
                      text: self.$answer,
                      onCommit: {
                        if answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines){
                            showAlert = true
                            textorespuesta = "La respuesta es correcta"
                        } else {
                            showAlert = true
                            textorespuesta = "La respuesta es incorrecta"
                        }
                        scoreModel.check(respuesta: answer, quiz: quiz)
                    }).alert(isPresented: $showAlert) {
                        Alert(title: Text(textorespuesta),
                              message: Text("La respuesta correcta es " + quiz.answer),
                        dismissButton: .default(Text("Volver")))
                        }.padding()
            Divider()
            Image(uiImage: imageStore.image(url: quiz.attachment?.url))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .aspectRatio(contentMode: .fit)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .clipped()
                .animation(.easeInOut)
            Spacer()
            HStack{
                Button(action: {
                    self.showResp = true
                    })
                    { Text("Ver respuesta correcta") }
                        .alert(isPresented: $showResp) {
                            Alert(title: Text(quiz.answer),
                            dismissButton: .default(Text("Volver")))
                        }.padding()
                Button(action: {
                    scoreModel.limpiar()
                    })
                    { Text("Resetear puntuación") }.padding()
            }
        }.navigationBarTitle(Text("Play"), displayMode: .inline)
    }
}


