//
//  ContentView.swift
//  wordle_00857125
//
//  Created by nighthao on 2022/3/30.
//

import SwiftUI
import AVFoundation
struct NumberData: Identifiable{
    let id = UUID()
    var value: String
    var color = Color.gray
}

struct ContentView: View {
    let musicPlayer = AVPlayer()
    @State var scale: Double = 4
    @State var numbers = [NumberData]()
    @State var result_color: String = ""
    @State var keyboard = [[String]]()
    @State var keyboard_color = [[Color]]()
    @State var start = 0
    @State var finishedrow = 0
    @State var nowindex = 0
    @State var answer: String = ""
    @State var showAlert = false
    @State var alertTitle = ""
    @State var win: Int = 0
    @State var guesstime: Int = 6
    @State private var showResultView = false
    @State var lose: Int = 0 //戰敗為2,勝利為1
    //讀取答案字串
    func ReadFile(scale: Int){
        if (scale == 4){
            if let asset = NSDataAsset(name: "four"),
               let content = String(data: asset.data, encoding: .utf8){
                let array = content.split(separator: "\n")
                let num = Int.random(in: 0...(array.count - 1))
                answer = String(array[num])
            }
        }
        else if (scale == 5){
            if let asset = NSDataAsset(name: "five"),
               let content = String(data: asset.data, encoding: .utf8){
                let array = content.split(separator: "\n")
                let num = Int.random(in: 0...(array.count - 1))
                answer = String(array[num])
            }
        }
        else if (scale == 6){
            if let asset = NSDataAsset(name: "six"),
               let content = String(data: asset.data, encoding: .utf8){
                let array = content.split(separator: "\n")
                let num = Int.random(in: 0...(array.count - 1))
                answer = String(array[num])
            }
        }
    }
            
    //初始化格子
    func InitialNumbers(){
        numbers = []
        result_color = ""
        for _ in 1...Int(scale)*guesstime{
            let number = ""
            numbers.append(NumberData(value: number))
        }
    }
    
    //更新格子
    func UpdateNumbers(){
        numbers = []
        result_color = ""
        for _ in 1...Int(scale)*guesstime{
            let number = ""
            numbers.append(NumberData(value: number))
        }
    }
    
    //初始化鍵
    func InitialKeyboard(){
        keyboard = []
        keyboard_color = []
        finishedrow = 0
        nowindex = 0
        lose = 0
        keyboard.append(["Q","W","E","R","T","Y","U","I","O","P"])
        keyboard_color.append([Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray])
        keyboard.append(["A","S","D","F","G","H","J","K","L"])
        
        keyboard_color.append([Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray])
        keyboard.append(["ENTER","Z","X","C","V","B","N","M","<"])
        
        keyboard_color.append([Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray,Color.gray])
    }
            
    func UpdateGuess(guess: Int){
        guesstime = guess
    }
    //填上文字
    func WriteChar(w:String)->(){
        AudioServicesPlaySystemSound(1026)
        if nowindex % Int(scale) != (Int(scale) - 1){
            numbers[nowindex].value = w
            nowindex += 1
        }
        else{
            numbers[nowindex].value = w
        }
    }
            
    //判斷Enter結果
    func EnterJudge(){
        if nowindex % Int(scale) == (Int(scale) - 1) && numbers[nowindex].value != ""{
            finishedrow += 1
            nowindex += 1
            var correct: Int = 0
            for i in nowindex-Int(scale)..<nowindex{
                var co: Int = 0
                for index in answer.indices{
                    if numbers[i].value == String(answer[index]){
                        numbers[i].color = .yellow
                        if i % Int(scale) == co{
                            numbers[i].color = .green
                            correct += 1
                            break
                        }
                    }
                    co += 1
                    if co == Int(scale) && numbers[i].color == .gray{
                        numbers[i].color = .brown
                    }
                }
                for j in 0..<keyboard_color.count{
                    for k in 0..<keyboard_color[j].count{
                        if keyboard[j][k] == numbers[i].value{
                            if keyboard_color[j][k] != .green && keyboard_color[j][k] != .brown{
                                keyboard_color[j][k] = numbers[i].color
                            }
                        }
                    }
                }
            }
            if correct == Int(scale){
                //顯示勝利
                //showAlert = true
                //alertTitle = "correct"
                for i in 0..<Int(scale)*guesstime{
                    if numbers[i].color == Color.yellow{
                        result_color += "2"
                    }
                    else if numbers[i].color == Color.green{
                        result_color += "1"
                    }
                    else {
                        result_color += "0"
                    }
                }
                lose = 1
                win += 1
            }
            else if finishedrow == guesstime{
                //showAlert = true
                for i in 0..<Int(scale)*guesstime{
                    if numbers[i].color == Color.yellow{
                        result_color += "2"
                    }
                    else if numbers[i].color == Color.green{
                        result_color += "1"
                    }
                    else {
                        result_color += "0"
                    }
                }
                lose = 2
                //alertTitle = "answer is \(answer)"
            }
            else{
                var exp:Int = 0
                for i in nowindex-Int(scale)..<nowindex{
                    if numbers[i].color == .brown{
                        exp += 1
                    }
                }
                if exp == Int(scale){
                    showAlert = true
                    alertTitle = "not in word list"
                }
            }
        }
        else{
            showAlert = true
            alertTitle = "Not enough letters"
        }
    }
            
