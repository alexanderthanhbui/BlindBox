//
//  ChatViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import JSQMessagesViewController
import Parse

class ChatViewController: JSQMessagesViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userObjectID = PFUser.current()!.objectId!
    
    @IBAction func moreButton(_ sender: AnyObject) {
        // Create an option menu as an action sheet
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Are you sure?", message: nil,
                preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "No", style: .default, handler:
                nil))
            alertMessage.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                nil))
            self.present(alertMessage, animated: true, completion: nil)}
        let leaveActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Are you sure?", message: "You won't be able to rejoin the BlindBox",
                preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "No", style: .default, handler:
                nil))
            alertMessage.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                {
                 (result:UIAlertAction!) -> Void in
                    let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
                    query.getObjectInBackground(withId: self.groupId) {
                        (gameScore: PFObject?, error: Error?) -> Void in
                        if error != nil {
                            print(error)
                        } else if let gameScore = gameScore {
                            let playerName = gameScore[PF_GROUPS_POINTER] as! NSMutableArray
                            print("\(playerName.count) old count")
                            playerName.remove(self.userObjectID)
                            gameScore[PF_GROUPS_POINTER] = playerName
                            print("\(playerName.count) new count")
                            gameScore[PF_GROUPS_FULL] = false
                            gameScore.saveInBackground()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                 }))
            self.present(alertMessage, animated: true, completion: nil)}

        let callAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        let isVisitedAction = UIAlertAction(title: "Leave BlindBox", style: .default, handler: leaveActionHandler)
        optionMenu.addAction(isVisitedAction)
        // Display the menu
        self.present(optionMenu, animated: true, completion: nil)
    }
    var timer: Timer = Timer()
    var isLoading: Bool = false
    
    var groupId: String = ""
    
    var users = [PFUser]()
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    
    var blankAvatarImage: JSQMessagesAvatarImage!
    
    var senderImageUrl: String!
    var batchMessages = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()
        self.senderId = user!.objectId
        self.senderDisplayName = user![PF_USER_FIRSTNAME] as! String
        
        outgoingBubbleImage = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImage = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profile_blank"), diameter: 30)
        
        isLoading = false
        self.loadMessages()
        Messages.clearMessageCounter(groupId);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView!.collectionViewLayout.springinessEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ChatViewController.loadMessages), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    // Mark: - Backend methods
    
    func loadMessages() {
        if self.isLoading == false {
            self.isLoading = true
            let lastMessage = messages.last
            
            let query = PFQuery(className: PF_CHAT_CLASS_NAME)
            query.whereKey(PF_CHAT_GROUPID, equalTo: groupId)
            if lastMessage != nil {
                query.whereKey(PF_CHAT_CREATEDAT, greaterThan: (lastMessage?.date)!)
            }
            query.includeKey(PF_CHAT_USER)
            query.order(byDescending: PF_CHAT_CREATEDAT)
            query.limit = 50
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    self.automaticallyScrollsToMostRecentMessage = false
                    for object in Array((objects as! [PFObject]!).reversed()) {
                        self.addMessage(object)
                    }
                    if objects!.count > 0 {
                        self.finishReceivingMessage()
                        self.scrollToBottom(animated: false)
                    }
                    self.automaticallyScrollsToMostRecentMessage = true
                } else {
                    ProgressHUD.showError("Network error")
                }
                self.isLoading = false;
            })
        }
    }
    
    func addMessage(_ object: PFObject) {
        var message: JSQMessage!
        
        var user = object[PF_CHAT_USER] as! PFUser
        var name = user[PF_USER_FIRSTNAME] as! String
        
        var videoFile = object[PF_CHAT_VIDEO] as? PFFile
        var pictureFile = object[PF_CHAT_PICTURE] as? PFFile
        
        if videoFile == nil && pictureFile == nil {
            message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, text: (object[PF_CHAT_TEXT] as? String))
        }
        
        if videoFile != nil {
            var mediaItem = JSQVideoMediaItem(fileURL: URL(string: videoFile!.url!), isReadyToPlay: true)
            message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, media: mediaItem)
        }
        
        if pictureFile != nil {
            var mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem?.appliesMediaViewMaskAsOutgoing = (user.objectId == self.senderId)
            message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, media: mediaItem)
            
            pictureFile!.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    mediaItem?.image = UIImage(data: imageData!)
                    self.collectionView!.reloadData()
                }
            })
        }
        
        users.append(user)
        messages.append(message)
    }
    
    func sendMessage(_ text: String, video: URL?, picture: UIImage?) {
        var text = text
        var videoFile: PFFile!
        var pictureFile: PFFile!
        
        if let video = video {
            text = "[Video message]"
            videoFile = PFFile(name: "video.mp4", data: FileManager.default.contents(atPath: video.path)!)
            
            videoFile.saveInBackground(block: { (succeeed: Bool, error: Error?) -> Void in
                if error != nil {
                    ProgressHUD.showError("Network error")
                }
            })
        }
        
        if let picture = picture {
            text = "[Picture message]"
            pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(picture, 0.6)!)
            pictureFile.saveInBackground(block: { (suceeded: Bool, error: Error?) -> Void in
                if error != nil {
                    ProgressHUD.showError("Picture save error")
                }
            })
        }
        
        let object = PFObject(className: PF_CHAT_CLASS_NAME)
        object[PF_CHAT_USER] = PFUser.current()
        object[PF_CHAT_GROUPID] = self.groupId
        object[PF_CHAT_TEXT] = text
        if let videoFile = videoFile {
            object[PF_CHAT_VIDEO] = videoFile
        }
        if let pictureFile = pictureFile {
            object[PF_CHAT_PICTURE] = pictureFile
        }
        object.saveInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.loadMessages()
            } else {
                ProgressHUD.showError("Network error")
            }
        }
        
        PushNotication.sendPushNotification(groupId, text: text)
        Messages.updateMessageCounter(groupId, lastMessage: text)
        
        self.finishSendingMessage()
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.sendMessage(text, video: nil, picture: nil)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take photo", "Choose existing photo", "Choose existing video")
        action.show(in: self.view)
    }
    
    // MARK: - JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        var user = self.users[indexPath.item]
        if self.avatars[user.objectId!] == nil {
            var thumbnailFile = user[PF_USER_THUMBNAIL] as? PFFile
            thumbnailFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    self.avatars[user.objectId! as String] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data: imageData!), diameter: 30)
                    self.collectionView!.reloadData()
                }
            })
            return blankAvatarImage
        } else {
            return self.avatars[user.objectId!]
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = self.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        return nil;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return nil
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[(indexPath as NSIndexPath).item]
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    // MARK: - UICollectionView flow layout
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0
    }
    
    // MARK: - Responding to CollectionView tap events
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        print("didTapLoadEarlierMessagesButton")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
        print("didTapAvatarImageview")

        // Create an option menu as an action sheet
        if self.messages[indexPath.item].senderId != PFUser.current()!.objectId {
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Are you sure?", message: nil,
                preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "No", style: .default, handler:
                nil))
            alertMessage.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                nil))
            self.present(alertMessage, animated: true, completion: nil)}
        let callAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        let isVisitedAction = UIAlertAction(title: "View " + self.messages[indexPath.item].senderDisplayName + "'s Profile", style: .default,
            handler: { action in self.performSegue(withIdentifier: "Load Profile View", sender: indexPath) }
            /*{
            (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            } */
        )
        optionMenu.addAction(isVisitedAction)
        // Display the menu
        self.present(optionMenu, animated: true, completion: nil)
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue!, sender: Any!) {
        if (segue.identifier == "Load Profile View") {
            // pass data to next view
            let selectedIndexPath = sender as! IndexPath
            let indexPath = (selectedIndexPath as NSIndexPath).row
            let chatVC = segue.destination as! PublicProfileTableViewController
            chatVC.groupId = self.messages[indexPath].senderId as String
            chatVC.groupObject = self.users[indexPath]
            print(chatVC.groupId)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = self.messages[indexPath.item]
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let moviePlayer = MPMoviePlayerViewController(contentURL: mediaItem.fileURL)
                self.presentMoviePlayerViewControllerAnimated(moviePlayer)
                moviePlayer?.moviePlayer.play()
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        print("didTapCellAtIndexPath")
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            if buttonIndex == 1 {
                Camera.shouldStartCamera(self, canEdit: true, frontFacing: true)
            } else if buttonIndex == 2 {
                Camera.shouldStartPhotoLibrary(self, canEdit: true)
            } else if buttonIndex == 3 {
                Camera.shouldStartVideoLibrary(self, canEdit: true)
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let video = info[UIImagePickerControllerMediaURL] as? URL
        let picture = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.sendMessage("", video: video, picture: picture)
        
        picker.dismiss(animated: true, completion: nil)
    }
}
