import SceneKit
import SwiftUI

struct ContentView: View {
    
    @State private var selectedAnimationIndex = 0 // State variable to track the index of the selected animation
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    
    let animationNames = ["/cat/Animations/Idle", "/cat/Animations/StandUp", "/cat/Animations/SitDown","/cat/Animations/SittingIdle","/cat/Animations/WalkClean"] // Array of animation names
    
    var body: some View {
        VStack {
            SceneView(scene: makeScene(), options: [.allowsCameraControl, .autoenablesDefaultLighting])
                .frame(width: UIScreen.main.bounds.width * 3 , height: UIScreen.main.bounds.height )
            
//            Text("Command: ")
//            Text(String(speechRecognizer.selectedAnimationIndex))
//            
//            Text("Transcript: ")
//            Text(speechRecognizer.transcript)
//                .padding()
//            
//            Button(action: {
//                if !isRecording {
//                    speechRecognizer.transcribe()
//                    
//                } else {
//                    speechRecognizer.cleanTranscribing()
//                }
//                
//                isRecording.toggle()
//            }) {
//                Text(isRecording ? "Stop" : "Record")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(isRecording ? Color.red : Color.blue)
//                    .cornerRadius(10)
//            }
            
//            HStack {
//                ForEach(0..<4) { index in
//                    Button(action: {
//                        selectedAnimationIndex = index // Set the selected animation index
//                    }) {
//                        Text(animationNames[index])
//                            .padding()
//                            .background(selectedAnimationIndex == index ? Color.blue : Color.gray) // Highlight the selected animation
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .font(.headline)
//                    }
//                }
//            }
        }.onAppear(perform: {
            speechRecognizer.transcribe()
        })
    }
    
    func makeScene() -> SCNScene {
        guard let scene = SCNScene(named: "cat.usdz") else {
            fatalError("Failed to load the scene file.")
        }
        
        let scaleFactor: CGFloat = 0.5 // Adjust the scale factor as desired
        let positionOffset = SCNVector3(0, -3, -2)
        let rotationAngle = Float.pi / 1.9 // Adjust the rotation angle as desired
        
        let rootNode = scene.rootNode
        
        let animationNode = rootNode.childNode(withName: "Skeleton", recursively: true)
              
        if let animationPlayer = animationNode!.animationPlayer(forKey: animationNames[speechRecognizer.selectedAnimationIndex]) {
                // Set up animation properties
            if speechRecognizer.selectedAnimationIndex == 0 || speechRecognizer.selectedAnimationIndex == 3 || speechRecognizer.selectedAnimationIndex == 4{
                animationPlayer.animation.repeatCount = .infinity
            } else {
                animationPlayer.animation.repeatCount = 1
            }
            
                animationPlayer.animation.isRemovedOnCompletion = false
                
                // Play the animation
                animationNode!.addAnimation(animationPlayer.animation, forKey: "/cat/Animations/SittingIdle")
                
                // Start the animation player
                animationPlayer.play()
            }
        print(speechRecognizer.selectedAnimationIndex)
        print(speechRecognizer.transcript)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5,
                                      execute: {
            if speechRecognizer.selectedAnimationIndex == 1 {
                speechRecognizer.selectedAnimationIndex = 0
            }
            if speechRecognizer.selectedAnimationIndex == 2 {
                speechRecognizer.selectedAnimationIndex = 3
            }})
//        if speechRecognizer.selectedAnimationIndex == 1 {
//            speechRecognizer.selectedAnimationIndex = 0
//        }
//        if speechRecognizer.selectedAnimationIndex == 2 {
//            speechRecognizer.selectedAnimationIndex = 3
//        }
        
        // Play the selected animation based on the selectedAnimationIndex
//        if selectedAnimationIndex < animationNames.count {
//            let animationName = animationNames[selectedAnimationIndex]
////            print(animationName)
//            if let animationPlayer = animationNode?.animationPlayer(forKey: animationName) {
//                animationPlayer.play()
//                print(animationPlayer)
//
//            }
//            
//        }
        
        rootNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        rootNode.rotation = SCNVector4(0, 1, 0, rotationAngle) // Rotate around the y-axis
        rootNode.position = positionOffset
        
        if let backgroundImage = UIImage(named: "room.png") {
            scene.background.contents = backgroundImage
            scene.background.contentsTransform = SCNMatrix4MakeScale(-1, 1, 0) //
        }
        
        return scene
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

