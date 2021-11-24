/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The complication controller class for the complication.
*/

import ClockKit

// The complication simply supports the Modular Large (tall body) family and
// shows a random number for the current timeline entry.
// You can make the complication current by following these steps:
// 1. Choose a Modular watch face on your watch.
// 2. Deep press to get to the customization screen, tap the Customize button,
//    then swipe right to get to the complications configuration screen and tap the tall body area.
// 3. Rotate the digital crown to choose the SimpleWatchConnectivity complication.
// 4. Press the digital crown and tap the screen to go back to the watch face.
//
class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration.
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication,
                                          withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population.
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Only support .modularLarge currently.
        guard complication.family == .modularLarge else { handler(nil); return }
        
        // Display a random number string on the body.
        let tallBody = CLKComplicationTemplateModularLargeTallBody()
        tallBody.headerTextProvider = CLKSimpleTextProvider(text: "SimpleWC")
        tallBody.bodyTextProvider = CLKSimpleTextProvider(text: "\(arc4random_uniform(400))")
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
        
        // Pass the entry to ClockKit.
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date.
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date.
        handler(nil)
    }
    
    // MARK: - Placeholder Templates.
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached.
        handler(nil)
    }
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // Only support .modularLarge currently.
        guard complication.family == .modularLarge else { handler(nil); return }
        
        // Display a random number string on the body.
        let tallBody = CLKComplicationTemplateModularLargeTallBody()
        tallBody.headerTextProvider = CLKSimpleTextProvider(text: "SimpleWC")
        tallBody.bodyTextProvider = CLKSimpleTextProvider(text: "Random")
        
        // Pass the template to ClockKit.
        handler(tallBody)
    }
}
