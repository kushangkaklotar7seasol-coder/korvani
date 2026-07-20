//
//  PuzzlePiece.swift
//  MovieFlex
//
//  Created by Himanshu Parmar on 26/05/26.
//


import SwiftUI
internal import Combine

// MARK: - Model
struct PuzzlePiece: Identifiable, Equatable {
    
    let id = UUID()
    let image: UIImage
    let correctIndex: Int
}

// MARK: - ViewModel
final class PuzzleViewModel: ObservableObject {
    
    @Published var pieces: [PuzzlePiece] = []
    @Published var showSuccess = false
    @Published var completedPuzzle:Double = 0
    @Published var correctCount = 0
    let originalImage: UIImage
    
    init(image: UIImage) {
        self.originalImage = Self.cropToSquare(image)
        setupPuzzle()
    }
    
    // MARK: - Create Puzzle
    func setupPuzzle() {
        
        let slicedImages = sliceImageIntoGrid(image: originalImage)
        
        pieces = slicedImages.enumerated().map {
            PuzzlePiece(image: $0.element, correctIndex: $0.offset)
        }
        
        pieces.shuffle()
    }
    
    // MARK: - Slice Image
    func sliceImageIntoGrid(image: UIImage) -> [UIImage] {
        
        guard let cgImage = image.cgImage else { return [] }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let pieceWidth = width / 3
        let pieceHeight = height / 3
        
        var images: [UIImage] = []
        
        for row in 0..<3 {
            for col in 0..<3 {
                
                let rect = CGRect(
                    x: col * pieceWidth,
                    y: row * pieceHeight,
                    width: pieceWidth,
                    height: pieceHeight
                )
                
                if let cropped = cgImage.cropping(to: rect) {
                    
                    let img = UIImage(
                        cgImage: cropped,
                        scale: image.scale,
                        orientation: image.imageOrientation
                    )
                    
                    images.append(img)
                }
            }
        }
        
        return images
    }
    
    private static func cropToSquare(_ image: UIImage) -> UIImage {

        guard let cgImage = image.cgImage else {
            return image
        }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        let side = min(width, height)

        let x = (width - side) / 2
        let y = (height - side) / 2

        let rect = CGRect(
            x: x,
            y: y,
            width: side,
            height: side
        )

        guard let cropped = cgImage.cropping(to: rect) else {
            return image
        }

        return UIImage(
            cgImage: cropped,
            scale: image.scale,
            orientation: image.imageOrientation
        )
    }
    
    // MARK: - Move
    func movePiece(from source: Int, to destination: Int) {
        guard source != destination else { return }
        pieces.swapAt(source, destination)  // Only index 1 and 5 swap, rest stay untouched
        self.checkPuzzleSolved()
    }
    
    // MARK: - Check Puzzle
    func checkPuzzleSolved() {
        
        for (index, piece) in pieces.enumerated() {
            
            self.completedPuzzle = Double(puzzleProgressPercent())
            print("Puzzle solved: \(self.completedPuzzle)%")
            
            if piece.correctIndex != index {
                print(index)
                return
            }
        }
        completedPuzzle = 0
        correctCount = 0
        showSuccess = true
    }
    
    func puzzleProgressPercent() -> Int {
        guard !pieces.isEmpty else { return 0 }
        
        self.correctCount = pieces.enumerated().reduce(0) { count, element in
            let (index, piece) = element
            return piece.correctIndex == index ? count + 1 : count
        }
        
        return Int((Double(correctCount) / Double(pieces.count)) * 100)
    }
}
