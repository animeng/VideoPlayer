//
//  JMDetailViewController.m
//  FootBallVedio
//
//  Created by wang animeng on 13-4-17.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HPGrowingTextView.h"
#import "iFlyMSC/IFlyRecognizeControl.h"
#import "JMBasicAction.h"
#import "MBProgressHUD.h"

#define LabelTagOffset 1000
#define MaxLabelNum 20

@interface JMDetailViewController () <HPGrowingTextViewDelegate,IFlyRecognizeControlDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) MPMoviePlayerController * player;

@property (strong, nonatomic) UIView *containerView;
@property (nonatomic, strong) HPGrowingTextView *textView;

@property (nonatomic,strong) IFlyRecognizeControl *audioRecognizeCtr;
@property (nonatomic,strong) UIButton *iFlyAudioBtn;

@property (nonatomic,strong) JMBasicAction *postAction;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSString *previousText;
@property (nonatomic,strong) UIImageView *backgroundView;
@end

@implementation JMDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
    [self updateView];
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

#pragma mark - setup view

- (void)configurePlayerView
{
    self.player = [[MPMoviePlayerController alloc] init];
    self.player.view.frame = self.view.bounds;
    self.player.view.height = self.player.view.height - 40;
    self.player.movieSourceType = MPMovieSourceTypeStreaming;
    [self.view addSubview:self.player.view];
    [self registorNotification];
    
    self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 728, 664)];
    self.backgroundView.image = [UIImage imageNamed:@"video_background"];
    [self.player.view addSubview:self.backgroundView];
}

- (void)configureTextView
{
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 40, self.view.width, 40)];
    
	self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.width-140, 40)];
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
	self.textView.returnKeyType = UIReturnKeySend;
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, self.view.width - 132, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:self.textView];
    [self.containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(self.containerView.frame.size.width - 64, 8, 60, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[self.containerView addSubview:doneBtn];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.containerView];
}

- (void)configureAudioView
{
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIButton *audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	audioBtn.frame = CGRectMake(self.containerView.frame.size.width - 129, 8, 60, 27);
    audioBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[audioBtn setTitle:@"语音" forState:UIControlStateNormal];
    
    [audioBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    audioBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    audioBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [audioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[audioBtn addTarget:self action:@selector(showAudioCtr) forControlEvents:UIControlEventTouchUpInside];
    [audioBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [audioBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[self.containerView addSubview:audioBtn];
    self.iFlyAudioBtn = audioBtn;
    [self initAudioCtr];
}

- (void)initAudioCtr
{
    NSString *initParam=[[NSString alloc] initWithFormat:@"server_url=%@,appid=%@",IFLY_ENGINE_URL,IFLY_APPID];
    CGPoint origin = self.player.view.center;
    self.audioRecognizeCtr=[[IFlyRecognizeControl alloc] initWithOrigin:origin initParam:initParam];
    [self.view addSubview:self.audioRecognizeCtr];
    [self.audioRecognizeCtr setEngine:@"sms" engineParam:nil grammarID:nil];
    [self.audioRecognizeCtr setSampleRate:16000];
    self.audioRecognizeCtr.delegate = self;
    self.audioRecognizeCtr.alpha = 0;
}

- (void)updateView
{
    NSDictionary *dic = (NSDictionary*)_detailItem;
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"url"]];
    self.player.contentURL = url;
    [self.player prepareToPlay];
    [self.player play];
    self.backgroundView.hidden = NO;
    [MBProgressHUD showHUDAddedTo:self.backgroundView animated:YES];
}

#pragma mark - control lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
        self.postAction = [[JMBasicAction alloc] init];
        self.postAction.basicPath = @"LiveVideo/message";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configurePlayerView];
    [self configureTextView];
    [self configureAudioView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self unRegistorNotification];
}

#pragma mark - notification

- (void)registorNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    if (IOSVersion >=6.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDisplayChangeCallBack:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:self.player];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateChangeCallBack:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidExitFullScreenCallBack:) name:MPMoviePlayerDidExitFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviedidEnterFullScreenCallBack:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
}

- (void)unRegistorNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:self.player];
    if (IOSVersion>=6.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerReadyForDisplayDidChangeNotification object:self.player];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)movieDidExitFullScreenCallBack:(NSNotification*)aNotification
{
    MPMoviePlayerController *player = [aNotification object];
    
    NSLog(@"%d",player.playbackState);
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(getCommentText)userInfo:nil
                                                 repeats:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.player.view.frame = self.view.bounds;
        self.player.view.height = self.player.view.height - 40;
    }];

}

- (void)movieLoadStateChangeCallBack:(NSNotification*)aNotification
{
    MPMoviePlayerController *player = [aNotification object];
    [MBProgressHUD hideAllHUDsForView:self.backgroundView animated:YES];
    if (player.playbackState == MPMoviePlaybackStatePlaying) {
        self.backgroundView.hidden = YES;

        [self removeDriftLabel];
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                             target:self
                                           selector:@selector(getCommentText)userInfo:nil
                                            repeats:YES];
    }else if(player.playbackState == MPMoviePlaybackStateInterrupted){
        self.backgroundView.hidden = NO;
        [MBProgressHUD showHUDAddedTo:self.backgroundView animated:YES];
        [self.player play];
    }else{
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)movieDisplayChangeCallBack:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.player.view.frame = self.view.bounds;
        self.player.view.height = self.player.view.height - 40;
    }];
}

- (void)moviedidEnterFullScreenCallBack:(NSNotification*)aNotification
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)movieFinishedCallBack:(NSNotification*)aNotification
{
    MPMoviePlayerController *player = [aNotification object];
    [player stop];
}

