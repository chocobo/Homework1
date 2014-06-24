//
//  TimelineViewController.m
//  facebookDemo
//
//  Created by Natalia Fisher on 6/22/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "TimelineViewController.h"
#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"


@interface TimelineViewController () <TTTAttributedLabelDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIImageView *movieStillView;
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *link;
@property (weak, nonatomic) IBOutlet UIView *commentBar;

// Declare some methods that will be called when the keyboard is about to be shown or hidden
- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;


@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Register the methods for the keyboard hide/show events
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

// Attempt to get link to work..
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[TTTAttributedLabel class]])
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // whiteView styling
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.layer.cornerRadius = 2;
    self.whiteView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.whiteView.layer.shadowOffset = CGSizeMake(0,0);
    self.whiteView.layer.shadowOpacity = 0.1;
    self.whiteView.layer.shadowRadius = 2;
    
    // actionBar styling
    self.actionBar.layer.borderColor = [UIColor colorWithRed:(221.0 / 255.0) green:(221.0 / 255.0) blue:(221.0 / 255.0) alpha:(0.5)].CGColor;
    self.actionBar.layer.borderWidth = 1;
    
    // commentBar styling
    self.commentBar.layer.borderWidth = 1;
    self.commentBar.layer.borderColor = [UIColor colorWithRed:(221.0 / 255.0) green:(221.0 / 255.0) blue:(221.0 / 255.0) alpha:(0.8)].CGColor;;

    
    // TTTAttributeLabel to make link
    self.link.textColor = [UIColor darkGrayColor];
    self.link.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.link.delegate = self;
    self.link.text = @"http://bit.ly/1jV9zM8";

    //Facebook link color rgb(109, 132, 180);
    
    // Set link color and gt rid of underline
    NSDictionary *attributes = @{ (__bridge NSString *)kCTForegroundColorAttributeName : [UIColor colorWithRed:(109.0 / 255.0) green:(132.0 / 255.0) blue:(180.0 / 255.0) alpha:(1)],
                                  (__bridge NSString *)kCTUnderlineStyleAttributeName : @(kCTUnderlineStyleNone)};
    self.link.linkAttributes = attributes;

    

}


- (void)willShowKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.commentBar.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - self.commentBar.frame.size.height, self.commentBar.frame.size.width, self.commentBar.frame.size.height);
                     }
                     completion:nil];
}

- (void)willHideKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.commentBar.frame = CGRectMake(0, self.view.frame.size.height - (self.commentBar.frame.size.height + 45), self.commentBar.frame.size.width, self.commentBar.frame.size.height);
                     }
                     completion:nil];
}


// Needed to open link in Safari
- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
