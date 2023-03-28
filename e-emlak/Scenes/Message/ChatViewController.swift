//
//  ChatViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 27.03.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    // MARK: - Properties
    public var isNewConversation = false
    private var messages = [Message]()
    
    private let selfSender = Sender(
        photoURL: "",
        senderId: "1",
        displayName: "Joe Smith")
    
    private let sender = Sender(
        photoURL: "",
        senderId: "2",
        displayName: "Joe sddasdsa")
    
    // MARK: - Subviews
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")
        button.tintColor = .black
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World message")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World WorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorld")))
        
        messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello World asdfgh")))
        
        view.backgroundColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        loadFirstMessages()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        print(messages.count)
    }
    
    // MARK: - Helpers
    private func loadFirstMessages() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: false)
        }
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        // Send message
        if isNewConversation {
            // create convo in database
        } else {
            // append to existing conversation data
            print("Append to existing conversation data")
        }
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentSender: MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }

}
