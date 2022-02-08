//
//  SettingsViewController.swift
//  AnikaApp
//
//  Created by Patrick Rugebregt on 05/02/2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tempoTextField: UITextField!
    @IBOutlet weak var tempoAdd: UIStepper!
    @IBOutlet weak var keyPickerView: UIPickerView!
    @IBOutlet weak var transposeAdd: UIStepper!
    private var musicPlayer = MusicPlayer.shared
    private var currentKey: Key?
    private var currentTempo: Float = 0
    private var song: Song? {
        get {
            return musicPlayer.chosenSong
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyPickerView.delegate = self
        tempoTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tempoTextField.text = "\(song?.tempo ?? 0)"
        tempoAdd.maximumValue = 300
        tempoAdd.minimumValue = 30
        tempoAdd.value = Double(song?.tempo ?? 0)
        keyPickerView.reloadAllComponents()
        let index = Key.allCases.firstIndex(where: {$0 == song?.key ?? .C})!
        currentKey = song?.key ?? .C
        keyPickerView.selectRow(index, inComponent: 0, animated: true)
    }

    @IBAction func tempoAddPressed(_ sender: UIStepper) {
        tempoTextField.text = "\(sender.value)"
        musicPlayer.pitchNode.rate = Float(sender.value) / (song?.tempo ?? 0)
    }
    
    @IBAction func transposeAddPressed(_ sender: UIStepper) {
        print(sender.value)
        let index = Key.allCases.firstIndex(where: {$0 == song?.key ?? .C})!
        keyPickerView.selectRow(index + Int(sender.value), inComponent: 0, animated: true)
        musicPlayer.pitchNode.pitch = Float(sender.value * 100)
    }
    
}

extension SettingsViewController: UIPickerViewDelegate {
    
    
}

extension SettingsViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Key.allCases[row].rawValue
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Key.allCases.count
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let tempoValue = Float(textField.text ?? "") else { return }
        if Double(tempoValue) > tempoAdd.minimumValue && Double(tempoValue) < tempoAdd.maximumValue {
            musicPlayer.pitchNode.rate = tempoValue / (song?.tempo ?? 0)
        } else {
            textField.text = "\(song?.tempo ?? 100)"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
