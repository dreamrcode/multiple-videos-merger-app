//
//  InitialViewController.swift
//  Multiple Videos Merger App
//
//  Created by Alejandro Giron on 7/20/22.
//

import UIKit
import AVKit
import MobileCoreServices
import AVFoundation
import Photos

class InitialViewController: UIViewController, UINavigationControllerDelegate {
    
    /// hold all video assets
    var assets: [AVAsset] = []
    
    /// button's height, dependent on device
    var mainButtonsHeight: CGFloat {
        get {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: return CGFloat(view.frame.height/20)
            case .pad: return CGFloat(view.frame.height/30)
            default: return CGFloat(view.frame.height/20)
            }
        }
    }
    
    /// button's width, dependent on device
    var mainButtonsWidth: CGFloat {
        get {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: return CGFloat(view.frame.height/3)
            case .pad: return CGFloat(view.frame.height/5)
            default: return CGFloat(view.frame.height/5)
            }
        }
    }
    
    /// table view that will hold the information of each video AVAsset
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "videocell")
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        return tableView
    }()
    
    /// the Image Picker View that will be used to pick videos.
    private lazy var imagePickerViewController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.movie"]
        return picker
    }()
    
    /// button for adding video AVAssets to assets array
    private lazy var addVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Video", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addVideoButtonTouched), for: .touchUpInside)
        return button
    }()
    
    /// button for removing video AVAssets from assets array
    private lazy var removeVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remove Video", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(removeVideoButtonTouched), for: .touchUpInside)
        return button
    }()
    
    /// button for merging all AVAssets
    private lazy var mergeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Merge Videos", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(mergeButtonTouched), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assets.removeAll()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}

// MARK: - UI Set-up

extension InitialViewController {
    
    private func setUpUI(){
        view.backgroundColor = .lightGray
        view.addSubview(addVideoButton)
        view.addSubview(removeVideoButton)
        view.addSubview(mergeButton)
        view.addSubview(tableView)
        
        addVideoButtonConstraints()
        removeVideoButtonConstraints()
        setUpMergeButtonConstraints()
        setUpTableViewConstraints()
    }
    
    private func setUpTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: addVideoButton.topAnchor, constant: -8.0)
        ])
        tableView.reloadData()
    }
    
    private func addVideoButtonConstraints() {
        NSLayoutConstraint.activate([
            addVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addVideoButton.heightAnchor.constraint(equalToConstant: mainButtonsHeight),
            addVideoButton.widthAnchor.constraint(equalToConstant: mainButtonsWidth)
        ])
    }
    
    private func removeVideoButtonConstraints() {
        NSLayoutConstraint.activate([
            removeVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeVideoButton.topAnchor.constraint(equalTo: addVideoButton.bottomAnchor, constant: 8.0),
            removeVideoButton.heightAnchor.constraint(equalToConstant: mainButtonsHeight),
            removeVideoButton.widthAnchor.constraint(equalToConstant: mainButtonsWidth)
        ])
    }
    
    private func setUpMergeButtonConstraints() {
        NSLayoutConstraint.activate([
            mergeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mergeButton.topAnchor.constraint(equalTo: removeVideoButton.bottomAnchor, constant: 8.0),
            mergeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8.0),
            mergeButton.heightAnchor.constraint(equalToConstant: mainButtonsHeight),
            mergeButton.widthAnchor.constraint(equalToConstant: mainButtonsWidth)
        ])
    }
    
    private func showAlert(title: String, message: String, handler: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler()
        }))
        present(alert, animated: true)
    }
}

// MARK: - Actions

extension InitialViewController {
    
    @objc private func addVideoButtonTouched() {
        present(imagePickerViewController, animated: true)
    }
    
    @objc private func removeVideoButtonTouched() {
        if assets.count != 0 {
            assets.removeLast()
            tableView.reloadData()
        }
    }
    
    @objc private func mergeButtonTouched() {
        
        var atTimeM: CMTime = CMTimeMake(value: 0, timescale: 0)
        var lastAsset: AVAsset!
        var layerInstructionsArray = [AVVideoCompositionLayerInstruction]()
        var completeTrackDuration: CMTime = CMTimeMake(value: 0, timescale: 1)
        var videoSize: CGSize = CGSize(width: 0.0, height: 0.0)
        
        let mixComposition = AVMutableComposition()
        for videoAsset in assets {
            let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do {
                if videoAsset == assets.first{
                    atTimeM = CMTime.zero
                } else {
                    atTimeM = lastAsset!.duration
                }
                try videoTrack!.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration),
                                                of: videoAsset.tracks(withMediaType: AVMediaType.video)[0],
                                                at: atTimeM)
                videoSize = videoTrack!.naturalSize
            } catch let error as NSError {
                print("error: \(error)")
            }
            completeTrackDuration = CMTimeAdd(completeTrackDuration, videoAsset.duration)
            let videoInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
            if videoAsset != assets.last {
                videoInstruction.setOpacity(0.0, at: videoAsset.duration)
            }
            layerInstructionsArray.append(videoInstruction)
            lastAsset = videoAsset
        }
        
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: completeTrackDuration)
        mainInstruction.layerInstructions = layerInstructionsArray
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: videoSize.width, height: videoSize.height)
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: NSDate() as Date)
        let savePath = (documentDirectory as NSString).appendingPathComponent("mergeVideo-\(date).mov")
        let url = NSURL(fileURLWithPath: savePath)
        
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter!.outputURL = url as URL
        exporter!.outputFileType = AVFileType.mov
        exporter!.shouldOptimizeForNetworkUse = true
        exporter!.videoComposition = mainComposition
        exporter!.exportAsynchronously {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exporter!.outputURL!)
            }) { saved, error in
                if saved {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Your video was successfully saved", message: "") {
                        }
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", message: "\(String(describing: error.localizedDescription))") {
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension InitialViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.mediaURL] as? URL {
            assets.append(AVAsset(url: url))
            tableView.reloadData()
        } else {
            showAlert(title: "URL Error", message: "URL is nil", handler: {})
        }
        picker.dismiss(animated: true)
    }
}


// MARK: - UINavigationControllerDelegate

extension InitialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "videocell", for: indexPath) as? VideoTableViewCell {
            let asset = assets[indexPath.row]
            asset.generateThumbnail { image in
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
            cell.titleLabel.text = "Video# \(indexPath.row + 1)"
            cell.subtitleLabel.text = "\(asset)"
            return cell
        }
        return UITableViewCell()
    }
    
}
