//
//  PuzzlePiece.swift
//  MovieFlex
//
//  Created by Himanshu Parmar on 26/05/26.
//

import SwiftUI
import UniformTypeIdentifiers
import Combine

// MARK: - View
struct PuzzleView: View {
    
    @StateObject var viewModel = PuzzleViewModel()
    @State private var showInstructionsSheet = false
    @State private var showOriginalPosterSheet = false
    @EnvironmentObject var localization: LocalizationManager
    @State private var refreshID = UUID()
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 8) {
                // Header
                DefaultDesign.Header(
                    name: Strings.puzzle,
                    secondIcon: "ic_info_dark",
                    isShowSecondbutton: true,
                    isShowBackButton: false,
                    secondButton: {
                        self.showInstructionsSheet = true
                    }
                )
                .padding(.horizontal, 16)
                
                if Device.isiPadLandscape {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(spacing: 16) {
                            PuzzleDesign.PuzzlecollevtionView(viewModel: viewModel)
                                .id(refreshID)
                            
                            VStack {
                                PuzzleDesign.PuzzleProgressBar(viewModel: viewModel)
                                    .padding(.horizontal, 16)
                                    .id(refreshID)
                                
                                if isShowAdd() {
                                    NativeAd6()
                                }

                                ZStack {
                                    Image(uiImage: viewModel.originalImage ?? UIImage())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: (screenWidth-400)/2, height: (screenWidth-400)/2, alignment: .center)
                                }
                                .background(.whiteColour)
                                .cornerRadius(10)
                                .id(refreshID)
                                
                                PuzzleDesign.PuzzleSheetNote()
                                    .padding(.horizontal, 16)
                                    .id(refreshID)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                    }
                } else {
                    PuzzleDesign.PuzzleProgressBar(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .id(refreshID)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            if isShowAdd() {
                                NativeAd6()
                            }
                            
                            PuzzleDesign.PuzzlecollevtionView(viewModel: viewModel)
                                .id(refreshID)
                            
                            PuzzleDesign.FullPosterButton(viewModel: viewModel, showOriginalPosterSheet: $showOriginalPosterSheet)
                                .id(refreshID)
                            
                            PuzzleDesign.PuzzleSheetNote()
                                .padding(.horizontal, 16)
                                .id(refreshID)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .background(.blackColour)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .id(localization.selectedLanguage)
        .sheet(isPresented: $showInstructionsSheet) {
            PuzzleInstructionsSheet(isPresented: $showInstructionsSheet)
        }
        .sheet(isPresented: $showOriginalPosterSheet) {
            OriginalPosterSheet(
                isPresented: $showOriginalPosterSheet,
                originalImage: viewModel.originalImage ?? UIImage()
            )
        }
        .alert("\(Strings.congratulation) 🎉", isPresented: $viewModel.showSuccess) {
            Button(Strings.ok) {
                viewModel.setSuccessPuzzle()
            }
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = false
            UISlider.appearance().setThumbImage(UIImage(), for: .normal)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
}



class PuzzleDesign {
    struct PuzzleProgressBar: View {
        @StateObject var viewModel: PuzzleViewModel
        
        var body: some View {
            VStack(spacing: 5) {
                HStack {
                    let persentage = "\(viewModel.completedPuzzle)".prefix(2)
                    Text("\(persentage)% \(Strings.completed)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.grayColour)
                    
                    Spacer()
                    
                    Text("\(viewModel.correctCount)/9 \(Strings.pieces)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.lightYellowColour)
                }
                
                Slider(value: $viewModel.completedPuzzle, in: 1...100)
                    .tint(.orangeColour)
                    .allowsHitTesting(false)
            }
            .padding(.top, 5)
        }
    }
    
    struct PuzzlecollevtionView: View {
        let columns = [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
        @StateObject var viewModel: PuzzleViewModel
        @State private var draggedItem: PuzzlePiece?
//        let puzzleSize: CGFloat = Device.isIpad ? (Device.isiPadLandscape ? screenHeight-32 : screenWidth-32) : screenWidth-32
        
        var puzzleSize: CGFloat {
            if Device.isiPadLandscape {
                return (screenWidth-200)/2
            } else {
                if Device.isIpad {
                    return screenWidth-132
                } else {
                    return screenWidth-32
                }
            }
        }
        
        var body: some View {
            // MARK: - Puzzle Grid
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.pieces) { piece in
                    GeometryReader { geo in
                        Image(uiImage: piece.image)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.width
                            )
                            .clipped()
                            .onDrag {
                                self.draggedItem = piece
                                return NSItemProvider()
                            }
                            .onDrop(
                                of: [.text],
                                delegate: PuzzleDropDelegate(
                                    item: piece,
                                    pieces: $viewModel.pieces,
                                    draggedItem: $draggedItem,
                                    onMove: { from, to in
                                        viewModel.movePiece(from: from, to: to)
                                    }
                                )
                            )
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .frame(width: puzzleSize, height: puzzleSize)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    struct FullPosterButton: View {
        @StateObject var viewModel: PuzzleViewModel
        @State private var draggedItem: PuzzlePiece?
        let puzzleSize: CGFloat = Device.isIpad ? (Device.isiPadLandscape ? (screenWidth-100)/2 : screenWidth-32) : screenWidth-32
        @Binding var showOriginalPosterSheet: Bool
        
        var body: some View {
            Button {
                showOriginalPosterSheet = true
            } label: {
                if let image = viewModel.originalImage {
                    HStack {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading) {
                            Text(Strings.originalPoster)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.whiteColour)
                            
                            Text(Strings.originalPosterTagline)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.grayColour)
                        }
                        
                        Spacer()
                        
                        Image("ic_eye")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    .background(.borderColour)
                    .cornerRadius(14)
                }
            }
            .frame(maxWidth: puzzleSize)

        }
    }
    
    struct PuzzleSheetNote: View {
        var body: some View {
            // Footer Note
            Text(Strings.puzzleNotes)
                .font(.system(size: Device.isIpad ? 18 : 12, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.grayColour)
                .padding(.top, 8)
                .padding(.bottom, 20)
        }
    }
}

// MARK: - Puzzle Instructions Sheet
struct PuzzleInstructionsSheet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text(Strings.puzzleInstraction)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image("ic_cancel_bg")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .padding(.top, 10)
                
                // MARK: - Instructions
                VStack(spacing: 16) {
                    CelebrityDetails.PersonalInfo(name: Strings.puzzleNote1, details: "", isLast: false)
                    CelebrityDetails.PersonalInfo(name: Strings.puzzleNote2, details: "", isLast: false)
                    CelebrityDetails.PersonalInfo(name: Strings.puzzleNote3, details: "", isLast: true)
                }
            }
        }
        .presentationDetents([.height(180)])
        .presentationDragIndicator(.hidden)
        .presentationBackground(.sheetBackgroundColour)
    }
}

// MARK: - Original Poster Sheet
struct OriginalPosterSheet: View {
    @Binding var isPresented: Bool
    let originalImage: UIImage
    
    var body: some View {
            
        let posterSize: CGFloat = Device.isIpad ? (Device.isiPadLandscape ? (screenWidth-100)/2 : screenWidth-32) : screenWidth-32
            
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Text(Strings.originalPoster)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { isPresented = false }) {
                            Image("ic_cancel_bg")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 35, height: 35)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .padding(.top, 10)
                    
                    ZStack {
                        Image(uiImage: originalImage)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: posterSize, height: posterSize)
                    .background(.whiteColour)
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
            .padding()
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .presentationBackground(.sheetBackgroundColour)
//        }
    }
}

// MARK: - Individual Instruction Item
struct InstructionItem: View {
    let icon: String
    let title: String
    let number: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.9, green: 0.3, blue: 0.6),
                            Color(red: 0.8, green: 0.2, blue: 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
            
            // Instruction Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Gilroy-Medium", size: 15))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Icon
            Image(systemName: icon)
                .font(.custom("Gilroy-Medium", size: 16))
                .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.6))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Drop Delegate
struct PuzzleDropDelegate: DropDelegate {
    
    let item: PuzzlePiece
    
    @Binding var pieces: [PuzzlePiece]
    @Binding var draggedItem: PuzzlePiece?
    
    var onMove: (Int, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        
        guard
            let draggedItem,
            draggedItem != item,
            let from = pieces.firstIndex(of: draggedItem),
            let to = pieces.firstIndex(of: item)
        else {
            return
        }
        
        withAnimation(.smooth) {
            onMove(from, to)
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}

#Preview {
    PuzzleView(viewModel: PuzzleViewModel())
}

// MARK: - Model & ViewModel Implementation
struct PuzzlePiece: Identifiable, Equatable {
    let id = UUID()
    let image: UIImage
    let correctIndex: Int
}

final class PuzzleViewModel: ObservableObject {
    
    @Published var pieces: [PuzzlePiece] = []
    @Published var showSuccess = false
    @Published var completedPuzzle: Double = 0
    @Published var correctCount = 0
    var originalImage: UIImage?
    var puzzleItem: Puzzle?
    
    init() {
        self.startPuzzle()
    }
    
    func startPuzzle()  {
        self.puzzleItem = UserdefaultManager.shared.getPuzzle().filter({ $0.isUsed == false }).first
        
        if self.puzzleItem == nil {
            var puzzle = UserdefaultManager.shared.getPuzzle()
            
            puzzle = puzzle.map({ item in
                return Puzzle(id: item.id, name: item.name, isUsed: true)
            })
            
            UserdefaultManager.shared.savePuzzle(puzzle)
            
            self.puzzleItem = UserdefaultManager.shared.getPuzzle().filter({ $0.isUsed == false }).first
        }
        
//        self.originalImage = Self.cropToSquare(UIImage(named: puzzleItem?.name ?? "puzzle_1") ?? UIImage())
        Task {
             await self.loadImage(from: "https://raw.githubusercontent.com/kushangkaklotar7seasol-coder/korvani/refs/heads/main/Images/puzzle_1.png")
            setupPuzzle()
        }
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
        pieces.swapAt(source, destination)
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
    
    func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            await MainActor.run {
                self.originalImage = Self.cropToSquare(UIImage(named: self.puzzleItem?.name ?? "puzzle_1") ?? UIImage())
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
            
            await MainActor.run {
                self.originalImage = Self.cropToSquare(image)
            }
        } catch {
            print("Failed to load image: \(error.localizedDescription)")
            self.originalImage = Self.cropToSquare(UIImage(named: self.puzzleItem?.name ?? "puzzle_1") ?? UIImage())
        }
    }
}
