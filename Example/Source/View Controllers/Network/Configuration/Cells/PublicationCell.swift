/*
* Copyright (c) 2019, Nordic Semiconductor
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification,
* are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice, this
*    list of conditions and the following disclaimer in the documentation and/or
*    other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors may
*    be used to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
* IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
* NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import NordicMesh

class PublicationCell: UITableViewCell {

    @IBOutlet weak var destinationIcon: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationSubtitleLabel: UILabel!
    @IBOutlet weak var destinationAddress: UILabel!
    @IBOutlet weak var keyIcon: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var boundKeyLabel: UILabel!
    
    var publish: Publish! {
        didSet {
            let meshNetwork = MeshNetworkManager.instance.meshNetwork!
            let address = publish.publicationAddress
            destinationAddress.text = "0x\(address.address.hex)"
            if address.address.isUnicast {
                let meshNetwork = MeshNetworkManager.instance.meshNetwork!
                let node = meshNetwork.node(withAddress: address.address)
                if let element = node?.element(withAddress: address.address) {
                    if let name = element.name {
                        destinationLabel.text = name
                        destinationSubtitleLabel.text = node?.name ?? "Unknown Device"
                    } else {
                        let index = node!.elements.firstIndex(of: element)!
                        let name = "Element \(index + 1)"
                        destinationLabel.text = name
                        destinationSubtitleLabel.text = node?.name ?? "Unknown Device"
                    }
                } else {
                    destinationLabel.text = "Unknown Element"
                    destinationSubtitleLabel.text = "Unknown Device"
                }
                destinationIcon.tintColor = .nordicLake
                destinationIcon.image = #imageLiteral(resourceName: "ic_flag_24pt")
            } else if address.address.isGroup || address.address.isVirtual {
                if let group = meshNetwork.group(withAddress: address) ?? Group.specialGroup(withAddress: address) {
                    destinationLabel.text = group.name
                    destinationSubtitleLabel.text = nil
                } else {
                    destinationLabel.text = "Unknown group"
                    destinationSubtitleLabel.text = address.asString()
                }
                destinationIcon.image = #imageLiteral(resourceName: "tab_groups_outline_black_24pt")
                destinationIcon.tintColor = .nordicLake
            } else {
                destinationLabel.text = "Invalid address"
                destinationSubtitleLabel.text = nil
                destinationIcon.tintColor = .nordicRed
                destinationIcon.image = #imageLiteral(resourceName: "ic_flag_24pt")
            }
            
            if let applicationKey = meshNetwork.applicationKeys[publish.index] {
                keyIcon.tintColor = .nordicLake
                keyLabel.text = applicationKey.name
                boundKeyLabel.text = "Bound to \(applicationKey.boundNetworkKey.name)"
            } else {
                keyIcon.tintColor = .lightGray
                keyLabel.text = "No Key Selected"
                boundKeyLabel.text = nil
            }
        }
    }
}
