 //
//  LDCPRefreshView.m
//  Pods
//
//  Created by ITxiansheng on 16/6/29.
//
//

#import "LDRefreshView.h"

@interface LDRefreshView ()

@property (nonatomic, copy) NSArray *loadingCats;
@property (nonatomic, copy) NSArray *rollOverCats;
@property (nonatomic, assign) BOOL isRollOverAnimating;
@property (nonatomic, assign) BOOL isLoadingAnimating;

@end

@implementation LDRefreshView

#pragma mark - life style

- (instancetype) init {
    
    return  [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        [self initSubviews];
        [self initConstraints];
    }
    return self;
}

#pragma mark Private Method

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.catImgView];
}

- (void)initConstraints {
    
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_catImgView);
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.catImgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.catImgView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:8];
    bottomConstraint.priority = 998;
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint
                                         constraintWithItem:self.catImgView
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1.0
                                         constant:-8];
    topConstraint.priority = 998;
    
    [self addConstraints:@[bottomConstraint,topConstraint]];

    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}
#pragma mark - public

- (void)startRollOverAnimation {
    
    if (self.isRollOverAnimating) {
        return;
    }
    self.isRollOverAnimating = YES;
    self.catImgView.image = [UIImage imageNamed:@"ldcat_4"];;
    self.catImgView.animationDuration = 0.3f;
    self.catImgView.animationRepeatCount = 1;
    self.catImgView.contentMode =UIViewContentModeCenter;
    self.catImgView.animationImages = self.rollOverCats;
    [self.catImgView startAnimating];
    
}
- (void)stopRollOverAnimation {
    
    self.isRollOverAnimating = NO;
    [self.catImgView stopAnimating];
    self.catImgView.animationImages = nil;
}


- (void)startLoadingAnimation {
    
    if (self.isLoadingAnimating) {
        return;
    }
    if (self.isRollOverAnimating) {
        [self stopRollOverAnimation];
    }
    self.isLoadingAnimating = YES;
    self.catImgView.animationDuration = 0.6f;
    self.catImgView.animationRepeatCount = 0;
    self.catImgView.contentMode =UIViewContentModeCenter;
    self.catImgView.animationImages = self.loadingCats;
    [self.catImgView startAnimating];
}

- (void)stopLoadingAnimation {
    
    if (self.isLoadingAnimating) {
        self.isLoadingAnimating = NO;
        [self.catImgView stopAnimating];
        self.catImgView.animationImages = nil;
        self.catImgView.contentMode = UIViewContentModeScaleToFill;
        self.catImgView.image = [UIImage imageNamed:@"ldcircle"];
    }
}

#pragma mark -getter

- (UIImageView *)catImgView {
    
    if (!_catImgView) {
        _catImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ldcircle"]];
        _catImgView.contentMode = UIViewContentModeScaleToFill;
        _catImgView.userInteractionEnabled = YES;
        _catImgView.translatesAutoresizingMaskIntoConstraints = NO;
        _catImgView.animationImages = self.rollOverCats;
    }
    return _catImgView;
}


- (NSArray *)loadingCats {
    
    if (!_loadingCats) {
        NSMutableArray *ma = [NSMutableArray array];
        for (int i = 4; i < 12; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ldcat_%d", i]];
            [ma addObject:image];
            _loadingCats = [NSArray arrayWithArray:ma];
        }
    }
    return _loadingCats;
}

- (NSArray *)rollOverCats {
    
    if (!_rollOverCats) {
        NSMutableArray *ma = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ldcat_%d", i]];
            [ma addObject:image];
            _rollOverCats = [NSArray arrayWithArray:ma];
        }
    }
    return _rollOverCats;

}



@end
