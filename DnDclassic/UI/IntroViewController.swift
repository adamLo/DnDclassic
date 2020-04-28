//
//  IntroViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 25/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var game: Game!
    var fileName: String!
    
    private struct Segues {
        static let begin = "begin"
        static let generateCharacter = "generateCharacter"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        resetContent()
        
        fileName = "warlock-firetop-mountain.json"
        loadGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
        
        view.backgroundColor = Colors.defaultBackground
        
        title = Strings.navigationTitleIntro
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.alpha = 0.6
        
        beginButton.setTitle(Strings.buttonTitleBegin, for: .normal)
        
        setupFonts()
        setupColors()
    }
    
    private func setupFonts() {
        
        titleLabel.font = UIFont.defaultFont(style: .bold, size: .large)
        authorLabel.font = UIFont.defaultFont(style: .regular, size: .small)
        copyrightLabel.font = UIFont.defaultFont(style: .regular, size: .small)
        introTextView.font = UIFont.defaultFont(style: .regular, size: .base)
        
        beginButton.titleLabel?.font = UIFont.defaultFont(style: .bold, size: .large)
    }
    
    private func setupColors() {
        
        for label in [titleLabel, authorLabel, copyrightLabel] {
            label?.textColor = Colors.textDefault
            label?.backgroundColor = Colors.textBackground
        }
        
        introTextView.textColor = Colors.textDefault
        beginButton.setTitleColor(Colors.textDefault, for: .normal)
    }
    
    // MARK: - UI manipulations
    
    private func resetContent() {
        
        loadingActivityIndicator.stopAnimating()
        loadingActivityIndicator.isHidden = true
        
        coverImageView.image = nil
        
        introTextView.text = nil
        introTextView.contentInset = UIEdgeInsets.zero
        
        titleLabel.text = nil
        authorLabel.text = nil
        
        beginButton.isHidden = true
    }
    
    private func displayGame() {
        
        guard game != nil else {return}
        
        coverImageView.image = game.cover
        titleLabel.text = game.title
        
        if let _author = game.author, let _published = game.published {
            authorLabel.text = "\(_author), \(_published)"
        }
        else if let _author = game.author {
            authorLabel.text = _author
        }
        else {
            authorLabel.text = nil
        }
        
        copyrightLabel.text = game.copyright?.nilIfEmpty
        
        introTextView.attributedText = NSMutableAttributedString(string: game.intro ?? "", attributes: [NSAttributedString.Key.foregroundColor: Colors.textDefault, NSAttributedString.Key.backgroundColor: Colors.textBackground, NSAttributedString.Key.font: UIFont.defaultFont(style: .regular, size: .base)])
        introTextView.contentInset = UIEdgeInsets(top: coverImageView.frame.size.height - 30, left: 0, bottom: beginButton.frame.size.height + 10, right: 0)
        
        beginButton.isHidden = game.firstScene == nil
    }

    // MARK: - Data integration
    
    private func loadGame() {
        
        guard game == nil, let _fileName = fileName, !_fileName.isEmpty else {return}
        
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
         
            let _game = Game(fileName: _fileName)
            
            DispatchQueue.main.async {
            
                guard let _self = self else {return}
                
                _self.loadingActivityIndicator.stopAnimating()
                _self.loadingActivityIndicator.isHidden = true
                
                if let __game = _game {
                    _self.game = __game
                    GameData.shared.game = __game
                                        
                    let player = Character(isPlayer: true, name: "Adam Test", dexterity: Character.generate(property: .dexterity), health: Character.generate(property: .health), luck: Character.generate(property: .luck), inventory: Character.startInventory)
                    GameData.shared.player = player
                    player.changed?()
                    
                    // FIXME: Remove in production!
                    player.add(inventoryItem: Potion(type: .luck))
                    player.add(inventoryItem: Money(amount: 50))
                    
                    _self.displayGame()
                }
                else {
                    let alert = UIAlertController(title: nil, message: Strings.messageFailedLoadGame, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.OKAction())
                    _self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func beginButtonTouched(_ sender: Any) {
        
        if GameData.shared.player == nil {
            performSegue(withIdentifier: Segues.generateCharacter, sender: self)
        }
        else {
            startGame()
        }
    }
    
    private func startGame() {
        
        guard GameData.shared.game != nil, let scene = GameData.shared.game.firstScene else {return}
        performSegue(withIdentifier: Segues.begin, sender: scene)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Segues.generateCharacter, let navController = segue.destination as? UINavigationController, let destination = navController.viewControllers.first as? CharacterEditViewController {

            destination.playerCreated = {[weak self] (player) in
                GameData.shared.player = player
                self?.startGame()
            }
        }
        else if segue.identifier == Segues.begin, let scene = sender as? Scene, let destination = segue.destination as? MainTabViewController {
            destination.scene = scene
        }
    }

}
