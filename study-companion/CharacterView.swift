//
//  CharacterView.swift
//  study-companion
//
//  Created by Jay Castro on 9/14/25.
//

import SwiftUI

struct CharacterView: View {
    @State private var isShowingTaskInput = false
    
    var body: some View {
        ZStack {
            // Main view: Character + Dialogue Box (always visible)
            if !isShowingTaskInput {
                HStack(spacing: 15) {
                    // Character placeholder - you'll replace this with your PNG
                    CharacterPlaceholder()
                    
                    // Dialogue box (always shown next to character)
                    DialogueBox(onAddTasks: {
                        showTaskInput()
                    })
                    
                    Spacer()
                }
                .transition(.opacity)
            }
            
            // Task input overlay (when "Add Tasks" is clicked)
            if isShowingTaskInput {
                TaskInputView(isShowing: $isShowingTaskInput)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .animation(.easeInOut(duration: 0.3), value: isShowingTaskInput)
    }
    
    private func showTaskInput() {
        isShowingTaskInput = true
    }
}

struct CharacterPlaceholder: View {
    var body: some View {
        // Placeholder rectangle - this is where your character PNG will go
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 100)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack {
                Image(systemName: "face.smiling")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Text("Your Character Here")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        // Subtle breathing animation
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: UUID())
    }
}

struct DialogueBox: View {
    let onAddTasks: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Speech bubble tail (pointing to character)
            HStack {
                Triangle()
                    .fill(Color(NSColor.controlBackgroundColor))
                    .frame(width: 20, height: 15)
                    .rotationEffect(.degrees(-90))
                    .offset(x: -10, y: 0)
                Spacer()
            }
            .offset(y: 5)
            
            // Main dialogue content
            VStack(alignment: .leading, spacing: 8) {
                Text("📚 Study Math - Due in 2 hours!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    DialogueButton(title: "✅ Did it", color: .green) {
                        // Handle task completion
                        print("Task completed!")
                    }
                    
                    DialogueButton(title: "⏰ Later", color: .orange) {
                        // Handle postpone
                        print("Task postponed!")
                    }
                    
                    DialogueButton(title: "➕ Add Tasks", color: .blue) {
                        onAddTasks()
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 3)
            )
        }
        .frame(maxWidth: 280)
    }
}

// Custom triangle shape for speech bubble tail
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct DialogueButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: UUID())
    }
}

struct TaskInputView: View {
    @Binding var isShowing: Bool
    @State private var taskText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Add New Task")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("×") {
                    closeInput()
                }
                .font(.title2)
                .foregroundColor(.secondary)
                .buttonStyle(PlainButtonStyle())
            }
            
            TextField("What do you need to do?", text: $taskText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 14))
                .focused($isTextFieldFocused)
                .onSubmit {
                    addTask()
                }
            
            HStack(spacing: 8) {
                Button("Add Task") {
                    addTask()
                }
                .buttonStyle(.borderedProminent)
                .font(.system(size: 12))
                .keyboardShortcut(.return, modifiers: [])
                
                Button("Cancel") {
                    closeInput()
                }
                .buttonStyle(.bordered)
                .font(.system(size: 12))
                .keyboardShortcut(.escape, modifiers: [])
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 5)
        )
        .frame(width: 320)
        .onAppear {
            // Auto-focus the text field when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }
    
    private func addTask() {
        if !taskText.isEmpty {
            // TODO: Add task to storage
            print("Adding task: \(taskText)")
            taskText = ""
            closeInput()
        }
    }
    
    private func closeInput() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isShowing = false
        }
    }
}

#Preview {
    CharacterView()
        .frame(width: 600, height: 200)
        .background(Color.gray.opacity(0.1))
}
