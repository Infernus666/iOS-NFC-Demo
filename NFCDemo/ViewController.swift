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
    
    var nfcSession: NFCNDEFReaderSession?

    @IBAction func scanTapped(_ sender: UIButton) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcSession?.alertMessage = "Hold your NFC-tag to the back-top of your iPhone"
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for payload in messages[0].records {
            let chars = Array(payload.payload).map({ (i) -> String in
                return String(format:"%02hhx", i)
            })
            
            print(chars)
        }
        
        session.invalidate()
    }
}

