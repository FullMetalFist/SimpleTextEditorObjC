//
//  Document.m
//  SimpleTextEditor
//
//  Created by Michael Vilabrera on 2/14/17.
//  Copyright © 2017 Michael Vilabrera. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        _text = [[NSTextStorage alloc] initWithString:@""];
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController {
    [super windowControllerDidLoadNib:windowController];
    
    // replace the NSTextView's text storage
    [self.textView.layoutManager replaceTextStorage:self.text];
}

// boilerplate
+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // convert NSTextStorage to a plain NSString
    NSString *plainText = [self.text string];
    
    // convert NSTextStorage to NSData
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    // return the data (NSDocument does the writing for us)
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // convert the NSData to an NSAttributedString
    NSString *plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // replace the contents of NSTextStorage
    NSRange range = NSMakeRange(0, [self.text length]);
    [self.text replaceCharactersInRange:range withString:plainText];
    
    // return YES for success or NO if an error occurred
    return YES;
}


@end
