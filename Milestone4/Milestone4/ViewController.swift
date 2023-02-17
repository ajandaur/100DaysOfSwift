//
//  ViewController.swift
//  Milestone4
//
//  Created by Anmol  Jandaur on 2/12/23.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var pictures = [PictureImage]()
    
    /*
     
     Your challenge is to put two different projects into one: I’d like you to let users take photos of things that interest them, add captions to them, then show those photos in a table view. Tapping the caption should show the picture in a new view controller, like we did with project 1. So, your finished project needs to use elements from both project 1 and project 12, which should give you ample chance to practice.
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Interesting Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([PictureImage].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedData")
        } else {
            print("Failed to save pictures")
        }
    }
    
    @objc func addNewImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if let avaliableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                picker.mediaTypes = avaliableMediaTypes
                picker.sourceType = .camera
            }
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // That creates a new constant called cell by dequeuing a recycled cell from the table. We have to give it the identifier of the cell type we want to recycle, so we enter the same name we gave Interface Builder: “Picture”.
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath)
        
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.imageName

        
        return cell
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage else{return}
            
            let imageName = UUID().uuidString
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 0.8){
                try? jpegData.write(to: imagePath)
            }
            
            let newCell = PictureImage(name: imageName, captionText: "What is this photo?")
        
            pictures.append(newCell)
            dismiss(animated: true){
                
                let ac = UIAlertController(title: "Adding captions to photo", message:  nil, preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Add", style: .default) {[weak self, weak ac] _ in
                    if let newLabel = ac?.textFields?[0].text{
                        newCell.caption = newLabel
                        self?.tableView.reloadData()
                        self?.save()
                    }
                })
                self.present(ac, animated: true)
            }
            tableView.reloadData()
            save()
        }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
                
                let path = getDocumentsDirectory().appendingPathComponent(pictures[indexPath.row].imageName)
                vc.selectedImage = path.path
                vc.photoTitle = pictures[indexPath.row].caption
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    


}

