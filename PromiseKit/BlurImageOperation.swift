//
//  BlurImageOperation.swift
//  PromiseKit
//
//  Created by Nikolai Krusser on 10.02.2022.
//

import UIKit

class BlurImageOperation: Operation {
    
    // Исходное изображение
        var inputImage: UIImage
    // Размытое изображение
        var outputImage: UIImage?
    
    // Логика нашей операции
        override func main() {
    // Размываем изображение
            let inputCIImage = CIImage(image: inputImage)!
            let filter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
            let outputCIImage = filter.outputImage!
            let context = CIContext()
            
            let cgiImage = context.createCGImage(outputCIImage, from: outputCIImage.extent)

    // Кладем размытое изображение в свойство
            outputImage = UIImage(cgImage: cgiImage!)
        }
    
    // Конструктор для создания операции с изображением
        init(inputImage: UIImage) {
            self.inputImage = inputImage
            super.init()
        }
}
