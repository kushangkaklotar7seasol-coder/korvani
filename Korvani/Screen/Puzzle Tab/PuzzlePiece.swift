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
    var originalImage: UIImage?
    var puzzleItem: Puzzle?
    
    init() {
        self.startPuzzle()
    }
    
    func startPuzzle(){
        self.puzzleItem = UserdefaultManager.shared.getPuzzle().filter({$0.isUsed == false}).first
        
        if self.puzzleItem == nil {
            var puzzle = UserdefaultManager.shared.getPuzzle()
            
            puzzle = puzzle.map({ item in
                return Puzzle(id: item.id, name: item.name, isUsed: true)
            })
            
            UserdefaultManager.shared.savePuzzle(puzzle)
            
            self.puzzleItem = UserdefaultManager.shared.getPuzzle().filter({$0.isUsed == false}).first
        }
        
        self.originalImage = Self.cropToSquare(UIImage(named: puzzleItem?.name ?? "puzzle_1") ?? UIImage())
        setupPuzzle()
    }
    
    func setSuccessPuzzle() {
        completedPuzzle = 0
        correctCount = 0
        
        var puzzle = UserdefaultManager.shared.getPuzzle()
        
        puzzle = puzzle.map({ item in
            if item.id == self.puzzleItem?.id {
                return Puzzle(id: item.id, name: item.name, isUsed: true)
            }
            return item
        })
        
        UserdefaultManager.shared.savePuzzle(puzzle)
        
        self.startPuzzle()
    }
    
    // MARK: - Create Puzzle
    func setupPuzzle() {
        guard let image = originalImage else { return }
        let slicedImages = sliceImageIntoGrid(image: image)
        
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
