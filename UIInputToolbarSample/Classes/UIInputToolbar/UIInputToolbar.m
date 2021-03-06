/*
 *  UIInputToolbar.m
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

#import "UIInputToolbar.h"

NSString * const CHExpandingTextViewWillChangeHeightNotification = @"CHExpandingTextViewWillChangeHeight";

@interface UIInputToolbar () {
    UIColor *characterCountIsValidTextColor;
    UIColor *characterCountIsValidShadowColor;
    UIColor *characterCountIsNotValidTextColor;
    UIColor *characterCountIsNotValidShadowColor;
}

@property (nonatomic, retain) UIButton *innerBarButton;

@end


@implementation UIInputToolbar

@synthesize textView = textView;
@synthesize characterLimit;
@synthesize inputButton = inputButton;
@synthesize inputButtonShouldDisableForNoText;
@synthesize inputDelegate = inputDelegate;
@synthesize backgroundImage;
@synthesize inputButtonImage = _inputButtonImage;
@synthesize innerBarButton;
@synthesize characterCountLabel = characterCountLabel;

-(void)inputButtonPressed
{
    if ([inputDelegate respondsToSelector:@selector(inputButtonPressed:)]) 
    {
        [inputDelegate inputButtonPressed:self.textView.text];
    }
    
    /* Remove the keyboard */
    [self.textView resignFirstResponder];
}

-(void)setupToolbar:(NSString *)buttonLabel
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.tintColor = [UIColor lightGrayColor];
    
    /* Create custom send button*/
    UIImage *stretchableButtonImage = [self.inputButtonImage stretchableImageWithLeftCapWidth:floorf(self.inputButtonImage.size.width/2) topCapHeight:floorf(self.inputButtonImage.size.height/2)];
    
    UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    button.contentMode             = UIViewContentModeScaleToFill;
    
    [button setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    [button setTitle:buttonLabel forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
    [button sizeToFit];
    
    self.innerBarButton = button;
    
    self.inputButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.inputButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.inputButton.enabled = NO;
    self.inputButtonShouldDisableForNoText = YES;
    
    /* Create UIExpandingTextView input */
    self.textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(7, 7, 236, 26)];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    /* Right align the toolbar button */
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    /* Add the character count label */
    if ([UIInputToolbar isIOS7AndUp]) {
        characterCountIsValidTextColor = [UIColor blackColor];
    } else {
        characterCountIsValidTextColor = [UIColor whiteColor];
    }
    characterCountIsValidShadowColor = [UIColor darkGrayColor];
    characterCountIsNotValidTextColor = [UIColor redColor];
    characterCountIsNotValidShadowColor = [UIColor clearColor];
    
    characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(253, -5, 50, 40)];
    characterCountLabel.textAlignment = UITextAlignmentCenter;
    characterCountLabel.font = [UIFont boldSystemFontOfSize:12];
    characterCountLabel.textColor = characterCountIsValidTextColor;
    characterCountLabel.shadowColor = characterCountIsValidShadowColor;
    characterCountLabel.shadowOffset = CGSizeMake(0, -1);
    characterCountLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:characterCountLabel];
    
    NSArray *items = [NSArray arrayWithObjects: flexItem, self.inputButton, nil];
    [self setItems:items animated:NO];
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setInputButtonImage:[UIImage imageNamed:@"buttonbg.png"]];

        [self setupBackgroundImage];

        [self setupToolbar:@"Send"];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar:@"Send"];
    }
    return self;
}

- (void)setupBackgroundImage {
    UIImage * toolbarBackgroundImage = [UIImage imageNamed:@"toolbarbg"];
    CGFloat imageWidth = toolbarBackgroundImage.size.width;
    CGFloat imageHeight = toolbarBackgroundImage.size.height;
    UIEdgeInsets insetsForResize = UIEdgeInsetsMake(imageHeight/2, imageWidth/2, imageHeight/2, imageWidth/2);
    toolbarBackgroundImage = [toolbarBackgroundImage resizableImageWithCapInsets:insetsForResize];
    [self setBackgroundImage:toolbarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.textView.frame;
    frame.size.height = self.frame.size.height - 7;
    self.textView.frame = frame;

    frame = self.inputButton.customView.frame;
    frame.origin.y = self.frame.size.height - frame.size.height - 7;
    self.inputButton.customView.frame = frame;
}

- (void)dealloc
{
    [textView release];
    [inputButton release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
	
	NSDictionary *aUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:height],CH_TEXTVIEW_HEIGHT_KEY, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:CHExpandingTextViewWillChangeHeightNotification object:nil userInfo:(NSDictionary *)aUserInfo];
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    if (self.inputButtonShouldDisableForNoText) {
        if ([expandingTextView.text length] > 0) {
            self.inputButton.enabled = YES;
        } else {
            self.inputButton.enabled = NO;
        }
    }
    
    /* Show/Hide the character count and update its text */
    if (characterLimit > 0) {
        if (self.frame.size.height > 40) {
            characterCountLabel.hidden = NO;
        } else {
            characterCountLabel.hidden = YES;
        }
        
        characterCountLabel.text = [NSString stringWithFormat:@"%i/%i",expandingTextView.text.length,characterLimit];
        
        if (expandingTextView.text.length > characterLimit) {
            characterCountLabel.textColor = characterCountIsNotValidTextColor;
            characterCountLabel.shadowColor = characterCountIsNotValidShadowColor;
            inputButton.enabled = NO;
        } else if (expandingTextView.text.length > 0) {
            characterCountLabel.textColor = characterCountIsValidTextColor;
            characterCountLabel.shadowColor = characterCountIsValidShadowColor;
            inputButton.enabled = YES;
        }
    }
}

-(void)setInputButtonImage:(UIImage *)inputButtonImage {
    if (![_inputButtonImage isEqual:inputButtonImage]) {
        [_inputButtonImage release];
        _inputButtonImage = [inputButtonImage retain];
        
        if (self.innerBarButton) {
            UIImage *stretchableButtonImage = [_inputButtonImage stretchableImageWithLeftCapWidth:floorf(_inputButtonImage.size.width/2) topCapHeight:floorf(_inputButtonImage.size.height/2)];
            [self.innerBarButton setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
        }
    }
}

- (void)clearText {
    [self.textView clearText];
}

#pragma mark -- for iOS7
+ (BOOL)isIOS7AndUp {
    return (floor(NSFoundationVersionNumber) > 993.00);
}

@end
