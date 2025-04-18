//
//  LocalizedKey.swift
//  ALLEX
//
//  Created by youngkyun park on 3/29/25.
//

import Foundation


enum LocalizedKey: String {
    
    // 설정관련
    case Setting_ProfileTitle = "Setting_ProfileTitle"
    case Setting_Nickname_Title = "Setting_Nickname_Title"
    case Setting_Verified_NickName = "Setting_Verified_NickName"
    case Setting_UnVerified_NickName = "Setting_UnVerified_NickName"
    case Setting_Start_Date = "Setting_Start_Date"

    
    //버튼 관련
    case Button_Start_Login = "Button_Start_Login"
    case Button_Save_Record = "Button_Save_Record"
    
    
    case recordButton = "Record_Button" // 나중에 지울 것
    
    
    case userId = "User_ID"
    case greeting = "Greeting"
        
    
    //PlaceHolder
    case PlaceHolder_SearchBar = "PlaceHolder_SearchBar"
    
    // 안내 관련
    case Info_SwipeGesture = "Info_SwipeGesture"
    case Info_ExerciseTime = "Info_ExerciseTime"
    case Info_Route = "Info_Route"
    case Info_Statistics = "Info_Statistics"
    
    case Info_Write_Record = "Info_Write_Record" // 카메라 버튼 클릭시 나오는 팝업뷰
    case Info_Write_RecordSub = "Info_Write_RecordSub"
    case Info_Video_Record = "Info_Video_Record"
    case Info_Video_RecordSub = "Info_Video_RecordSub"
    

    case Info_Gym_Title = "Info_Gym_Title"
    case Info_Recent_Gym_History = "Info_Recent_Gym_History"
    case Info_Recent_Gym_Label = "Info_Recent_Gym_Label"
    
    
    // 시설 정보 관려
    case Gym_Info_facility = "Gym_Info_facility"
    case Gym_Info_Grade = "Gym_Info_Grade"
    case Gym_Info_request_modify = "Gym_Info_request_modify"
    
    
    // 기록 관련
    case Record_Grade = "Record_Grade"
    case Record_Try = "Record_Try"
    case Record_Success = "Record_Success"
    case Record_HighestGrade = "Record_HighestGrade"
    case Record_Send = "Record_Send"
}



