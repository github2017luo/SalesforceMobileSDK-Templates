/*
  QuoteLineItemStore.swift
  Consumer

  Created by Nicholas McDonald on 2/22/18.

 Copyright (c) 2018-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Foundation
import SalesforceSwiftSDK
import SmartStore
import SmartSync
import PromiseKit

public class QuoteLineItemStore: Store<QuoteLineItem> {
    public static let instance = QuoteLineItemStore()
    
    public override func records() -> [QuoteLineItem] {
        let query: SFQuerySpec = SFQuerySpec.newAllQuerySpec(QuoteLineItem.objectName, withOrderPath: QuoteLineItem.orderPath, with: .descending, withPageSize: 100)
        var error: NSError? = nil
        let results: [Any] = store.query(with: query, pageIndex: 0, error: &error)
        guard error == nil else {
            SalesforceSwiftLogger.log(type(of:self), level:.error, message:"fetch \(QuoteLineItem.objectName) failed: \(error!.localizedDescription)")
            return []
        }
        return QuoteLineItem.from(results)
    }
    
    public func lineItemsForGroup(_ lineGroupId:String) -> [QuoteLineItem] {
        let query = SFQuerySpec.newExactQuerySpec(QuoteLineItem.objectName, withPath: QuoteLineItem.Field.group.rawValue, withMatchKey: lineGroupId, withOrderPath: QuoteLineItem.Field.lineNumber.rawValue, with: .ascending, withPageSize: 100)
        var error: NSError? = nil
        let results: [Any] = store.query(with: query, pageIndex: 0, error: &error)
        guard error == nil else {
            SalesforceSwiftLogger.log(type(of:self), level:.error, message:"fetch \(QuoteLineItem.objectName) failed: \(error!.localizedDescription)")
            return []
        }
        return QuoteLineItem.from(results)
    }
    
    public func create(_ lineItem:QuoteLineItem) -> Promise<QuoteLineItem> {
        return self.createEntry(entry: lineItem)
    }
}