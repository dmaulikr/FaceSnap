//
//  FilteredImageBuilder.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/7/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

// Class will take input image, apply filter, and output a second image.
// final classes cannot be subclassed or overridden

final class FilteredImageBuilder {
    
    private struct PhotoFilter {
        
        // Name of Filters
        
        static let ColorClamp = "CIColorClamp"
        static let ColorControls = "CIColorControls"
        static let PhotoEffectInstant = "CIPhotoEffectInstant"
        static let PhotoEffectProcess = "CIPhotoEffectProcess"
        static let PhotoEffectNoir = "CIPhotoEffectNoir"
        static let Sepia = "CISepiaTone"
        
        static func defaultFilters() -> [CIFilter] {
            
            // Color Clamp
            
            let colorClamp = CIFilter(name: PhotoFilter.ColorClamp)!
            
            //Set color range for filter
            
            colorClamp.setValue(CIVector(x:0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
            colorClamp.setValue(CIVector(x:0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
            
            // Color Controls
            
            let colorControls = CIFilter(name: PhotoFilter.ColorControls)!
            colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
            
            // Photo Effects
            
            let photoEffectInstant = CIFilter(name: PhotoFilter.PhotoEffectInstant)!
            let photoEffectProcess = CIFilter(name: PhotoFilter.PhotoEffectProcess)!
            let photoEffectNoir = CIFilter(name: PhotoFilter.PhotoEffectNoir)!
            
            // Sepia Tone
            
            let sepia = CIFilter(name: PhotoFilter.Sepia)!
            sepia.setValue(0.7, forKey: kCIInputIntensityKey)
            
            return [colorClamp, colorControls, photoEffectInstant, photoEffectProcess, photoEffectNoir, sepia]
            
        }
    }
    
    private let image: UIImage
    
    // Add context to app, so that images process better and use less memory 
    
    private let context: CIContext
    
    init(context: CIContext, image: UIImage) {
        self.context = context
        self.image = image
    }
    
    // A helper method that takes the default filters we created above and returns an array of images that uses those default filters applied. 
    
    func imageWithDefaultFilters() -> [CIImage] {
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    // Method that takes an array of filters and returns an array of UIImage. 
    
    func image(withFilters filters: [CIFilter]) -> [CIImage] {
        return filters.map { image(self.image, withFilter: $0) }
    }
    
    // Method takes image and returns image with filter applied. 
    
    func image(image: UIImage, withFilter filter: CIFilter) -> CIImage {
        
        //Image parameter
        
        let inputImage = image.CIImage ?? CIImage(image: image)!
        
        // Filter parameter 
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        let outputImage = filter.outputImage!
        
        // Return output image and make sure that it has the same bounds as the input image.
        
        return outputImage.imageByCroppingToRect(inputImage.extent)
    }
}

