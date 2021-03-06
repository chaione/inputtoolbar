/*
 *  UIInputToolbar.h
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "UIExpandingTextView.h"

#define	CH_TEXTVIEW_HEIGHT_KEY @"height"

extern NSString * const CHExpandingTextViewWillChangeHeightNotification;


@protocol UIInputToolbarDelegate <NSObject>
@optional
-(void)inputButtonPressed:(NSString *)inputText;
@end

@interface UIInputToolbar : UIToolbar <UIExpandingTextViewDelegate> 
{
    UIExpandingTextView *textView;
    UIBarButtonItem *inputButton;
    UILabel *characterCountLabel;
    id <UIInputToolbarDelegate> inputDelegate;
}

@property (nonatomic, retain) UIExpandingTextView *textView;
@property (nonatomic) NSInteger characterLimit;
@property (nonatomic, retain) UILabel *characterCountLabel;
@property (nonatomic, retain) UIBarButtonItem *inputButton;
@property (nonatomic) BOOL inputButtonShouldDisableForNoText;
@property (nonatomic, assign) id<UIInputToolbarDelegate> inputDelegate;

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIImage *inputButtonImage;

+ (BOOL)isIOS7AndUp;

- (void)clearText;

@end
