import UIKit
import AVFoundation
import PlaygroundSupport

public let fontURL = Bundle.main.url(forResource: "Fonarto", withExtension: "otf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

public class SplashViewController: UIViewController, HolderViewDelegate {
    
    public var holderView = HolderView(frame: CGRect.init(x: 0, y: 0, width: 37, height: 668))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    public func animateLabel() {
        let menu = MenuViewController()
        self.present(menu, animated: true, completion: nil)
    }
}

class MenuViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 375, height: 668)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let title = UILabel(frame: CGRect(x: 0, y: 150, width: 375, height: 200))
        title.textAlignment = .center
        title.text = "Ava"
        title.font = UIFont(name: "Fonarto", size: 150)
        title.font = title.font.withSize(150)
        title.textColor = .white
        self.view.addSubview(title)
        
        let descrip = UILabel(frame: CGRect(x: 0, y: 300, width: 375, height: 60))
        descrip.numberOfLines = 0
        descrip.lineBreakMode = .byWordWrapping
        descrip.textAlignment = .center
        descrip.text = "Your Daily Briefing Chatbot"
        descrip.font = UIFont(name: "Fonarto", size: 25)
        descrip.font = descrip.font.withSize(25)
        descrip.textColor = .white
        self.view.addSubview(descrip)
        
        let swipe = UILabel(frame: CGRect(x: 0, y: 500, width: 375,
                                          height: 60))
        swipe.textAlignment = .center
        swipe.text = "Swipe up to begin"
        swipe.font = UIFont(name: "Fonarto", size: 25)
        swipe.font = descrip.font.withSize(25)
        swipe.textColor = .white
        self.view.addSubview(swipe)
        
        let about = UIButton(frame: CGRect(x: 0, y: 600, width: 375, height: 60))
        about.showsTouchWhenHighlighted = true
        about.setTitle("About the Developer", for: .normal)
        about.addTarget(self, action: #selector(self.aboutTheDev(sender:)), for: .touchUpInside)
        self.view.addSubview(about)
    }
    
    func aboutTheDev(sender: UIButton!) {
        present(DevViewController(), animated: true, completion: nil)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                let chat = AvaViewController()
                self.present(chat, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}

class AvaViewController: UIViewController, UITextFieldDelegate {
    var gameMusic : AVAudioPlayer!
    var score = 0
    var highscore = 0
    let avaSays = UILabel()
    var currentVoice = String()
    var thinkingImage = UIImageView(frame: CGRect(x: 140, y: 550, width: 80, height: 20))
    var name = String()
    var loading1: UIImage!
    var loading2: UIImage!
    var loading3: UIImage!
    var images: [UIImage]!
    var animatedImage: UIImage!
    
    
    var textArray = ["Hello!", "My name is Ava.", "I am a chatbot 🤖 designed to liven up your morning.", "So you look 👀 like 😃 instead of 😴", "Let's begin!", "What's your name?", "Nice to meet you", "Should I tell you about some of the things I can do?", "Are you sure?", "You really are missing out! Are you sure?", "Sorry 😐, I wasn't able to comprehend what you said", "Some of the things you can ask me for are...", "...Jokes, Facts, Insprational Quotes, and the Emoji Game", "Since this a demo, I am limited to these 4 categories, but I am sure it can brighten up your morning.", "To end the demo at any time, type 'Bye Ava'.", "The demo will automatically reset as soon as you leave this page.", "Enjoy yourself! 😃😊😉", "", "Why, thank you!"]
    
    var facts = ["In 1985, Silicon Valley was nicknamed as the Valley of Death 💀", "Google’s name was originally Backrub", "Intel’s name was originally Moore Noyce", "Apple’s 🍎 first logo featured Sir Issac Newton", "16 🍎 WWDCs have taken place in San Jose and 14 in San Francisco"]
    
    var jokes = ["Sorry, I don’t have any jokes Ava-ilable. 🤣🤣🤣!", "The 📦 said 'Requires Android 7.0 or better'. So I installed iOS 10.3.", "Mac users swear by their 💻, PC users swear at their PC.", "If at first you don’t succeed, call it version 1.0.", "The more I C, the less I see.", "I would ❤️ to change the 🌎, but they won’t give me the source code."]
    
    var quotes = ["Believe you can and you're halfway there.", "If opportunity doesn't knock, build a door 🚪.", "Nothing is impossible, the word itself says 'I'm possible'!", "What we think 🤔, we become.", "A champion is someone who gets up when they can't.", "It is never too late to be what you might have been.", "In a gentle way, you can shake the world 🌎.", "It is during our darkest moments that we must focus to see the light.", "There is nothing stronger in the world 🌎 than gentleness.", "Turn your face to the sun ☀️ and the shadows fall behind you."]
    
    var emojisForGame = ["🕷 🚶", "👦🏻 👓 ⚡️", "⭐️ 🔫 💣", "🍗 🍖 🎮", "👦🏿 👑 ⬛️ 🐱", "🐜 😄 🔎", "🌌 ⚡️ 🔨 👑", "👱🏻 🛡 🇺🇸", "🤵🏻 😎 💵 🔬 🤖", "🔎 🐠", "☠️ ⛵️ 🏝", "🐝 🐛 🐌 🐞 🐜", "🦁 🐗 🐿 🌅", "👹 🕯 🕑 🍽", "🤖 ⛩ 6️⃣", "⬆️", "🏁 🚗 ⛽️", "👞 🌱 🌌", "🐭 🍅 ✉️", "💪 💥 👓", "🚀 🌵 🍕", "🚪 😱 💡", "🌊 🐾 👣", "😃 😡 😥 😨 🤢", "🎯 🐻 🐎 👑", "🌊 🚣 💪 🐷 🐔", "👭 🙍🏼 ❄️ ⛄️ 👭", "🙍🏼 🐭 💃 👠 👑", "🌺 💇🏻 🐉 🗡 🎉", "🌈 🌀 🌳 👱🏻 🚣", "🎶 🍎 😴 💏💑", "👶🏼 🔮 😴 💋 👸🏼", "👸🏾 💋 🐸 🐸", "🌊 🐚 🎼", "👳🏽‍♀️ 🌙 🔮 🌎 🌠"]
    
    override func viewDidLoad() {loading1 = UIImage(named: "thinking1.png")
        loading2 = UIImage(named: "thinking2.png")
        loading3 = UIImage(named: "thinking3.png")
        images = [loading1, loading2, loading3]
        animatedImage = UIImage.animatedImage(with: images, duration: 1.0)
        view.backgroundColor = UIColor.white
        self.view.frame = CGRect(x: 0, y: 0, width: 375, height: 668)
        let chattingTextField = CustomTextField(frame: CGRect(x: 0, y: 608, width: 375, height: 60))
        chattingTextField.placeholderColor = UIColor(red: 193/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
        chattingTextField.activeBorderColor = UIColor(red: 0, green: 170/255, blue: 206/225, alpha: 1)
        chattingTextField.inactiveBorderColor = UIColor(red: 0, green: 170/255, blue: 206/225, alpha: 1)
        chattingTextField.textColor = UIColor(red: 193/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
        chattingTextField.placeholder = "Chat with Ava..."
        chattingTextField.font = UIFont(name: "Fonarto", size: 16)
        chattingTextField.placeholderFontScale = 1.1
        chattingTextField.autocorrectionType = .no
        chattingTextField.allowsEditingTextAttributes = true
        chattingTextField.keyboardType = .default
        chattingTextField.animateViewsForTextEntry()
        chattingTextField.clearsOnBeginEditing = true
        chattingTextField.animateViewsForTextDisplay()
        chattingTextField.delegate = self
        chattingTextField.keyboardAppearance = .dark
        chattingTextField.returnKeyType = .send
        self.view.addSubview(chattingTextField)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        beginDemo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text?.range(of: "Hello")) != nil || (textField.text?.range(of: "Hey")) != nil ||
            (textField.text?.range(of: "Hi")) != nil {
            avaSays.fadeTransition(0.5)
            avaSays.text = "Hello again, \(name)!"
        } else if avaSays.text == textArray[5] {
            avaSays.fadeTransition(0.5)
            avaSays.text = "\(textArray[6]), \(textField.text!)!"
            name = textField.text!
            let delay = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[7]
                self.currentVoice = self.avaSays.text!
            }
        } else if textField.text?.lowercased().range(of: "what are you") != nil || textField.text?.lowercased().range(of: "who are you") != nil {
            avaSays.fadeTransition(0.5)
            avaSays.text = "My name is Ava- a chatbot developed by Sai Kambampati."
            currentVoice = avaSays.text!
        } else if (textField.text?.range(of: "You are")) != nil {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[18]
            currentVoice = avaSays.text!
        } else if (textField.text?.lowercased().range(of: "do you look like")) != nil {
            avaSays.fadeTransition(0.5)
            avaSays.text = "👩‍💻👸👱‍♀️🤷‍♀️"
        } else if (textField.text?.lowercased().range(of: "where are you")) != nil {
            avaSays.fadeTransition(0.5)
            avaSays.text = "Right here!"
        } else if (textField.text?.lowercased().range(of: "bye ava") != nil) {
            avaSays.fadeTransition(0.5)
            name = ""
            present(MenuViewController(), animated: true, completion: nil)
        } else if ((textField.text?.lowercased().range(of: "yes")) != nil || (textField.text?.lowercased().range(of: "yeah")) != nil || (textField.text?.lowercased().range(of: "sure")) != nil || (textField.text?.lowercased().range(of: "yup")) != nil)  && avaSays.text == textArray[7] {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[11]
            let delay = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[12]
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 4) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[13]
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 7) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[14]
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 10) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[15]
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 14) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[16]
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 18) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[17]
                self.currentVoice = self.avaSays.text!
            }
            
        } else if ((textField.text?.lowercased().range(of: "no")) != nil || (textField.text?.lowercased().range(of: "nah")) != nil) && avaSays.text == textArray[7] {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[8]
            self.currentVoice = self.avaSays.text!
        } else if ((textField.text?.lowercased().range(of: "yes")) != nil || (textField.text?.lowercased().range(of: "yeah")) != nil || (textField.text?.lowercased().range(of: "sure")) != nil || (textField.text?.lowercased().range(of: "yup")) != nil) && avaSays.text == textArray[8] {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[9]
            self.currentVoice = self.avaSays.text!
        } else if ((textField.text?.lowercased().range(of: "no")) != nil || (textField.text?.lowercased().range(of: "nah")) != nil) && avaSays.text == textArray[8] {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[7]
            self.currentVoice = self.avaSays.text!
        } else if ((textField.text?.lowercased().range(of: "yes")) != nil || (textField.text?.lowercased().range(of: "yeah")) != nil || (textField.text?.lowercased().range(of: "sure")) != nil || (textField.text?.lowercased().range(of: "yup")) != nil) && avaSays.text == textArray[9] {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[8]
            self.currentVoice = self.avaSays.text!
        } else if ((textField.text?.lowercased().range(of: "no")) != nil || (textField.text?.lowercased().range(of: "nah")) != nil) && avaSays.text == textArray[9] {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[7]
            self.currentVoice = self.avaSays.text!
        } else if textField.text?.lowercased().range(of: "fact") != nil || textField.text?.lowercased().range(of: "new") != nil {
            let displayFact = facts.randomElement()
            avaSays.fadeTransition(0.5)
            avaSays.text = displayFact
        } else if textField.text?.lowercased().range(of: "joke") != nil || textField.text?.lowercased().range(of: "funny") != nil || textField.text?.lowercased().range(of: "laugh") != nil {
            let displayJoke = jokes.randomElement()
            avaSays.fadeTransition(0.5)
            avaSays.text = displayJoke
        } else if (textField.text?.lowercased().range(of: "quote")) != nil || (textField.text?.lowercased().range(of: "inspire")) != nil {
            let displayQuote = quotes.randomElement()
            avaSays.fadeTransition(0.5)
            avaSays.text = displayQuote
        } else if ((textField.text?.lowercased().range(of: "game")) != nil || (textField.text?.lowercased().range(of: "play")) != nil) && avaSays.text != emojisForGame[3] {
            avaSays.fadeTransition(0.5)
            emojiGame()
        } else if avaSays.text == emojisForGame[0] {
            if textField.text?.lowercased().range(of: "spider") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                    self.score = 0
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Spiderman!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[1] {
            if textField.text?.lowercased().range(of: "harry potter") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                    self.score = 0
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Harry Potter!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[2] {
            if textField.text?.lowercased().range(of: "star wars") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                    self.score = 0
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Star Wars!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[3] {
            if textField.text?.lowercased().range(of: "hunger games") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Hunger Games!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[4] {
            if textField.text?.lowercased().range(of: "black panther") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Black Panther!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[5] {
            if textField.text?.lowercased().range(of: "ant man") != nil || textField.text?.lowercased().range(of: "ant-man") != nil || textField.text?.lowercased().range(of: "antman") != nil{
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Ant-Man!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[6] {
            if textField.text?.lowercased().range(of: "thor") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Thor!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[7] {
            if textField.text?.lowercased().range(of: "captain america") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Captain America!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[8] {
            if textField.text?.lowercased().range(of: "iron man") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Iron Man!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[9] {
            if textField.text?.lowercased().range(of: "finding") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Finding Nemo!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[10] {
            if textField.text?.lowercased().range(of: "pirates of the caribbean") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Pirates of the Caribbean!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[11] {
            if textField.text?.lowercased().range(of: "bug's life") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was A Bug's Life!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[12] {
            if textField.text?.lowercased().range(of: "lion king") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was The Lion King!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[13] {
            if textField.text?.lowercased().range(of: "beauty and the beast") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Beauty and the Beast!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[14] {
            if textField.text?.lowercased().range(of: "big hero") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Big Hero 6!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[15] {
            if textField.text?.lowercased().range(of: "up") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Up!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[16] {
            if textField.text?.lowercased().range(of: "cars") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Cars!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[17] {
            if textField.text?.lowercased().range(of: "wall-e") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was WALL-E!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[18] {
            if textField.text?.lowercased().range(of: "ratatouille") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Ratatouille!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[19] {
            if textField.text?.lowercased().range(of: "incredibles") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was The Incredibles!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[20] {
            if textField.text?.lowercased().range(of: "toy story") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Toy Story!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[21] {
            if textField.text?.lowercased().range(of: "monsters") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Monsters, Inc!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[22] {
            if textField.text?.lowercased().range(of: "good dinosaur") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was The Good Dinosaur!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[23] {
            if textField.text?.lowercased().range(of: "inside out") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Inside Out!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[24] {
            if textField.text?.lowercased().range(of: "brave") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Brave!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[25] {
            if textField.text?.lowercased().range(of: "moana") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Moana!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[26] {
            if textField.text?.lowercased().range(of: "frozen") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Frozen!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[27] {
            if textField.text?.lowercased().range(of: "cinderella") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Cinderella!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[28] {
            if textField.text?.lowercased().range(of: "mulan") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Mulan!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[29] {
            if textField.text?.lowercased().range(of: "pocahontas") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Pocahontas!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[30] {
            if textField.text?.lowercased().range(of: "snow white") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Snow White!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[31] {
            if textField.text?.lowercased().range(of: "sleeping beauty") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Sleeping Beauty!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[32] {
            if textField.text?.lowercased().range(of: "princess and the frog") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was The Princess and the Frog!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[33] {
            if textField.text?.lowercased().range(of: "little mermaid") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was The Little Mermaid!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else if avaSays.text == emojisForGame[34] {
            if textField.text?.lowercased().range(of: "aladdin") != nil {
                score += 1
                avaSays.fadeTransition(0.5)
                avaSays.text = "That's right!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            } else if (textField.text?.lowercased().range(of: "quit")) != nil {
                if gameMusic != nil {
                    gameMusic.stop()
                    gameMusic = nil
                }
                if score > highscore {
                    highscore = score
                }
                avaSays.fadeTransition(0.5)
                avaSays.text = "Well done! Your total score is \(score). Your highscore is \(highscore)"
                currentVoice = avaSays.text!
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = ""
                    self.score = 0
                }
            } else {
                avaSays.fadeTransition(0.5)
                avaSays.text = "Sorry! It was Aladdin!"
                let delay = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    let question = self.emojisForGame.randomElement()
                    self.avaSays.fadeTransition(0.5)
                    self.avaSays.text = question
                    self.currentVoice = self.avaSays.text!
                }
            }
        } else {
            avaSays.fadeTransition(0.5)
            avaSays.text = textArray[10]
            let delay = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.currentVoice
            }
        }
        return true
    }
    
    func emojiGame() {
        if highscore == 0 {
            avaSays.fadeTransition(0.5)
            avaSays.text = ""
            let delay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = "The rules to the Emoji Game are simple."
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 3) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = "I will put up the name of a famous Disney movie in the form of emojis."
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 6) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = "All you have to do is type the name of the movie!"
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 9) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = "For every right answer, you will score 1 point."
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 12) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = "To end the game at any time, just type 'Quit'"
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 15) {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = "Are you ready? Let's begin!"
                self.currentVoice = self.avaSays.text!
            }
            DispatchQueue.main.asyncAfter(deadline: delay + 17) {
                let path = Bundle.main.path(forResource: "Jump Music", ofType: "m4a")!
                let url = URL(fileURLWithPath: path)
                
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    self.gameMusic = sound
                    sound.play()
                } catch {
                    
                }
                let question = self.emojisForGame.randomElement()
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = question
                self.currentVoice = self.avaSays.text!
            }
        } else {
            let question = self.emojisForGame.randomElement()
            self.avaSays.fadeTransition(0.5)
            self.avaSays.text = question
            self.currentVoice = self.avaSays.text!
        }
    }
    
    func beginDemo() {
        avaSays.numberOfLines = 0
        avaSays.lineBreakMode = .byWordWrapping
        avaSays.frame = CGRect(x: 0, y: 0, width: 374, height: 628)
        avaSays.textAlignment = .center
        avaSays.text = ""
        avaSays.font = UIFont(name: "GillSans-Light", size: 60)
        avaSays.textColor = UIColor(red: 193/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
        view.addSubview(avaSays)
        view.addSubview(thinkingImage)
        thinkingImage.image = animatedImage
        let delay = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: delay) {
            if self.avaSays.text == "" {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[0]
                self.currentVoice = self.avaSays.text!
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 2) {
            if self.avaSays.text == self.textArray[0] {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[1]
                self.currentVoice = self.avaSays.text!
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 4) {
            if self.avaSays.text == self.textArray[1] {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[2]
                self.currentVoice = self.avaSays.text!
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 7) {
            if self.avaSays.text == self.textArray[2] {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[3]
                self.currentVoice = self.avaSays.text!
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 10) {
            if self.avaSays.text == self.textArray[3] {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[4]
                self.currentVoice = self.avaSays.text!
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay + 12) {
            if self.avaSays.text == self.textArray[4] {
                self.avaSays.fadeTransition(0.5)
                self.avaSays.text = self.textArray[5]
                self.currentVoice = self.avaSays.text!
            }
        }
        
    }
    
  
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                let menu = MenuViewController()
                self.present(menu, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}

class DevViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 375, height: 668)
        let background = UIImage(named: "me.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 375, height: 668))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 375, height: 75))
        title.textAlignment = .center
        title.text = "Sai Kambampati"
        title.font = UIFont(name: "Fonarto", size: 35)
        title.font = title.font.withSize(35)
        title.textColor = .white
        self.view.addSubview(title)
        
        let textView = UITextView(frame: CGRect(x: 0, y: 200, width: 375, height: 400))
        textView.textAlignment = .center
        textView.text = "On June 28, 2001, Sai Kambampati was born in the capital of the Golden State. Passionate about computers from a young age, Sai began to tinker with his computer at the mere age of 4. He wrote his first 'Hello World!' program at the age of 10 in Python. In the summer of 2016, Sai started to learn Swift and has come a long way since. It was around the same time that he became interested in Artificial Intelligence. Seeing the WWDC 2017 Scholarship as a way to demonstrate his knowledge, Sai designed me, Ava: a chatbot designed to make mornings more enjoyable."
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.font = UIFont(name: "GillSans", size: 20)
        self.view.addSubview(textView)
        
        let goBack = UIButton(frame: CGRect(x: 0, y: 600, width: 375, height: 60))
        goBack.showsTouchWhenHighlighted = true
        goBack.setTitle("Return to the Main Menu", for: .normal)
        goBack.addTarget(self, action: #selector(self.returnHome(sender:)), for: .touchUpInside)
        self.view.addSubview(goBack)
    }
    
    func returnHome(sender: UIButton!) {
        present(MenuViewController(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}

extension Array {
    func randomElement() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

let splash = SplashViewController()
PlaygroundPage.current.liveView = splash
