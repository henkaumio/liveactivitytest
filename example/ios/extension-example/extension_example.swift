//
//  extension_example.swift
//  extension-example
//
//  Created by Dimitri Dessus on 28/09/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI



@main
struct Widgets: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      FootballMatchApp()
    }
  }
}

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState
  
  public struct ContentState: Codable, Hashable { }
  
  var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.dimitridessus.liveactivities")!

@available(iOSApplicationExtension 16.1, *)
struct FootballMatchApp: Widget {

  

  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
        
    let momentName = sharedDefault.string(forKey: context.attributes.prefixedKey("momentName"))!
    // let momentImage = sharedDefault.string(forKey: context.attributes.prefixedKey("momentImage"))!
    let paused = sharedDefault.bool(forKey: context.attributes.prefixedKey("paused"))
    let sleepStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("sleepStartDate")) / 1000)
    let suggestedSleepEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("suggestedSleepEndDate")) / 1000)
  
    let now = Date()
    let remainingTime = suggestedSleepEndDate.timeIntervalSince(now)
    let remainingSeconds = max(Int(remainingTime), 0) // Ensure it doesn't go negative
        
    VStack {
   // if let uiImageMoment = UIImage(contentsOfFile: momentImage)
     //         {
      //          Image(uiImage: uiImageMoment)
        //          .resizable()
          //        .frame(width: 80, height: 80)
            //      .offset(y:0)
              //}
      Text("\(momentName)")
      Text("\(String(remainingSeconds))s until wakeup is due")
    if #available(iOS 17.0, *) {
                    HStack(alignment: .top) {
                        if(paused) {
                            Button(intent: PlayIntent()) {
                               Image(systemName: "play.fill")
                            }
                        }  else {Button(intent: PauseIntent()) {
                            Image(systemName: "pause.fill")
                        }}
                    }
                    .tint(.white)
                    .padding()
                }
 
       
              
       
    }
    .activityBackgroundTint(Color.indigo)
    .activitySystemActionForegroundColor(Color.black)

    } dynamicIsland: { context in 
    DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Text("leading")
        }
          DynamicIslandExpandedRegion(.trailing) {
          Text("trailing")
        }
          DynamicIslandExpandedRegion(.bottom) {
          Text("bottom")
        }
         DynamicIslandExpandedRegion(.center) {
          Text("center")
        }
    } compactLeading: {
      Text("L")
    } compactTrailing: {
      Text("T")
    } minimal: {
      Text("M")
    }
    .keylineTint(Color.red)
    }
  }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}



