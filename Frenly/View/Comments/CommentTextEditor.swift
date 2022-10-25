//
//  CommentTextEditor.swift
//  Frenly
//
//  Created by Владислав on 24.10.2022.
//

import SwiftUI

struct CommentTextEditor: View {
    @Binding var text: String
    @Binding var textEditorHeight : CGFloat
    
    var focusedField: FocusState<Int?>.Binding
    
    var onChangeAction: () -> Void = {}
    var onSubmitAction: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Placeholder
            if (text == "") {
                Text("Comment")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .padding(12)
                    .foregroundColor(Color.commentInputForeground)
            }
            
            Text(text)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.clear)
                .background(GeometryReader {
                    Color.clear.preference(
                        key: ViewHeightKey.self,
                        value: $0.frame(in: .local).size.height
                    )
                })
            
            TextEditor(text: $text)
                .focused(focusedField, equals: 1)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .frame(maxHeight: max(40, textEditorHeight - 10))
                .padding(9)
                .background(Color.commentInputBackground)
                .cornerRadius(30)
                .onChange(of: text) { newValue in
                    onChangeAction()
                }
                .onChange(of: focusedField.wrappedValue) { newValue in
                    if (newValue == nil) {
                        onSubmitAction()
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: textEditorHeight)
        }
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.8,
            height: focusedField.wrappedValue != nil ? textEditorHeight + 35 : 50
        )
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        let next = value + nextValue()
        
        if (next >= 120) {
            value = 120
        } else {
            value = next
        }
    }
}

struct CommentTextEditor_Previews: PreviewProvider {
    @State static var text: String = ""
    @State static var editorHeight: CGFloat = 20
    
    @FocusState static var commentsFocus: Int?
    
    static var previews: some View {
        CommentTextEditor(
            text: $text,
            textEditorHeight: $editorHeight,
            focusedField: $commentsFocus
        )
    }
}
