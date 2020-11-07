//
//  ContentView.swift
//  WhatTheFlag
//
//  Created by Denny Mathew on 07/11/20.
//

import SwiftUI
enum AlertItem: Identifiable {
    case score
    case gameOver
    var id: Int {
        switch self {
        case .score:
            return 0
        case .gameOver:
            return 1
        }
    }
}
struct ContentView: View {
    let numberOfTurns = 10
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score: Int = 0
    @State private var turns: Int = 0
    @State private var alertItem: AlertItem?
    private var endGameAlert: Alert {
        var title = ""
        var message = ""
        if score > 0 {
            title = "You are the winner!"
            message = "You have bagged \(score) points! Way to go!"
        } else {
            title = "Sorry to see you loose!"
            message = "You lost by \(score) points!"
        }
        return Alert(title: Text(title), message: Text(message), primaryButton: .default(Text("Restart game")) {
            resetGame()
        }, secondaryButton: .default(Text("Quit")) {
            endGame()
        })
    }
    private var scoreAlert: Alert {
        Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")){
            self.askQuestion()
        })
    }
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black.opacity(0.4), lineWidth: 1.0))
                            .shadow(color: Color.black.opacity(0.6), radius: 6)
                    }
                }
                VStack {
                    Text("Your score")
                        .foregroundColor(.white)
                    Text("\(score)")
                        .fontWeight(.black)
                        .foregroundColor(score < 0 ? .red : .white)
                }
                Spacer()
            }
            .alert(item: $alertItem) { (item) -> Alert in
                switch item {
                case .score:
                    return scoreAlert
                case .gameOver:
                    return endGameAlert
                }
            }
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct answer!"
            scoreMessage = "Congratulations! That adds 10 more points in your bucket!"
            score += 10
        } else {
            scoreTitle = "Uh ohh.. You're wrong!"
            scoreMessage = "That was the flag of \(countries[number]) you selected! You lost 5 points from your bucket!"
            score -= 5
        }
        alertItem = .score
    }
    func askQuestion() {
        guard turns != numberOfTurns else {
            alertItem = .gameOver
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        turns += 1
    }
    func resetGame() {
        scoreTitle = ""
        scoreMessage = ""
        score = 0
        turns = 0
        askQuestion()
    }
    func endGame() {
        // End
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
