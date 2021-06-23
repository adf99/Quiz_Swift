//
//  QuizRow.swift
//  Practica 1 Quizz
//
//  Created by angel on 08/10/2020.
//

import SwiftUI

struct QuizRow: View {
    var quiz : QuizItem
    @EnvironmentObject var imageStore: ImageStore
    var body: some View {
        HStack(alignment: .center) {
            Image(uiImage: imageStore.image(url: quiz.attachment?.url))
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            Text(quiz.question)
            Spacer()
            VStack{
                HStack{
                Text(String(quiz.author?.username ?? "")) 
                Image(uiImage: imageStore.image(url: quiz.author?.photo?.url))
                    .resizable()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                }
                Spacer()
                }
        
            }
        }
    }

