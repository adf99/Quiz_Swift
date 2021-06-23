//
//  QuizModel.swift
//  P1 Quiz SwiftUI
//
//  Created by Santiago Pavón Gómez on 28/09/2020.
//

import Foundation


struct QuizItem: Codable {
    let id: Int
    let question: String
    let answer: String
    let author: Author?
    let attachment: Attachment?
    var favourite: Bool
    
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String?
        let profileName: String?
        let photo: Attachment?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}


class QuizModel: ObservableObject {
       
    @Published var quizzes = [QuizItem]() // Vacio y sin private para el bug de los favoritos cambiarlo

    let session = URLSession.shared
    let urlBase = "https://core.dit.upm.es"
    let TOKEN = "414338807c53ea495052"
    
    func load() {
        
        // 1. Creamos URL---> con la concatenacion de strings y funcion URL
        // 2. Con la sesion, .dataTASK y el URL descargamos los datos
        // 3. Con decoder decodificamos los datos y los metemos en quizzes (Main thread)
        
        let s = "\(urlBase)/api/quizzes/random10wa?token=\(TOKEN)"
        
        guard let url = URL(string:s) else {
            print("Error: URL mal formada")
            return
        }
        
        // Aqui no hace falta DispatchQueu global como en contentsofdata porque lo mete en un thread a parte al usar session.shared
        let t = session.dataTask(with: url){ (data,res,error) in
            if error != nil {
                print("Fallo1")
            }
            if (res as! HTTPURLResponse).statusCode != 200{
                print("Fallo2")
                return
            }
            let decoder = JSONDecoder()
                    
                    // let str = String(data: data, encoding: String.Encoding.utf8)
                    // print("Quizzes ==>", str!)
                    
            if let quizzes = try? decoder.decode([QuizItem].self, from: data!){
                // Aun asi hay que meter en el main la zona critica igualmente
                DispatchQueue.main.async {
                    self.quizzes = quizzes // Zona critica
                }
            }
        }
        t.resume()
}
    
    func toggleFavourite(_ quizItem: QuizItem){
        
        // Vemos la posicion del quiz en el array para luego poner y quitar el favorito

        guard let index = quizzes.firstIndex(where: { $0.id == quizItem.id}) else {
            print("Fallo 4")
            return
        }
        
        // Creamos URL---> con la concatenacion de strings y funcion URL
        
        let s = "\(urlBase)/api//users/tokenOwner/favourites/\(quizItem.id)?token=\(TOKEN)"
        guard let url = URL(string:s) else {
            print("Error: URL mal formada")
            return
        }
        
        // Con la sesion, .uploadTASK y el URL actualizamos los datos. Configuracion previa de la peticion(request)
        
        var request = URLRequest(url: url)
        request.httpMethod = quizItem.favourite ? "DELETE" : "PUT" // Es favorito? lo borramos, no lo es? Lo ponemos
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With") // Evitar problemas
        
        let t = session.uploadTask(with: request, from: Data()) { (data,res,error) in
            if error != nil {
                print("Fallo10")
            }
            if (res as! HTTPURLResponse).statusCode != 200{
                print("Fallo20")
                return
            }
            DispatchQueue.main.async {
                self.quizzes[index].favourite.toggle() // Toggle si era fav lo pone a no fav y al reves
            }
        }
        t.resume()

    }

}

