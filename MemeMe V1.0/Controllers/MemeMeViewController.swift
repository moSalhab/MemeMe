//
//  ViewController.swift
//  MemeMe V1.0
//
//  Created by Mohammad Salhab on 1/21/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
    }


    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func PickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imagePickerView.image = image
                
                //self.userProfileImage.contentMode = .scaleAspectFit
            }

            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    
        let memeTextAttributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3
        ]
    
        
        func textFieldDidBeginEditing(_ textField: UITextField) {

            if textField.tag == 0 && textField.text == "TOP" {

                    textField.text = ""

            }

            if textField.tag == 1 && textField.text == "BOTTOM" {

                    textField.text = ""

            }

        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return textField.resignFirstResponder()
        }
        
        
        @objc func keyboardWillShow(_ notification:Notification) {
            if bottomTextField.isEditing {
                view.frame.origin.y = -getKeyboardHeight(notification)
            }
        }

        @objc func keyboardWillHide(_ notification:Notification) {
            if bottomTextField.isEditing {
                view.frame.origin.y = 0
            }
        }
        
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {

            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
        }
        
        func subscribeToKeyboardNotifications() {
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        }

        
        
        
        func unsubscribeFromKeyboardNotifications() {

            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        

        
        
        func save() {
            // Create the meme
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
        }
        
        
        func generateMemedImage() -> UIImage {

            // TODO: Hide toolbar and navbar
            self.navigationController?.isNavigationBarHidden = true
            bottomBar.isHidden = true

            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            // TODO: Show toolbar and navbar
            self.navigationController?.isNavigationBarHidden = true
            bottomBar.isHidden = false



            return memedImage
        }
    
    
    @IBAction func share(_ sender: Any) {
        let memeImage = generateMemedImage()
        let activityViewContoller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        present(activityViewContoller, animated: true, completion: nil)

        activityViewContoller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
            if completed {
                self.save()
            }
        }
    }
    
    
}

