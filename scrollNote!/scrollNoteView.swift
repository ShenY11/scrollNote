//
//  ContentView.swift
//  scrollNote!
//
//  Created by 沈钰婷 on 2021/12/27.
//

import SwiftUI

struct scrollNoteView: View {
    @ObservedObject var model: noteCardModel
    var body: some View {
        VStack {
            UpRoll(model: model)
            DownRoll(model: model)
            Circle()
                .fill(Color.indigo)
                .onTapGesture {
                    //examineCorrectness()
                }
                .frame(width: 55, height: 55)
        }
        .padding()
    }
}


struct CardView: View {
    var model: noteCardModel
    var card: noteCardModel.Card
    var color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
            Text(card.content)
                .opacity(card.hasChooseAnimation ? 0 : 1)
                    .animation(
                        Animation.linear
                            .repeatCount(card.hasChooseAnimation ? Int.max : 0, autoreverses: true)
                        .speed(0.4))
                    .font(Font.largeTitle)
        }
            .onTapGesture {
                model.choose(card: card)
                
                //add texts
                //choose
            }
            .padding()
            .frame(width: 180, height: 300)
    }
}

struct UpRoll: View {
    var model: noteCardModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
               ForEach (model.upRollCards) { card in
                    GeometryReader { geometry in
                        let acolor = colorList[card.id/2]
                        CardView(model: model, card: card, color: acolor)
                            .padding()
                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX)/5), axis: (x: 0,y: 10,z: 0))
                            /*.onTapGesture {
                                model.choose(card: card)
                                
                                //add texts
                                //choose
                            }*/
                    }
                        .frame(width: 180, height: 300)
                }
                    .padding()
            }
        }
    }
}

struct DownRoll: View {
    var model: noteCardModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach (model.downRollCards) { card in
                    GeometryReader { geometry in
                        let acolor = colorList2[card.id/2]
                        CardView(model: model, card: card, color: acolor)
                            .onTapGesture(perform: {
                                model.choose(card: card)})
                            .padding()
                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX)/5), axis: (x: 0,y: 10,z: 0))
                    }
                        .frame(width: 180, height: 300)
                }
                    .padding()
            }
        }
    }
}

let colorList: Array<Color> = [color_orange, color_yellow, color_blue, color_purple]
let colorList2: Array<Color> = [color_pink, color_purple, color_green, color_blue]
let color_orange = Color(red: 243/255, green: 172/255, blue: 72/255, opacity: 0.3)
let color_pink = Color(red: 220/255, green: 130/255, blue: 126/255, opacity: 0.3)
let color_blue = Color(red: 46/255, green: 125/255, blue: 246/255, opacity: 0.3)
let color_purple = Color(red: 176/255, green: 102/255, blue: 175/255, opacity: 0.3)
let color_green = Color(red: 77/255, green: 157/255, blue: 101/255, opacity: 0.3)
let color_yellow = Color(red: 248/255, green: 204/255, blue: 95/255, opacity: 0.3)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        scrollNoteView(model: noteCardModel())
    }
}
