//
//  ContentView.swift
//  FinalProjEJ
//
//  Created by PM Student on 12/6/22.
//

import SwiftUI
import Foundation
import UIKit

struct GameData: Decodable {
    let name: String
    let image: String
    let type: String
}



var ActionGameImages = [
"RDR2",
"MW2022",
"GOW:R",
"ER",
"HFW"
]

struct ContentView: View {
    var ActionGames = [
    "Red Dead Redemption 2",
    "Call of Duty: Modern Warfare II (2022)",
    "God of War: Ragnarok",
    "Elden Ring",
    "Horizon: Forbidden West"
    ]
    var ActionGameAbrev = [
    "RDR2",
    "MW2",
    "GOW:R",
    "ER",
    "HFW"
    ]
    var actionGameImages = ActionGameImages
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x - 32)
        
        if diff < 100 {
            scale = 1 + (100 - diff) / 500
        }
        
        return scale
    }
    @State var hearted = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                Text("Action/Adventure")
                ScrollView(.horizontal) {
                    HStack(spacing: 50) {
                        ForEach(self.actionGameImages, id: \.self) { num in
                            GeometryReader { proxy in
                                NavigationLink( destination: GameView(hearted: $hearted, actionGameImages: $num), label: {
                                    VStack(spacing: 10) {
                                        let scale = getScale(proxy: proxy)
                                        
                                        Image(num)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150)
                                        
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.5)
                                            )
                                        
                                            .clipped()
                                            .cornerRadius(5)
                                            .shadow(radius: 5)
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                            .animation(.easeOut(duration: 0.5))
                                        
                                        HStack {
                                            Button{ hearted.toggle() } label: {
                                                Image(systemName: hearted ? "heart.fill" : "heart")
                                                    .resizable()
                                                    .frame(width: 35, height: 35)
                                                    .padding(.top)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                })
                                //                                Text(scale.description)
                                //                                    .font(.system(size: 30, weight: .bold))
                            }
                            .frame(width: 125, height: 300)
                            
                            
                        }
                    }.padding(32)
                }.navigationTitle("Video Games")
            }
        }
    }
    
}




struct GameView:  View {
    @Binding var hearted: Bool
    var actionGameImages = ActionGameImages
    
    var body: some View {
       
            VStack {
                Image(actionGameImages)
                    .frame(width: 250, height: 500)
                    .offset(y: -150)
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 25)
                        .foregroundColor(.white)
                        .offset(y: -170)
                    HStack {
                        
                        Text("Red Dead Redemption 2")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .shadow(radius: 5)
                            .offset(y: -160)
                        Button{ hearted.toggle() } label: {
                            Image(systemName: hearted ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.top)
                                .foregroundColor(.red)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Text("Year:")
                    
                    Text("")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Genre:")
                    
                    Text("Action/Adventure")
                        .fontWeight(.bold)
                    Spacer()
                }.offset(y: -150)
                HStack {
                    Spacer()
                    Image(systemName: "person.badge.shield.checkmark.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .shadow(color: .green, radius: 1)
                    Text("%")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .frame(width: 80, height: 40)
                        .foregroundColor(.black)
                        .shadow(color: .yellow, radius: 1)
                    Text("")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                } .offset(y: -120)
                HStack {
                    Spacer()
                    Text("Price:")
                        .font(.title2)
                    
                    Text("~")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }.offset(y: -100)
            
        }
    }
    
}
class PokemonViewModel: ObservableObject {
    
    @Published var game = [GameData]()
    
    let apiURL = "https://firebasestorage.googleapis.com/v0/b/pokedexej.appspot.com/o/pokedexej-default-rtdb-export.json?alt=media&token=e85be88e-8c34-4489-8278-bff231a1f6ab"
    
    init() {
        fetchGameData()
    }
    
    
    func fetchGameData() {
        guard let url = URL(string: apiURL) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let cleanData = data?.parseData(removeString: "null,") else { return }
            
            DispatchQueue.main.async {
                do {
                    let game = try
                        JSONDecoder().decode([GameData].self,
                        from: cleanData)
                    self.game = game
                } catch {
                    print("error msg", error)
                }
            }
        }
        
        task.resume()
        
    }
}
extension Data {
    func parseData(removeString string: String)-> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?
            .replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else {
            return nil
        }
        return data
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
