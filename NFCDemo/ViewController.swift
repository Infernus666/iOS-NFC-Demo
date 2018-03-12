//
//  ViewController.swift
//  NFCDemo
//
//  Created by Achin Kumar on 09/02/18.
//  Copyright © 2018 vinsol. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    @IBOutlet weak var logText: UITextView!
    var nfcSession: NFCNDEFReaderSession?
    var isSessionActive = false
    var isReadCycleActive = false
    var cachedInitialRead: Int? = nil
    
    var hasAutoInvalidated = false
    
    let font = UIFont(name: "Courier", size: 12)!
    let boldFont = UIFont(name: "Courier-Bold", size: 12)!
    let boldSmallFont = UIFont(name: "Courier-Bold", size: 11)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logText.allowsEditingTextAttributes = true
    }
    
    @IBAction func scanTapped(_ sender: UIButton) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcSession?.alertMessage = "Hold your NFC-tag to the back-top of your iPhone"
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        cachedInitialRead = nil
        
        if !hasAutoInvalidated {
            isSessionActive = false
            print("The session was invalidated: \(error.localizedDescription)")
            updateLog(withTerminationReason: error.localizedDescription)
        } else { hasAutoInvalidated = false }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if !isSessionActive {
            clearLog()
            isSessionActive = true
        }
        
        for payload in messages[0].records {
            let chars = Array(payload.payload).map({ (i) -> String in
                return String(format:"%02hhx", i)
            })
            
            var strInitial = ""
            var strCont = ""
            var strInit = ""
            var strCycle = ""
//            chars.forEach { str += "\($0) " }
            
            for i in 0..<chars.count {
                if i < 6 {
                    strInitial += "\(chars[i]) "
                } else if i < 8 {
                    strCont += "\(chars[i]) "
                } else if i < 10 {
                    strInit += "\(chars[i]) "
                } else {
                    strCycle += "\(chars[i]) "
                }
            }
            
//            updateLog(withFirst6: strInitial, continuous: strCont, initial: strInit, cycle: strCycle)
            
            updateLog(forChars: chars)
            
            print(chars)
        }
        
        session.invalidate()
        hasAutoInvalidated = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
            self.nfcSession?.alertMessage = "Hold your NFC-tag to the back-top of your iPhone"
            self.nfcSession?.begin()
            self.isReadCycleActive = true
        }
        
        
//        if !isReadCycleActive {
        
//        } else {
//            isReadCycleActive = false
//        }
        
//        session.begin()
    }
    
    
    
    
    
    private func updateLog(forChars chars: [String]) {
        let initialRead = hexToDecimal(hex: "\(chars[9])\(chars[8])")
        let finalRead = hexToDecimal(hex: "\(chars[7])\(chars[6])")
        let disChargeCount = hexToDecimal(hex: "\(chars[11])\(chars[10])")
        
        if cachedInitialRead == nil { cachedInitialRead = initialRead }
        
        let initialReadPercent = (Float(initialRead) / Float(cachedInitialRead!)) * 100.0
        let finalReadPercent = (Float(finalRead) / Float(cachedInitialRead!)) * 100.0
        
        let timeStamp = Date().HHMMssSS
        
        let grey = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: font] as [NSAttributedStringKey : Any]
        let purple = [NSAttributedStringKey.foregroundColor: UIColor.purple, NSAttributedStringKey.font: boldFont] as [NSAttributedStringKey : Any]
        let blue = [NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.font: boldFont] as [NSAttributedStringKey : Any]
        let black = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: boldFont] as [NSAttributedStringKey : Any]
        
        let attr1 = NSAttributedString(string: timeStamp + "> ", attributes: grey)
        let attr2 = NSAttributedString(string: "i:\(String(format: "% 6.2f", initialReadPercent))%; ", attributes: purple)
        let attr3 = NSAttributedString(string: "f:\(String(format: "% 6.2f", finalReadPercent))%; ", attributes: blue)
        let attr4 = NSAttributedString(string: "dc:\(disChargeCount)", attributes: black)
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attr1)
        mutableAttributedString.append(attr3)
        mutableAttributedString.append(attr2)
        mutableAttributedString.append(attr4)
        
//        let line = "\(timeStamp), latest:\(finalReadPercent)%, first: \(initialReadPercent)%, discharge cycles: \(disChargeCount)"
        
        updateLog(withLine: mutableAttributedString)
    }
    
    private func hexToDecimal(hex: String) -> Int {
        return Int(hex, radix: 16)!
    }
    
    private func updateLog(withFirst6 first6: String, continuous cont: String, initial ini: String, cycle cyc: String) {
        let grey = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: font] as [NSAttributedStringKey : Any]
        let purple = [NSAttributedStringKey.foregroundColor: UIColor.purple, NSAttributedStringKey.font: boldFont] as [NSAttributedStringKey : Any]
        let blue = [NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.font: boldFont] as [NSAttributedStringKey : Any]
        
        let attr1 = NSAttributedString(string: first6, attributes: grey)
        let attr2 = NSAttributedString(string: cont, attributes: purple)
        let attr3 = NSAttributedString(string: ini, attributes: blue)
        let attr4 = NSAttributedString(string: cyc, attributes: [NSAttributedStringKey.font: font])

        let mutableAttributedString = NSMutableAttributedString(attributedString: attr1)
        mutableAttributedString.append(attr2)
        mutableAttributedString.append(attr3)
        mutableAttributedString.append(attr4)
        
        updateLog(withLine: mutableAttributedString)
    }
    
    private func updateLog(withTerminationReason reason: String) {
        let grey = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: font] as [NSAttributedStringKey : Any]
        let attr1 = NSAttributedString(string: "---------------------------------------------\n", attributes: grey)
        let attr2 = NSAttributedString(string: reason, attributes: [NSAttributedStringKey.font: boldSmallFont])
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attr1)
        mutableAttributedString.append(attr2)
        
        updateLog(withLine: mutableAttributedString)
    }
    
    private func clearLog() {
        DispatchQueue.main.async() {
            self.logText.text = " "
            self.logText.attributedText = NSMutableAttributedString(string: " ")
//            let bottom = NSMakeRange(self.logText.text.count - 1, 1)
//            self.logText.scrollRangeToVisible(bottom)
        }
    }
    
    private func updateLog(withLine line: NSAttributedString) {
        DispatchQueue.main.async() {
            if self.logText.attributedText!.string == " " { self.logText.attributedText = NSMutableAttributedString(string: "") }
            let mutableAttributedString = NSMutableAttributedString(attributedString: self.logText.attributedText!)
            mutableAttributedString.append(NSAttributedString(string: self.logText.text! == "" ? "" : "\n"))
            mutableAttributedString.append(line)
            self.logText.attributedText = mutableAttributedString
//            let bottom = NSMakeRange(self.logText.attributedText.string.count - 1, 1)
//            self.logText.scrollRangeToVisible(bottom)
        }
    }
}




























