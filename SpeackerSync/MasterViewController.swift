//
//  MasterViewController.swift
//  SpeackerSync
//
//  Created by Alex on 17/10/15.
//  Copyright © 2015 Alex Steiner. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    //MARK: Actions
    @IBAction func sync(sender: AnyObject) {
        if !isPlaying {
            sync()
            syncStatusChanged()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var syncButton: UIButton!
    
    
    //MARK: Attributes
    let wrapper = WaveToneGeneratorWrapper()
    var playNumber = 0
    var timer:NSTimer?
    var isPlaying = false
    
    
    //MARK: Main
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PlayerManager.sharedPlayerManager.stop()
    }
    
    //MARK: Sync Button
    func syncStatusChanged() {
        isPlaying = !isPlaying
        syncButton.enabled = isPlaying
    }
    
    //MARK: Done Sync
    func syncDone() {
        guard let path = NSBundle.mainBundle().pathForResource("simple-drum-beat", ofType: "mp3") else { return }
        let url = NSURL(fileURLWithPath: path)
        PlayerManager.sharedPlayerManager.play(url)
        syncStatusChanged()
    }
    
    //MARK: Sync
    func sync() {
        isPlaying = true
        playSound()
        timer = NSTimer.scheduledTimerWithTimeInterval(SSKToneLength + 1.5, target: self, selector: "playSound", userInfo: nil, repeats: true)
    }
    
    func playSound() {
        wrapper.playFrequency(SSKFrequency, onChannel: 0, forDuration: SSKToneLength)
        playNumber++
        if let timer = timer where playNumber > 2 {
            timer.invalidate()
            
            playNumber = 0
            
            NSTimer.scheduledTimerWithTimeInterval(SSKToneLength, target: self, selector: "syncDone", userInfo: nil, repeats: false)
        }
    }

}
