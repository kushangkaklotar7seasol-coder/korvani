//
//  PuzzleView.swift
//  MovieFlex
//
//  Created by Himanshu Parmar on 26/05/26.
//

import SwiftUI
internal import UniformTypeIdentifiers

// MARK: - View
struct PuzzleView: View {
    
    @StateObject var viewModel: PuzzleViewModel
    @State private var draggedItem: PuzzlePiece?
    @State private var showInstructionsSheet = false
    @State private var showOriginalPosterSheet = false
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    
    var body: some View {
        
        var size: CGFloat {
            return screenWidth-32
        }
        
        ZStack{
            
            VStack {
                DefaultDesign.Header(name: "Puzzle", secondIcon: "ic_info_dark", isShowSecondbutton: true, isShowBackButton: false, secondButton: {
                    self.showInstructionsSheet = true
                })
                
                VStack(spacing: 5) {
                    HStack {
                        let persentage = "\(viewModel.completedPuzzle)".prefix(2)
                        Text("\(persentage)% Complete")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.grayColour)
                        
                        Spacer()
                        
                        Text("\(viewModel.correctCount)/9 Pieces")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.lightYellowColour)
                    }
                    
                    Slider(value: $viewModel.completedPuzzle, in: 1...100)
                        .tint(.orangeColour)
                        .allowsHitTesting(false)
                }
                .padding(.top, 10)
                
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
                .frame(width: size, height: size)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
                
                // MARK: - Description
                
                Button {
                    showOriginalPosterSheet = true
                } label: {
                    HStack {
                        Image(uiImage: viewModel.originalImage)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading) {
                            Text("Original Poster")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.whiteColour)
                            
                            Text("Tap to reveal the complete image")
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
                    .padding(.top, 24)
                }
                                
                VStack {
                    Spacer()
                    
                    Text("Every piece brings you closer to the complete movie poster. Keep solving to reveal the final image.")
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grayColour)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .background(.blackColour)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showInstructionsSheet) {
            PuzzleInstructionsSheet(isPresented: $showInstructionsSheet)
        }
        .sheet(isPresented: $showOriginalPosterSheet) {
            OriginalPosterSheet(isPresented: $showOriginalPosterSheet, originalImage: viewModel.originalImage)
        }
        .alert("Congratulations 🎉", isPresented: $viewModel.showSuccess) {
            Button("OK") {
                viewModel.setupPuzzle()
            }
        }
        .onAppear() {
            UISlider.appearance().setThumbImage(UIImage(), for: .normal)
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
                    Text("Puzzle Instructions")
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
                    CelebrityDetails.PersonalInfo(name: "Long press a piece to select it", details: "", isLast: false)
                    CelebrityDetails.PersonalInfo(name: "Drag & drop it in the correct place", details: "", isLast: false)
                    CelebrityDetails.PersonalInfo(name: "Repeat until the poster is complete", details: "", isLast: true)
                }
            }
        }
        .presentationDetents([.height(180)])
        .presentationDragIndicator(.hidden)
        .presentationBackground(.sheetBackgroundColour)
    }
}

// MARK: - Puzzle Instructions Sheet
struct OriginalPosterSheet: View {
    @Binding var isPresented: Bool
    let originalImage: UIImage
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Original Poster")
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
                .frame(width: screenWidth-32, height: screenWidth-32)
                .background(.whiteColour)
                
                Spacer()
            }
        }
        .presentationDetents([.height((screenWidth-32)+100)])
        .presentationDragIndicator(.hidden)
        .presentationBackground(.sheetBackgroundColour)
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
    PuzzleView(
        viewModel: PuzzleViewModel(
            image: UIImage(named: "img_puzzle_poster")!
        )
    )
}
