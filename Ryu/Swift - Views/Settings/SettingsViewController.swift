//
//  SettingsViewController.swift
//  Ryu
//
//  Created by Francesco on 22/06/24.
//

import UIKit
import UniformTypeIdentifiers

class SettingsViewController: UITableViewController {

    @IBOutlet var autoPlaySwitch: UISwitch!
    @IBOutlet var landScapeSwitch: UISwitch!
    @IBOutlet var browserPlayerSwitch: UISwitch!
    @IBOutlet var mergeActivitySwitch: UISwitch!
    
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    
    @IBOutlet weak var episodeSortingSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var holdSpeedSteppper: UIStepper!
    @IBOutlet weak var holdSpeeedLabel: UILabel!
    
    let githubURL = "https://github.com/cranci1/Ryu/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHoldSpeedStepper()
        loadUserDefaults()
        setupMenu()
        
        if let selectedOption = UserDefaults.standard.string(forKey: "selectedMediaSource") {
            sourceButton.setTitle(selectedOption, for: .normal)
        }
        
        let isReverseSorted = UserDefaults.standard.bool(forKey: "isEpisodeReverseSorted")
        episodeSortingSegmentedControl.selectedSegmentIndex = isReverseSorted ? 1 : 0
    }
    
    private func setupHoldSpeedStepper() {
        let holdSpeed = UserDefaults.standard.float(forKey: "holdSpeedPlayer")
        holdSpeedSteppper.value = Double(holdSpeed)
        holdSpeedSteppper.minimumValue = 0.50
        holdSpeedSteppper.maximumValue = 5.0
        holdSpeedSteppper.stepValue = 0.25
        updateHoldSpeedLabel()
    }
    
    @IBAction func holdSpeedStepperValueChanged(_ sender: UIStepper) {
        let holdSpeed = Float(sender.value)
        UserDefaults.standard.set(holdSpeed, forKey: "holdSpeedPlayer")
        updateHoldSpeedLabel()
    }
    
    private func updateHoldSpeedLabel() {
        let holdSpeeed = UserDefaults.standard.float(forKey: "holdSpeedPlayer")
        holdSpeeedLabel.text = String(format: "Hold Speed player: %.2fx", holdSpeeed)
    }
    
    @IBAction func episodeSortingChanged(_ sender: UISegmentedControl) {
        let isReverseSorted = sender.selectedSegmentIndex == 1
        UserDefaults.standard.set(isReverseSorted, forKey: "isEpisodeReverseSorted")
    }
    
    @IBAction func githubTapped(_ sender: UITapGestureRecognizer) {
        openURL(githubURL)
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func selectSourceButtonTapped(_ sender: Any) {
        SourceMenu.showSourceSelector(from: self, sourceView: sender as? UIView)
        
        if let selectedOption = UserDefaults.standard.string(forKey: "selectedMediaSource") {
            sourceButton.setTitle(selectedOption, for: .normal)
        }
    }
    
    func setupMenu() {
        let defaultIcon = UIImage(systemName: "play.rectangle.fill")
        let infuseIcon = UIImage(systemName: "flame")
        let vlcIcon = UIImage(systemName: "film")
        let outIcon = UIImage(systemName: "play.circle.fill")

        let action1 = UIAction(title: "Default", image: defaultIcon, handler: { [weak self] _ in
            UserDefaults.standard.set("Default", forKey: "mediaPlayerSelected")
            self?.playerButton.setTitle("Default", for: .normal)
        })
        let action2 = UIAction(title: "VLC", image: vlcIcon, handler: { [weak self] _ in
            UserDefaults.standard.set("VLC", forKey: "mediaPlayerSelected")
