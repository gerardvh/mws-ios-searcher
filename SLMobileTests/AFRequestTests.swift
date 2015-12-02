import Quick
import Nimble
@testable import SLMobile

class AFRequestTests: QuickSpec {
    override func spec() {
        describe("Request Controller") {
            let rc = AFRequestController()
            it("Gets a success response for existing computers") {
                rc.searchFor("6553", completionHandler: { (slItems) -> Void in
                    expect(slItems[0]).toEventuallyNot(beNil(), timeout: 4, pollInterval: 0.5, description: "Could not find asset tag like '6553'")
                })
            }
            
            it("Doesn't get a good response for nonexistant computers") {
                rc.searchFor("a;lsdfkaj", completionHandler: { (slItems) -> Void in
                    expect(slItems[0]).toEventually(beNil(), timeout: 4, pollInterval: 0.5, description: "Found a tag where none was expected.")
                })
            }
        }
    }
}
