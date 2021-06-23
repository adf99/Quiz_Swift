//
//  ContentView.swift
//  Practica 1 Quizz
//
//  Created by angel on 08/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var quizModel: QuizModel
    @EnvironmentObject var scoreModel: ScoreModel

    @State var showAll: Bool = true

    var body: some View {
        NavigationView{
        List {
            Toggle(isOn: $showAll) {
                Label("Ver todo", systemImage: "list.bullet")
            }
            ForEach(quizModel.quizzes.indices, id: \.self){ i in // No podemos hacer copias ! Enlace al original con binding!! Bug
                if showAll || !scoreModel.acertado(quizModel.quizzes[i]) { // O enseñamos todos los quizzes---> Toggle activado o los quizzes acertados y con ello las vistas detail y link de ellos
                    NavigationLink(destination: QuizDetail(quiz: $quizModel.quizzes[i])){
                        QuizRow(quiz: quizModel.quizzes[i])
                    }
                }
            }
        }.navigationBarItems(trailing: Button(action: {quizModel.load()},
                                              label: {Image(systemName: "arrow.clockwise")}))
        .navigationTitle("P1 Quiz SwiftUI")
            VStack{
            Text("Practica 1, desliza hacia la derecha para ver los quizzes")
            Image("pantallainicio")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            } .padding()
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
    ContentView()
}
}

