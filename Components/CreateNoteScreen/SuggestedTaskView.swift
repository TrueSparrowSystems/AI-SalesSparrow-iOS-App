//
//  SuggestedTaskView.swift
//  SalesSparrow
//
//  Created by Kartik Kapgate on 23/08/23.
//

import SwiftUI

struct SuggestedTaskCardView: View {
    var accountId: String
    var suggestion: SuggestionStruct
    var index: Int
    
    @EnvironmentObject var createNoteScreenViewModel : CreateNoteScreenViewModel
    @EnvironmentObject var createTaskViewModel : CreateTaskViewModel
    @State var recommendedText: String
    @State var selectedDate: Date = Date.now
    @State var assignedToUsername: String = ""
    @State var selectedUserId: String = ""
    @State var isTaskSaved = false
    @State var showEditTaskView = false
    @State private var isDateSelected = false
    @State private var showUserSearchView: Bool = false
    @FocusState private var focusedRecommendedText: Bool
    @FocusState private var userSelected: Bool
    
    init(accountId: String, suggestion: SuggestionStruct,index: Int) {
        self.accountId = accountId
        self.suggestion = suggestion
        _recommendedText = State(initialValue: suggestion.description)
        self.index = index
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format of your due_date
        if let date = dateFormatter.date(from: suggestion.due_date) {
            _selectedDate = State(initialValue: date)
        } else {
            _selectedDate = State(initialValue: Date()) // Default value if conversion fails
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                // text editor component
                HStack{
                    Text("\(recommendedText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("TextPrimary"))
                        .font(.custom("Nunito-SemiBold", size: 16))
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("et_create_note")
                        .onTapGesture {
                            // Do nothing. Kept on tap here to override tap action over parent tap action
                            showEditTaskView = true
                        }
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                        .background(Color("GhostWhite").opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black.opacity(0.1), lineWidth: 1))
                }
                
                
                // assign to component + picker
                HStack{
                    HStack {
                        Text("Assign to")
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                        
                        Button(action: {
                            // Toggle user search view
                            showUserSearchView = true
                        }){
                            if(assignedToUsername.isEmpty){
                                Text("Select")
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                    .tracking(0.5)
                                
                                Image("ArrowDown")
                                    .frame(width: 6, height: 3)
                                    .padding(.trailing, 6)
                            } else {
                                Text(BasicHelper.getInitials(from: assignedToUsername))
                                    .frame(width: 18, height: 18)
                                    .font(.custom("Nunito-Bold", size: 6))
                                    .foregroundColor(Color.white)
                                    .background(Color("UserBubble"))
                                    .clipShape(RoundedRectangle(cornerRadius: 47))
                                    .accessibilityIdentifier("img_user_account_detail_user_initials")
                                
                                Text(assignedToUsername)
                                    .foregroundColor(Color("RedHighlight"))
                                    .font(.custom("Nunito-Bold", size: 12))
                                    .accessibilityIdentifier("txt_add_task_selected_user")
                                    .tracking(0.5)
                                
                                Image("ArrowDown")
                                    .frame(width: 6, height: 3)
                                    .padding(.trailing, 6)
                            }
                            
                        }
                        .sheet(isPresented: $showUserSearchView){
                            UserSearchView(isPresented: $showUserSearchView,
                                           onUserSelect: { userId, userName in
                                assignedToUsername = userName
                                selectedUserId = userId
                            })
                        }
                        .accessibilityIdentifier("btn_create_note_search_user")
                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    
                    Spacer()
                }
                
                // due date component + picker
                HStack{
                    HStack {
                        Text("Due")
                            .foregroundColor(Color("TextPrimary"))
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .tracking(0.5)
                        
                        // add verticle divider gray line
                        VerticalDividerRectangleView(width: 1, color: Color("BorderColor"))
                        
                        
                        ZStack{
                            DatePickerView(selectedDate: $selectedDate, onTap: {
                                isDateSelected = true
                            })
                            
                            if(!isDateSelected){
                                HStack (spacing: 0) {
                                    Text("Select Date")
                                        .foregroundColor(Color("TermsPrimary"))
                                        .font(.custom("Nunito-Light", size: 12))
                                        .tracking(0.5)
                                        .padding(0)
                                    
                                    Image("EmptyCalendar")
                                        .frame(width: 15, height: 15)
                                        .padding(0)
                                }
                                .padding(EdgeInsets(top: 10, leading: 28, bottom: 10, trailing: 28))
                                .background(Color("Background"))
                                .userInteractionDisabled()
                            }
                        }
                    }
                    .frame(width: 180)
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("BorderColor"), lineWidth: 1))
                    Spacer()
                }
                
                // action buttons + view model
                if(!isTaskSaved){
                    HStack{
                        Button(action: {
                            createTaskViewModel.createTask(accountId: accountId, assignedToName: assignedToUsername, crmOrganizationUserId: selectedUserId, description: recommendedText, dueDate: selectedDate)
                            // TODO: call create task view model
                        }, label:{
                            HStack(alignment: .center, spacing: 0){
                                if(createTaskViewModel.isCreateTaskInProgress){
                                    ProgressView()
                                        .tint(Color("LoginButtonPrimary"))
                                        .controlSize(.small)
                                    Text("Adding Task...")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Medium", size: 12))
                                        .accessibilityIdentifier("txt_create_note_adding_task")
                                    
                                } else{
                                    Text("Add Task")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Medium", size: 12))
                                        .accessibilityIdentifier("txt_create_note_add_task")
                                }
                            }
                            .frame(width: createTaskViewModel.isCreateTaskInProgress ? 115 : 72, height: 32)
                            .background(
                                Color(hex: "SaveButtonBackground")
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .disabled(disableSaveButton() || createTaskViewModel.isCreateTaskInProgress)
                        .accessibilityIdentifier("btn_create_note_add_task")
                        
                        Button(action: {
                            createNoteScreenViewModel.removeSuggestion(at: index)
                        }, label:{
                            HStack(alignment: .center, spacing: 0){
                                Text("Cancel")
                                    .foregroundColor(Color("CancelText"))
                                    .font(.custom("Nunito-Medium", size: 12))
                                    .accessibilityIdentifier("txt_create_note_cancel")
                            }
                            .frame(width: 72, height: 32)
                            .background(Color("Background"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .accessibilityIdentifier("btn_create_note_cancel")
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "#5D678D"), lineWidth: 1))
                        
                        Spacer()
                    }
                    .padding(.top, 16)
                }
            }
            .onAppear {
                // TODO: Remove this as after success of save note API, this must be triggered internally
            }
            .padding()
            // Add dotted border
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [1,5])) // Specify the dash pattern here
                    .foregroundColor(Color("TextPrimary"))
            )
            .background(
                NavigationLink(
                    destination: CreateTaskScreen(isPresented: $showEditTaskView,
                                                  accountId: accountId,
                                                  description: $recommendedText,
                                                  dueDate: $selectedDate,
                                                  crmOrganizationUserId: $selectedUserId)
                    .navigationBarBackButtonHidden(true),
                    isActive: self.$showEditTaskView
                ) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
    
    private func disableSaveButton() -> Bool {
        return accountId.isEmpty || recommendedText.isEmpty || selectedUserId.isEmpty || isDateSelected
       }
}

struct NoHitTesting: ViewModifier {
    func body(content: Content) -> some View {
        SwiftUIWrapper { content }.allowsHitTesting(false)
    }
}

extension View {
    func userInteractionDisabled() -> some View {
        self.modifier(NoHitTesting())
    }
}

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
