//
//  ChatViewController.swift
//  e-emlak
//
//  Created by Hakan Or on 27.03.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var photoURL: URL?
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    // MARK: - Properties
    private var currentUser : User?
    private var otherUser :  User?
    private var conversationId: String?
    public var isNewConversation = false
    
    private var messages = [Message]()
    
    private var selfSender = Sender(
        photoURL: URL(string: ""),
        senderId: "1",
        displayName: "Joe Smith")
    
    private var sender = Sender(
        photoURL: URL(string: ""),
        senderId: "2",
        displayName: "Joe sddasdsa")
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()

    
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
    
    init(conversationId: String, currentUser: User?, otherUser: User?) {
        self.conversationId = conversationId
        self.currentUser = currentUser
        self.otherUser = otherUser
        super.init(nibName: nil, bundle: nil)
        
        self.sender.photoURL = otherUser?.imageUrl ?? URL(string: "")
        self.sender.senderId = otherUser?.uid ?? ""
        self.sender.displayName = otherUser?.name ?? ""
        self.selfSender.photoURL = currentUser?.imageUrl ?? URL(string: "")
        self.selfSender.senderId = currentUser?.uid ?? ""
        self.selfSender.displayName = currentUser?.name ?? ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.sendButton.setTitle("Gönder", for: .normal)
        messageInputBar.sendButton.setImage(UIImage(systemName: "pencil"), for: .normal)
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World message")))
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello World WorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorld")))
//
//        messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello World asdfgh")))

        view.backgroundColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        checkConversationIsExist()
        loadFirstMessages()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        print(messages.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    // MARK: - Helpers
    private func loadFirstMessages() {
        DispatchQueue.main.async {
            self.listenForMessages()
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
    private func createMessageId() -> String? {
        // date, otherUserId, currentUserId, randomInt
        guard let currentUserId = self.currentUser?.uid else {
            return nil
        }
        
        guard let otherUserId = self.otherUser?.uid else {
            return nil
        }

        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserId)_\(currentUserId)_\(dateString)"

        print("created message id: \(newIdentifier)")

        return newIdentifier
    }
    
    private func checkConversationIsExist() {
//        ChatService.shared.isConversationExist(currentUserId: self.currentUser?.uid ?? "" , sellerId: self.otherUser?.uid ?? "") { result in
//            switch result {
//            case .success(let exists):
//                if exists {
//                    print("Conversation exists!")
//                } else {
//                    print("No conversation found")
//                }
//            case .failure(let error):
//                print("Error checking conversation existence: \(error.localizedDescription)")
//            }
//        }
        ChatService.shared.getConversationId(currentUserId: self.currentUser?.uid ?? "" , sellerId: self.otherUser?.uid ?? "") { result in
            switch result {
            case .success(let conversationId):
                self.conversationId = conversationId
                self.isNewConversation = false
                self.observeMessages()
                print("Conversation ID is: \(conversationId)")
            case .failure(let error):
                self.isNewConversation = true
                print("Error fetching conversation ID: \(error.localizedDescription)")
            }
        }
    }
    
    private func listenForMessages() {
        ChatService.shared.fetchMessages(currentUserId: self.currentUser?.uid ?? "" , sellerId: self.otherUser?.uid ?? "") { result in
            switch result {
            case.success(let messages):
                self.messages = messages
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            case .failure(_):
                print("error while getting messages")
            }
        }
    }
    
    private func observeMessages() {
        let conversationId = self.conversationId ?? ""
        ChatService.shared.observeConversation(conversationId: conversationId) { result in
            switch result {
            case .success(let message):
            // handle the new message
                self.messages = message
                self.messagesCollectionView.reloadDataAndKeepOffset()
            case .failure(let error):
                print("Error observing conversation: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Selectors
    @objc func handleBack(){
        self.dismiss(animated: true)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let messageId = createMessageId() else {
                return
            }
        
        let message = Message(sender: self.selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        messages.append(message)
        messagesCollectionView.reloadDataAndKeepOffset()
        
        // Send message
        if isNewConversation {
            // create convo in database
            ChatService.shared.sendMessage(currentUserId: self.currentUser?.uid ?? "", sellerId: self.otherUser?.uid ?? "", text: text) { error in
                self.observeMessages()
            }
        } else {
            // Append to existing conversation data
            let conversationId = self.conversationId ?? ""
            ChatService.shared.sendMessage(with: conversationId, currentUserId: self.currentUser?.uid ?? "", sellerId: self.otherUser?.uid ?? "", text: text) { error in
            }
        }
        inputBar.inputTextView.text = ""
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
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender.senderId {
            return themeColors.primary
        }
        return .secondarySystemBackground
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        
        if sender.senderId == selfSender.senderId {
            if let currentUserImageURL = self.selfSender.photoURL {
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            }
        }
        
        else {
            if let otherUserPhotoUrl = self.sender.photoURL {
                avatarView.sd_setImage(with: otherUserPhotoUrl, completed: nil)
            }
        }
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}
