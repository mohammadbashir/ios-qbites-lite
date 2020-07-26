//
//  AddRecepieViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 1/20/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import CropViewController
import SkyFloatingLabelTextField

class AddRecepieViewController: UIViewController, UIScrollViewDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var instructionsTableHeight:NSLayoutConstraint!
    var ingredientsTableHeight:NSLayoutConstraint!
    var cellHeight = 40
    
    var measurmentsArray = ["", "Teaspoon", "Tablespoon", "Cup", "Oz", "Fluid oz.", "g", "ml", "can"]
    
    //---
    var imageId = -1
    var name = ""
    var cuisineId = -1
    var servingsNumber = -1
    var activeTime = -1
    var preparationTime = -1
    var ingredients = [Ingredient()]
    var instructions = [""]
    //---
    
    var activeTextField = UITextField()
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.contentMode = .scaleAspectFill
        button.setTitle("Add Image", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 20)
        button.titleLabel?.textColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(imageButtonPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "RECIPE NAME"
        field.addTarget(self, action: #selector(textFieldDidChange( sender:)), for: UIControl.Event.editingChanged)
        field.tag = 0
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    lazy var cuisineField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "CUISINE"
        
        field.tag = -2
        field.delegate = self
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    lazy var servingsField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "SERVINGS"
        field.tag = 3
        field.delegate = self
        field.inputAccessoryView = doneToolbar
        field.inputView = servingsPicker
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    lazy var servingsPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 3
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var activeTimeField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "ACTIVE TIME"
        field.tag = 4
        field.delegate = self
        field.inputAccessoryView = doneToolbar
        field.inputView = activeTimePicker
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    lazy var activeTimePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 4
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var preparationTimeField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "PREPERAION TIME"
        field.tag = 5
        field.delegate = self
        field.inputAccessoryView = doneToolbar
        field.inputView = preparationTimePicker
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    lazy var preparationTimePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 5
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let ingredientsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "INGREDIENTS"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ingredientsTable: UITableView = {
        
        let tableView = UITableView()
        tableView.tag = 0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .black
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    
    let addIngredientButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = mainGreenColor
        button.contentMode = .scaleAspectFill
        button.setTitle("   Add Ingredient   ", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 12)
        button.titleLabel?.textColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(addIngredientPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let instructionsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "INSTRUCTIONS"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var instructionsTable: UITableView = {
        
        let tableView = UITableView()
        tableView.tag = 1
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    let addInstructionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainGreenColor
        button.contentMode = .scaleAspectFill
        button.setTitle("   Add Instruction   ", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 12)
        button.titleLabel?.textColor = UIColor.black
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(addInstructionPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let descriptionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "DESCRIPTION"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionField: UITextView = {
        
        let field = UITextView()
        field.font = mainFont(size: 12)
        field.tintColor = .black // the color of the blinking cursor
        field.textColor = .black
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.backgroundColor = .clear
        field.isScrollEnabled = false
        field.inputAccessoryView = doneToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    let addRecipeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainGreenColor
        button.contentMode = .scaleAspectFill
        button.setTitle("Add Recipe", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 20)
        button.titleLabel?.textColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(addRecipePressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var doneToolbar: UIToolbar = {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ToolbarDonePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
        
    }()
    
    //for ingredients Table
//    lazy var unitPicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.delegate = self
//        picker.dataSource = self
//        picker.tag = 6
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        return picker
//    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.title = "Add Recipe"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow( notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide( notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // page observers
        NotificationCenter.default.addObserver(self, selector: #selector(cuisineSelected(_:)), name: NSNotification.Name(rawValue: "cuisineSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayIngredientSelected(_:)), name: NSNotification.Name(rawValue: "displayIngredientSelected"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //remove observers
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(imageButton)
        contentView.addSubview(nameField)
        contentView.addSubview(cuisineField)
        contentView.addSubview(servingsField)
        contentView.addSubview(activeTimeField)
        contentView.addSubview(preparationTimeField)
        
        contentView.addSubview(ingredientsTitle)
        contentView.addSubview(ingredientsTable)
        contentView.addSubview(addIngredientButton)
        
        contentView.addSubview(instructionsTitle)
        contentView.addSubview(instructionsTable)
        contentView.addSubview(addInstructionButton)
        
        contentView.addSubview(descriptionTitle)
        contentView.addSubview(descriptionField)
        
        contentView.addSubview(addRecipeButton)
        
        layoutViews()
    }
    
    
    
    func layoutViews(){
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant:0).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //        mainScrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        imageButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        imageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        imageButton.heightAnchor.constraint(equalTo: imageButton.widthAnchor, multiplier: 9/16).isActive = true
        imageButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        nameField.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 20).isActive = true
        nameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        nameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        cuisineField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20).isActive = true
        cuisineField.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 0.7).isActive = true
        cuisineField.leftAnchor.constraint(equalTo: nameField.leftAnchor, constant: 0).isActive = true
        
        servingsField.leftAnchor.constraint(equalTo: cuisineField.rightAnchor, constant: 5).isActive = true
        servingsField.rightAnchor.constraint(equalTo: nameField.rightAnchor, constant: 0).isActive = true
        servingsField.topAnchor.constraint(equalTo: cuisineField.topAnchor, constant: 0).isActive = true
        
        activeTimeField.topAnchor.constraint(equalTo: cuisineField.bottomAnchor, constant: 20).isActive = true
        activeTimeField.rightAnchor.constraint(equalTo: nameField.rightAnchor, constant: 0).isActive = true
        activeTimeField.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 0.5, constant: -5).isActive = true
        
        preparationTimeField.topAnchor.constraint(equalTo: activeTimeField.topAnchor, constant: 0).isActive = true
        preparationTimeField.leftAnchor.constraint(equalTo: nameField.leftAnchor, constant: 0).isActive = true
        preparationTimeField.widthAnchor.constraint(equalTo: activeTimeField.widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        
        ingredientsTitle.topAnchor.constraint(equalTo: preparationTimeField.bottomAnchor, constant: 30).isActive = true
        ingredientsTitle.leftAnchor.constraint(equalTo: nameField.leftAnchor, constant: 0).isActive = true
        
        ingredientsTable.topAnchor.constraint(equalTo: ingredientsTitle.bottomAnchor, constant: 5).isActive = true
        ingredientsTable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        ingredientsTable.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        
        addIngredientButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addIngredientButton.topAnchor.constraint(equalTo: ingredientsTable.bottomAnchor, constant: 10).isActive = true
        addIngredientButton.rightAnchor.constraint(equalTo: ingredientsTable.rightAnchor, constant: 0).isActive = true
        
        instructionsTitle.topAnchor.constraint(equalTo: addIngredientButton.bottomAnchor, constant: 30).isActive = true
        instructionsTitle.leftAnchor.constraint(equalTo: nameField.leftAnchor, constant: 0).isActive = true
        
        instructionsTable.topAnchor.constraint(equalTo: instructionsTitle.bottomAnchor, constant: 5).isActive = true
        instructionsTable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        instructionsTable.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        
        addInstructionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addInstructionButton.topAnchor.constraint(equalTo: instructionsTable.bottomAnchor, constant: 10).isActive = true
        addInstructionButton.rightAnchor.constraint(equalTo: instructionsTable.rightAnchor, constant: 0).isActive = true
        
        descriptionTitle.topAnchor.constraint(equalTo: addInstructionButton.bottomAnchor, constant: 30).isActive = true
        descriptionTitle.leftAnchor.constraint(equalTo: nameField.leftAnchor, constant: 0).isActive = true
        
        descriptionField.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: 5).isActive = true
        descriptionField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        descriptionField.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        descriptionField.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        addRecipeButton.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 20).isActive = true
        addRecipeButton.widthAnchor.constraint(equalTo: descriptionField.widthAnchor, multiplier: 1.0).isActive = true
        addRecipeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addRecipeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: addRecipeButton.bottomAnchor, constant: 20).isActive = true
        
        self.view.layoutIfNeeded()
        
        addInstructionButton.layer.cornerRadius = addInstructionButton.frame.size.height/2
        addIngredientButton.layer.cornerRadius = addIngredientButton.frame.size.height/2
        addRecipeButton.layer.cornerRadius = addRecipeButton.frame.size.height/2
        
        updateTableHeights()
        
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - (self.view.frame.size.height - mainScrollView.frame.size.height), right: 0)
            mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
    }
    
    @objc func imageButtonPressed(sender: UIButton){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //        if let pickedImage = info[.originalImage] as? UIImage { }
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage] as? UIImage {
                self.presentCropViewController(image: pickedImage)
            }
        }
    }
    
    func presentCropViewController(image: UIImage) {
        
        let cropViewController = CropViewController(croppingStyle: .default, image: image)
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPreset = .preset16x9
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        
        
        SVProgressHUD.show()
        
        RequestHelper.sharedInstance.uploadImage(image: image) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                
                self.imageId = response["id"] as! Int
                
                self.imageButton.imageView?.contentMode = .scaleAspectFit
                self.imageButton.setBackgroundImage(image, for: .normal)
                self.imageButton.setTitle("", for: UIControl.State.normal)
                self.imageButton.layoutIfNeeded()
                self.imageButton.subviews.first?.contentMode = .scaleAspectFill
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
        cropViewController.dismiss(animated: true) {}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView.tag == 0){
            return ingredients.count
        }
        else {
            return instructions.count
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if(tableView.tag == 0){
            
            let quanitityField = SkyFloatingLabelTextField()
            Utilities.sharedInstance.styleSkyField(field: quanitityField, color: .black)
            quanitityField.lineColor = mainGreenColor
            quanitityField.placeholder = "QUANTITY"
            quanitityField.text = ingredients[indexPath.row].quantity
            quanitityField.tag = indexPath.row
            quanitityField.addTarget(self, action: #selector(quantityFieldDidChange( sender:)), for: UIControl.Event.editingChanged)
            quanitityField.keyboardType = .decimalPad;
            quanitityField.inputAccessoryView = doneToolbar
            quanitityField.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(quanitityField)
            
            quanitityField.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
            quanitityField.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1).isActive = true
            quanitityField.widthAnchor.constraint(equalToConstant: 70).isActive = true
            
            let unitPicker: UIPickerView = {
                let picker = UIPickerView()
                picker.delegate = self
                picker.dataSource = self
                picker.tag = 100 + indexPath.row
                picker.translatesAutoresizingMaskIntoConstraints = false
                return picker
            }()
            
            let unitField = SkyFloatingLabelTextField()
            Utilities.sharedInstance.styleSkyField(field: unitField, color: .black)
            unitField.lineColor = mainGreenColor
            unitField.placeholder = "UNIT"
            unitField.text = ingredients[indexPath.row].unit
            unitField.tag = unitPicker.tag
//            unitField.addTarget(self, action: #selector(unitFieldDidChange( sender:)), for: UIControl.Event.editingChanged)
            unitField.inputView = unitPicker
            unitField.inputAccessoryView = doneToolbar
            unitField.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(unitField)
            
            unitField.leftAnchor.constraint(equalTo: quanitityField.rightAnchor, constant: 7).isActive = true
            unitField.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1).isActive = true
            unitField.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            let removeButton = UIButton()
            removeButton.backgroundColor = .red
            removeButton.tag = indexPath.row
            removeButton.addTarget(self, action: #selector(ingredientRemoveButtonPressed( sender:)),for: .touchUpInside)
            removeButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(removeButton)
            
            removeButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
            removeButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
            removeButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
            removeButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            let removeImage = UIImageView()
            removeImage.contentMode = .scaleToFill
            removeImage.image = UIImage(named: "delete")?.mask(with: .white)
            removeImage.isUserInteractionEnabled = false
            
            removeImage.translatesAutoresizingMaskIntoConstraints = false
            removeButton.addSubview(removeImage)
            
            removeImage.centerXAnchor.constraint(equalTo: removeButton.centerXAnchor, constant: 0).isActive = true
            removeImage.centerYAnchor.constraint(equalTo: removeButton.centerYAnchor, constant: 0).isActive = true
            removeImage.widthAnchor.constraint(equalTo: removeButton.widthAnchor, multiplier: 0.6).isActive = true
            removeImage.heightAnchor.constraint(equalTo: removeImage.widthAnchor, multiplier: 1.0).isActive = true
            
            let ingredientField = SkyFloatingLabelTextField()
            Utilities.sharedInstance.styleSkyField(field: ingredientField, color: .black)
            ingredientField.lineColor = mainGreenColor
            ingredientField.placeholder = "INGREDIENT"
            ingredientField.text = ingredients[indexPath.row].displayIngredient.name
            ingredientField.tag = 1000 + indexPath.row
//            ingredientField.addTarget(self, action: #selector(ingredientFieldDidChange( sender:)), for: UIControl.Event.editingChanged)
            ingredientField.translatesAutoresizingMaskIntoConstraints = false
            ingredientField.delegate = self
            cell.addSubview(ingredientField)
            
            ingredientField.leftAnchor.constraint(equalTo: unitField.rightAnchor, constant: 7).isActive = true
            ingredientField.rightAnchor.constraint(equalTo: removeButton.leftAnchor, constant: -3).isActive = true
            ingredientField.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1).isActive = true
            
            cell.layoutIfNeeded()
            
            removeButton.layer.cornerRadius = removeButton.frame.size.height/2
            
        }
        else{
            let bullet = UILabel()
            bullet.text = "• "
            bullet.textColor = UIColor.black
            bullet.font = mainFont(size: 20)
            bullet.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(bullet)
            
            bullet.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
            bullet.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10).isActive = true
            bullet.widthAnchor.constraint(equalToConstant: 15).isActive = true
            
            let removeButton = UIButton()
            removeButton.backgroundColor = .red
            removeButton.tag = indexPath.row
            removeButton.addTarget(self, action: #selector(instructionRemoveButtonPressed( sender:)),for: .touchUpInside)
            removeButton.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(removeButton)
            
            removeButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
            removeButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
            removeButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
            removeButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            let removeImage = UIImageView()
            removeImage.contentMode = .scaleToFill
            removeImage.image = UIImage(named: "delete")?.mask(with: .white)
            removeImage.isUserInteractionEnabled = false
            
            removeImage.translatesAutoresizingMaskIntoConstraints = false
            removeButton.addSubview(removeImage)
            
            removeImage.centerXAnchor.constraint(equalTo: removeButton.centerXAnchor, constant: 0).isActive = true
            removeImage.centerYAnchor.constraint(equalTo: removeButton.centerYAnchor, constant: 0).isActive = true
            removeImage.widthAnchor.constraint(equalTo: removeButton.widthAnchor, multiplier: 0.6).isActive = true
            removeImage.heightAnchor.constraint(equalTo: removeImage.widthAnchor, multiplier: 1.0).isActive = true
            
            let field = UITextField()
            field.textColor = .black
            field.delegate = self
            field.font = mainFont(size: 14)
            field.placeholder = "Insert instruction step"
            field.text = instructions[indexPath.row]
            field.tag = indexPath.row
            field.addTarget(self, action: #selector(instructionFieldDidChange( sender:)), for: UIControl.Event.editingChanged)
            field.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(field)
            
            field.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
            field.leftAnchor.constraint(equalTo: bullet.rightAnchor, constant: 0).isActive = true
            field.rightAnchor.constraint(equalTo: removeButton.leftAnchor, constant: -3).isActive = true
            
            cell.layoutIfNeeded()
            
            removeButton.layer.cornerRadius = removeButton.frame.size.height/2
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(cellHeight)
    }
    
    func updateTableHeights(){
        
        if(instructionsTableHeight != nil){
            instructionsTableHeight.isActive = false
        }
        if(ingredientsTableHeight != nil){
            ingredientsTableHeight.isActive = false
        }
        
        instructionsTableHeight = instructionsTable.heightAnchor.constraint(equalToConstant: CGFloat(instructionsTable.numberOfRows(inSection: 0)) * CGFloat(cellHeight))
        ingredientsTableHeight = ingredientsTable.heightAnchor.constraint(equalToConstant: CGFloat(ingredientsTable.numberOfRows(inSection: 0)) * CGFloat(cellHeight))
        
        if(instructionsTableHeight != nil){
            instructionsTableHeight.isActive = true
        }
        
        if(ingredientsTableHeight != nil){
            ingredientsTableHeight.isActive = true
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func addInstructionPressed(sender: UIButton){
        
        if instructions.contains("") {
            SVProgressHUD.showInfo(withStatus: "Please fill empty instruction first!")
        }
        else{
            instructions.append("")
            instructionsTable.reloadData()
            updateTableHeights()
        }
        
    }
    
    @objc func addIngredientPressed(sender: UIButton){
        
        var emptyIngredient = false
        
        for ingredient in ingredients {
            if(ingredient.displayIngredient.id == -1 && ingredient.quantity == ""){ // && ingredient.unit == ""
                emptyIngredient = true
            }
        }
        
        if(emptyIngredient){
            SVProgressHUD.showInfo(withStatus: "Please fill empty ingredient first!")
        }
        else{
            ingredients.append(Ingredient())
            ingredientsTable.reloadData()
            updateTableHeights()
        }
        
    }
    
    @objc func instructionFieldDidChange(sender: UITextField){
        instructions[sender.tag] = sender.text ?? ""
    }
    
    @objc func quantityFieldDidChange(sender: UITextField){
        ingredients[sender.tag].quantity = sender.text ?? ""
    }
    
//    @objc func unitFieldDidChange(sender: UITextField){
//        ingredients[sender.tag].unit = sender.text ?? ""
//    }
//
//    @objc func ingredientFieldDidChange(sender: UITextField){
//        ingredients[sender.tag].name = sender.text ?? ""
//    }
    
    @objc func ingredientRemoveButtonPressed(sender: UIButton){
        
        if(ingredients.count == 1){
            ingredients[0] = Ingredient()
            ingredientsTable.reloadData()
        }
        else{
            ingredients.remove(at: sender.tag)
            ingredientsTable.reloadData()
            updateTableHeights()
        }
        
    }
    
    @objc func instructionRemoveButtonPressed(sender: UIButton){
        
        if(instructions.count == 1){
            instructions[0] = ""
            instructionsTable.reloadData()
        }
        else{
            instructions.remove(at: sender.tag)
            instructionsTable.reloadData()
            updateTableHeights()
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField.tag == -2){ //cuisines
            self.view.endEditing(true)
            self.present(CuisineSearchViewController(), animated: true) {}
            return false
        }
        else if (textField.tag >= 1000){ //ingredients
            self.view.endEditing(true)
            let ingredientsVC = DisplayIngredientSearchViewController()
            ingredientsVC.view.tag = textField.tag % 1000
            self.present(ingredientsVC, animated: true) {}
            return false
        }
        
        return true
    }
    
    @objc func textFieldDidChange(sender: UITextField){
        
        if(sender.tag == 1){ //name
            name = sender.text ?? ""
        }
        
    }
    
    @objc func ToolbarDonePressed(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if(pickerView.tag == 3){ //servings
            return 1
        }
        else if(pickerView.tag == 4 || pickerView.tag == 5){ //active and preparation time
            return 2
        }
        else if(pickerView.tag >= 100 && pickerView.tag < 1000){
            return 1
        }
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 3){ //servings
            return 100
        }
        else if(pickerView.tag == 4 || pickerView.tag == 5){ //active and preparation time
            if(component == 0){
                return 10
            }
            else{
                return 59
            }
        }
        else if(pickerView.tag >= 100 && pickerView.tag < 1000){
            return measurmentsArray.count
        }
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 3){ //servings
            return String(row)
        }
        else if(pickerView.tag == 4 || pickerView.tag == 5){ //active and preparation time
            
            var label = ""
            
            if(component == 0){
                label = String(row) + " hour"
                if(row != 1){ label = label + "s" }
            }
            else{
                label = String(row) + " minute"
                if(row != 1){ label = label + "s" }
            }
            
            return label
        }
        else if(pickerView.tag >= 100 && pickerView.tag < 1000){
            return measurmentsArray[row]
        }
        
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 3){ //servings
            servingsField.text = String(row)
            servingsNumber = row
        }
        else if(pickerView.tag == 4){ //active time
            activeTime = 60*(pickerView.selectedRow(inComponent: 0)) + pickerView.selectedRow(inComponent: 1)
            var label = String(pickerView.selectedRow(inComponent: 0)) + " hour"
            if(pickerView.selectedRow(inComponent: 0) != 1){ label = label + "s"}
            label = label + " " + String(pickerView.selectedRow(inComponent: 1)) + " minute"
            if(pickerView.selectedRow(inComponent: 1) != 1){ label = label + "s"}
            activeTimeField.text = label
        }
        else if(pickerView.tag == 5){ //preparation time
            preparationTime = 60*(pickerView.selectedRow(inComponent: 0)) + pickerView.selectedRow(inComponent: 1)
            var label = String(pickerView.selectedRow(inComponent: 0)) + " hour"
            if(pickerView.selectedRow(inComponent: 0) != 1){ label = label + "s"}
            label = label + " " + String(pickerView.selectedRow(inComponent: 1)) + " minute"
            if(pickerView.selectedRow(inComponent: 1) != 1){ label = label + "s"}
            preparationTimeField.text = label
        }
        else if(pickerView.tag >= 100 && pickerView.tag < 1000){ //ingredientunit selection
            let tag = pickerView.tag % 100
            let cell = ingredientsTable.cellForRow(at: IndexPath(row: tag, section: 0))
            
            for view in cell!.subviews {
                if let textField = view as? UITextField {
                    if(textField.tag == pickerView.tag){
                        textField.text = measurmentsArray[row]
                        ingredients[tag].unit = measurmentsArray[row]
                    }
                }
            }
            
        }
        
    }
    
    @objc func cuisineSelected(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let cuisine = dict["cuisine"] as? Cuisine{
                cuisineId = cuisine.id
                cuisineField.text = cuisine.name
            }
        }
    }
    
    @objc func displayIngredientSelected(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let displayIngredient = dict["ingredient"] as? DisplayIngredient{
                if let tag = dict["tag"] as? Int {
                    ingredients[tag].displayIngredient = displayIngredient
                    ingredientsTable.reloadData()
                }
            }
        }
        
    }
    
    @objc func addRecipePressed(sender: UIButton){
        
        var emptyIngredient = false
        
        for ingredient in ingredients {
            if(ingredient.displayIngredient.id == -1 || ingredient.quantity == ""){ // && ingredient.unit == ""
                emptyIngredient = true
            }
        }
        
        if(nameField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Please insert recipe name!")
        }
        else if (cuisineId == -1){
            SVProgressHUD.showInfo(withStatus: "Please select a cuisine!")
        }
        else if (servingsNumber == -1){
            SVProgressHUD.showInfo(withStatus: "Please insert number of servings!")
        }
        else if (activeTime == -1){
            SVProgressHUD.showInfo(withStatus: "Please insert active time!")
        }
        else if (preparationTime == -1){
            SVProgressHUD.showInfo(withStatus: "Please insert preparation time!")
        }
        else if (instructions.contains("")) {
            SVProgressHUD.showInfo(withStatus: "Please fill the empty instruction first!")
        }
        else if (descriptionField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Please fill the recipe description!")
        }
        else if(emptyIngredient){
            SVProgressHUD.showInfo(withStatus: "quantity and name required for all ingredients!")
        }
        else{
            var params = [:] as [String: Any]
            
            if(imageId != -1){
                var attachmentsArray = [NSDictionary]()
                let attachmentDict = ["id" : imageId]
                attachmentsArray.append(attachmentDict as NSDictionary)
                
                params["attachments"] = attachmentsArray
            }
            
            params["name"]  = nameField.text
            params["cuisine"] = ["id" : cuisineId]
            params["numberServings"] = servingsNumber
            
            params["activeTimeHours"] = CGFloat(activeTime / 60)
            params["preparationTimeHours"] = CGFloat(preparationTime / 60)
            
//            params["activeTimeDisplay"] = activeTimeField.text?.replacingOccurrences(of: "0 hours", with: "").replacingOccurrences(of: "0 minutes", with: "").replacingOccurrences(of: " minutes", with: "m").replacingOccurrences(of: " minute", with: "m").replacingOccurrences(of: " hours", with: "h").replacingOccurrences(of: " hour", with: "h")
            
            params["activeTimeDisplay"] = activeTimeField.text?.replacingOccurrences(of: " hours", with: "h").replacingOccurrences(of: " hour", with: "h").replacingOccurrences(of: " minutes", with: "m").replacingOccurrences(of: " minute", with: "m").replacingOccurrences(of: "0h ", with: "").replacingOccurrences(of: " 0m", with: "")
            
            params["preparationTimeDisplay"] = preparationTimeField.text?.replacingOccurrences(of: " hours", with: "h").replacingOccurrences(of: " hour", with: "h").replacingOccurrences(of: " minutes", with: "m").replacingOccurrences(of: " minute", with: "m").replacingOccurrences(of: "0h ", with: "").replacingOccurrences(of: " 0m", with: "")
            
            var instructionsString = "<p>"
            for instruction in instructions {
                instructionsString = instructionsString + instruction + "<br/>"
            }
            instructionsString = instructionsString + "</p>"
            
            params["instructions"] = instructionsString
            params["description"] = descriptionField.text
            
            var ingredietsArray = [Any]()
            for ingredient in ingredients {
                let ingredientObjectDict = ["id": String(ingredient.displayIngredient.ingredientID)]
                let ingredientDict = ["ingredient": ingredientObjectDict, "quantity": ingredient.quantity, "unit": ingredient.unit, "displayName": ingredient.displayIngredient.name] as [String : Any]
                ingredietsArray.append(ingredientDict)
            }
            
            params["ingredients"] = ingredietsArray
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.createRecipe(params: params) { (response) in
                if(response["success"] as? Bool == true){
                    SVProgressHUD.dismiss()
                    self.navigationController?.popViewController(animated: true)
                    
                    let alertController = UIAlertController(title: "Success", message: "Recipe submitted successfully!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in }
                    alertController.addAction(okAction)
                    // Present the controller
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
            
        }
        
        
    }
    
}
