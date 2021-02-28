//
//  EditProjectView.swift
//  WeldLearn
//
//  Created by JWSScott777 on 1/9/21.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

    }
    var body: some View {
        Form {
            // sec 1
            Section(header: Text("Basic settings")) {
                /* Original code
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
 */
                TextField("Project name", text: $title)
                TextField("Description of this project", text: $detail)
            }
            // sec 2
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            // sec 3
            Section(footer: Text("Closing a project moves it from the Open to Closed tab")) {
                Button(project.closed ? "Reopen project?" : "Close the project") {
                    project.closed.toggle()
                    update()
                }
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: update)
        /* Add this back when code bug gets fixed
        .onDisappear(perform: dataController.save)
 */
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text(
                    "Delete project?"), message: Text(
                        "Are you sure?"), primaryButton: .default(Text(
                        "Delete"), action: delete), secondaryButton: .cancel())
        }
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        // new addition to be removed after it works
        dataController.save()
        //
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }

        .onTapGesture {
            color = item
            /*
            update()
 */
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
/* The problem seem to be with update(). I found a work-a-round for time being is to

 remove .onChange(update) from both TextFields
 remove update() from .onTapGesture in colorButton
 add dataController.save() to func update()
 change .onDisappear to .onDisappear(perform: update)
*/
