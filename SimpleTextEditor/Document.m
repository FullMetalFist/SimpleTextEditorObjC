//
//  Document.m
//  SimpleTextEditor
//
//  Created by Michael Vilabrera on 2/14/17.
//  Copyright © 2017 Michael Vilabrera. All rights reserved.
//

#import "Document.h"
#import "PlainTextWindowController.h"

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

- (instancetype)initWithType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self = [super initWithType:typeName error:outError];
    if (self) {
        // add some default text for new documents
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"Hello, World!"];
        [self.text appendAttributedString:attributedText];
    }
    return self;
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    [savePanel setExtensionHidden:NO];
    [savePanel setCanSelectHiddenExtension:NO];
    [savePanel setMessage:@"Select a destination for your text file"];
    return YES;
}

- (void)makeWindowControllers {
    PlainTextWindowController *windowController = [[PlainTextWindowController alloc] init];
    [self addWindowController:windowController];
}

// boilerplate
+ (BOOL)autosavesInPlace {
    return NO;
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // convert NSTextStorage to NSData (conversion depends on document type)
    NSData *data = nil;
    if ([typeName isEqualToString:@"public.plaintext"]) {
        NSLog(@"Writing Plaintext");
        data = [[self.text string] dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([typeName isEqualToString:@"public.rtf"]) {
        NSLog(@"Writing RTF");
        NSRange range = NSMakeRange(0, [[self.text string] length]);
        NSDictionary *attributes = @{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType};
        data = [self.text RTFFromRange:range documentAttributes:attributes];
    }
    
    // return the data (NSDocument does the writing)
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    // convert the NSData to an NSAttributedString
    NSAttributedString *attributedText;
    if ([typeName isEqualToString:@"public.plaintext"]) {
        NSLog(@"reading plaintext");
        NSString *plaintext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        attributedText = [[NSAttributedString alloc] initWithString:plaintext];
    } else if ([typeName isEqualToString:@"public.rtf"]) {
        NSLog(@"reading rtf");
        attributedText = [[NSAttributedString alloc] initWithRTF:data documentAttributes:NULL];
    } else {
        // got an unidentified type
        return NO;
    }
    
    // replace the text storage contents
    [self.text setAttributedString:attributedText];
    
    // return yes for success or NO if an error occurred
    return YES;
}

@end
