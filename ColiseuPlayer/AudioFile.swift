//
// AudioFile.swift
// Coliseu
//
// Copyright (c) 2019 Ricardo Pereira (https://ricardopereira.eu)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import AVFoundation
import MediaPlayer

public class AudioFile {

    public let title: String
    public let fileName: String
    public var fileSize: Int = 0
    public var length: Float = 0.0
    public var duration: TimeInterval = 0
    public var path: URL?
    public var artwork: UIImage?
    public var index: Int = 0

    required public init(_ title: String, _ fileName: String) {
        self.title = title
        self.fileName = fileName
    }

    convenience public init(url: URL) {
        let fileAsset = AVURLAsset(url: url, options: nil)
        var title: String = "Song"
        var audioArtwork: UIImage?

        for metadataFormat in fileAsset.availableMetadataFormats {
            let metadataList = fileAsset.metadata(forFormat: metadataFormat)
            for metadataItem in metadataList {
                if metadataItem.commonKey == nil {
                    continue
                }
                let commonKey = metadataItem.commonKey?.rawValue

                // if commonKey == nil {
                //     continue
                // }

                switch commonKey {
                case "artwork"?:
                    if let value = metadataItem.value as? Data, let audioImage = UIImage(data: value) {
                        audioArtwork = audioImage
                        print(audioImage.description)
                    }

                case "title"?:
                    // It's working
                    if let value = metadataItem.value as? String {
                        title = value
                    }

                default:
                    title = "Song"
                }
            }
        }

        self.init(title, url.lastPathComponent)

        self.path = url
        if let artwork = audioArtwork {
            self.artwork = artwork
        }
    }
}
