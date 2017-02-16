//
//  Document.h
//  SimpleTextEditor
//
//  Created by Michael Vilabrera on 2/14/17.
//  Copyright © 2017 Michael Vilabrera. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument

@property (nonatomic, readonly) NSTextStorage *text;

@end

