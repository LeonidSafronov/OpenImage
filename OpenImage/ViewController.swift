//
//  ViewController.swift
//  OpenImage
//
//  Created by Leonid Safronov on 24.11.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadedImageView.isHidden = true
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                        imageView.addGestureRecognizer(tapImage)
                        imageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let image = imageView.image, let id = id else {
                return
            }
            saveImageToStorage(imageName: id, image: image)
            loadedImage = loadImageFromStorage(fileName: id)
            loadedImageView.image = loadedImage
            loadedImageView.isHidden = false
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var loadedImageView: UIImageView!
    @IBAction func chooseImageButton(_ sender: Any) {
        setImage()
    }
    
    private var id: String?
    private var loadedImage: UIImage?
    
    func saveImageToStorage(imageName: String, image: UIImage) {

        guard let documentsDirectory = FileManager.default.urls(for: .autosavedInformationDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }

    func loadImageFromStorage(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.picturesDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagePicker = info[.editedImage]
        let imageName = info[.imageURL] as? URL
        imageView.image = imagePicker as? UIImage
        guard let imageName = imageName else {
            return
        }
        id = "/\(imageName.lastPathComponent)"
        dismiss(animated: true, completion: nil)
    }
    
    func presentImageFromStorage(image: UIImage) {
        
    }
}