-(void) keyboardWillShow:(NSNotification *)note{
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	self.containerView.frame = containerFrame;

	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	self.containerView.frame = containerFrame;
	
	[UIView commitAnimations];
}

#pragma mark - rotation 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.player.view.frame = self.view.bounds;
        self.player.view.height = self.player.view.height - 40;
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
}

#pragma mark - btn event

- (void)removeDriftLabel
{
    for (int i = 0; i < MaxLabelNum; i++) {
        [[self.view viewWithTag:LabelTagOffset + MaxLabelNum] removeFromSuperview];
    }
}

- (void)addDriftAnimation:(NSArray*)sentences baseTime:(CGFloat)time line:(NSInteger)line isSelf:(BOOL)isSelf
{
    int marginWidth = 10;
    int textHeight = 30;
    int marginTop = 5*(line+1) + textHeight*line;
    CGFloat previousRight = self.player.view.width;
    int startTag = 10 * line;
    for (NSString *text in sentences) {
        if ([text isEqualToString:self.previousText] && !isSelf) {
            continue;
        }
        UIFont *font = [UIFont systemFontOfSize:15];
        CGFloat width = [text widthWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(previousRight + marginWidth, marginTop, width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = text;
        if (isSelf) {
            label.textColor = [UIColor redColor];
        }
        else{
            label.textColor = [UIColor whiteColor];
        }
        [label sizeToFit];
        label.tag = LabelTagOffset + startTag;
        previousRight = label.right;
        
        //速度固定的
        CGFloat baseInterval = time;
        CGFloat velocity = self.player.view.width/baseInterval;
        CGFloat intervalOflabel = label.right/velocity;
        CGFloat showIntervalOfLabel = (label.right - self.player.view.width)/velocity;
        if (showIntervalOfLabel > 5.0) {
            break;
        }
        [self.player.view addSubview:label];
        [UIView animateWithDuration:intervalOflabel
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             label.right = 0;
                         } completion:^(BOOL finished) {
                             [label removeFromSuperview];
                         }];
        startTag ++;
    }
}

- (void)startDriftAnimation:(NSArray*)result
{
    if ([result count] == 0) {
        return;
    }
    NSInteger maxNumInLine = 10;
    NSInteger totalLine = ([result count]-1)/maxNumInLine + 1;
    NSInteger index = 0;
    CGFloat baseTime = 4.0;
    for (index = 0; index < totalLine; index++) {
        NSRange range;
        range.location = index * maxNumInLine;
        
        range.length = maxNumInLine*(index + 1) > [result count] ?
                       ([result count] - range.location):
                       (maxNumInLine*(index + 1) - range.location);
        
        NSArray *subAry = [result subarrayWithRange:range];
        [self addDriftAnimation:subAry baseTime:baseTime line:index isSelf:NO];
        baseTime = baseTime + 0.5;
    }
}

- (void)getCommentText
{
    if (self.player.playbackState != MPMoviePlaybackStatePlaying){
        return;
    }
    NSDictionary *tvInfo = _detailItem;
    NSString *tvName = [tvInfo objectForKey:@"name"];
    NSDictionary *para = @{@"topic":tvName};
    self.postAction.parameter = [NSMutableDictionary dictionaryWithDictionary:para];
    [self.postAction postResult:^(NSArray *result) {
        [self startDriftAnimation:result];
//        [self addDriftAnimation:result baseTime:4.0 line:0 isSelf:NO];
    } error:^(NSError *error) {
        ;
    }];
}

-(void)sendText
{
	[self.textView resignFirstResponder];
    NSDictionary *tvInfo = _detailItem;
    NSString *tvName = [tvInfo objectForKey:@"name"];
    if ([self.textView hasText]) {
        self.previousText = self.textView.text;
        NSDictionary *para = @{@"topic":tvName,@"message": self.textView.text};
        self.postAction.parameter = [NSMutableDictionary dictionaryWithDictionary:para];
        [self.postAction postResult:^(NSArray *result) {
            self.textView.text = @"";
        } error:^(NSError *error) {
            ;
        }];
        [self addDriftAnimation:@[self.textView.text] baseTime:4.0 line:0 isSelf:YES];
    }
}

- (void)adjustAudioCtrOrgin
{
    CGPoint orgin = CGPointZero;
    orgin.x = self.containerView.right - self.audioRecognizeCtr.width-5;
    orgin.y = self.containerView.top - self.audioRecognizeCtr.height-5;
    self.audioRecognizeCtr.origin = orgin;
}

- (void)showAudioCtr
{
    if ([self.audioRecognizeCtr start]) {
        self.iFlyAudioBtn.enabled = NO;
        [self adjustAudioCtrOrgin];
        [UIView animateWithDuration:0.25 animations:^{
            self.audioRecognizeCtr.alpha = 1;
        }];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - growView delegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendText];
    return YES;
}

#pragma mark - iFlyRecongnize delegate

- (void)onUpdateTextView:(NSString *)sentence
{
	
	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", self.textView.text, sentence];
	self.textView.text = str;
    [UIView animateWithDuration:0.25 animations:^{
        self.audioRecognizeCtr.alpha = 0.0;
    }];
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
	 [[resultArray objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
    JMDEBUGPRINT(@"识别结束回调finish.....");
    self.iFlyAudioBtn.enabled = YES;
	JMDEBUGPRINT(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow:FALSE],[iFlyRecognizeControl getDownflow:FALSE]);

}

@end