    //刪除
    func BackSpace(){
        if nowindex % Int(scale) != 0{
            numbers[nowindex].value = ""
            nowindex -= 1
        }
        else{
            numbers[nowindex].value = ""
        }
    }
    
    var body: some View {
        ZStack{
        Image("Image")
                .resizable()
        VStack(spacing:10){
            Button("Guess"){
                InitialNumbers()
                InitialKeyboard()
                ReadFile(scale: Int(scale))
                start = 1
            }.font(.largeTitle)
                .foregroundColor(Color.purple)
                .onAppear{
                let fileUrl = Bundle.main.url(forResource: "music", withExtension: "mp4")!
                                let playerItem = AVPlayerItem(url: fileUrl)
                                self.musicPlayer.replaceCurrentItem(with: playerItem)
                                self.musicPlayer.play()
                }
            Text("win: \(win)").padding()
            HStack{
                Text("Letter \(Int(scale))")
                Slider(value: $scale, in: 4...6, step: 1)
                    .frame(width: 300.0)
                    .onChange(of: scale, perform: {
                        value in UpdateNumbers()
                    } )
            }
            HStack{
                Button("Addtimes"){
                    if guesstime < 6{
                        guesstime += 1
                        InitialNumbers()
                        InitialKeyboard()
                        ReadFile(scale: Int(scale))
                        start = 1
                    }
                }.foregroundColor(Color.purple)
                Button("Subtimes"){
                    if guesstime > 3{
                        guesstime -= 1
                        InitialNumbers()
                        InitialKeyboard()
                        ReadFile(scale: Int(scale))
                        start = 1
                    }
                }.foregroundColor(Color.purple)
                Button("Plz"){
                    var co = 0
                    for index in answer.indices{
                        if co == nowindex{
                            WriteChar(w: String(answer[index]))
                            break
                        }
                        co += 1
                    }
                }.foregroundColor(Color.purple)
            }
            ZStack{
                let columns = Array(repeating: GridItem(), count: Int(scale))
                LazyVGrid(columns: columns){
                    ForEach(numbers){number in
                        ZStack{
                            Rectangle().foregroundColor(number.color)
                                .frame(height: 50)
                                .padding(5)
                            Text("\(number.value)")
                        }
                    }
                }
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button("OK"){
                    }
                })
                if lose == 1{
                    Button("CORRECT"){
                        showResultView = true
                    }
                    .font(.largeTitle)
                    .fullScreenCover(isPresented: $showResultView, content:{ResultView(showResultView: $showResultView,result_color:$result_color,lose:$lose,scale:$scale)})
                }
                else if lose == 2{
                    Button("LOSE"){
                        showResultView = true
                    }
                    .font(.largeTitle)
                    .fullScreenCover(isPresented: $showResultView, content:{ResultView(showResultView: $showResultView,result_color:$result_color,lose:$lose,scale:$scale)})
                }
            }
            Text("\(Int(numbers.count))")
                .padding()
            if start == 1{
                VStack{
                    ForEach(0..<3){i in
                        HStack{
                            ForEach(0..<keyboard[i].count){ j in
                                if (i == 2 && j == 0 || i == 2 && j == 8){
                                    ZStack{
                                        Rectangle().frame(width: 52, height: 30)
                                            .foregroundColor(.gray)
                                            .onTapGesture{
                                                if(i==2 && j == 0){
                                                    EnterJudge()
                                                }
                                                else{
                                                    BackSpace()
                                                }
                                            }
                                        Text(keyboard[i][j])
                                    }
                                }
                                else{
                                    ZStack{
                                        Rectangle().frame(width: 30, height: 30)
                                            .foregroundColor(keyboard_color[i][j])
                                            .onTapGesture{ WriteChar(w:keyboard[i][j])}
                                        Text(keyboard[i][j])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
