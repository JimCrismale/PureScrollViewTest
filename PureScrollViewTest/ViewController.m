//
//  ViewController.m
//  PureScrollViewTest
//
//  Created by James Crismale on 3/10/18.
//  Copyright © 2018 Akira Solutions. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <UIScrollViewDelegate>

@end

@implementation ViewController {
  UIScrollView *scrollView;
  UIImageView *imageView;
  NSArray *imageViewHorizontalConstraintsArray;
  NSArray *imageViewVerticalConstraintsArray;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  scrollView = [UIScrollView new];
  NSDictionary *viewsDictionary;
  
  UIImage *imageToDisplay = [UIImage imageNamed:@"cabaret_1"];
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageToDisplay.size.width, imageToDisplay.size.height)];
  imageView.image = imageToDisplay;
  
  NSLog(@"Initial Image View Size: %@", NSStringFromCGSize(imageView.bounds.size));
  
  [self.view addSubview:scrollView];
  [scrollView addSubview:imageView];
  scrollView.delegate = self;
  
  scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  
  viewsDictionary = NSDictionaryOfVariableBindings(scrollView, imageView);
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 views:viewsDictionary]];
  
  imageViewHorizontalConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics: 0 views:viewsDictionary];
  [scrollView addConstraints:imageViewHorizontalConstraintsArray];
  
  imageViewVerticalConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics: 0 views:viewsDictionary];
  [scrollView addConstraints:imageViewVerticalConstraintsArray];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self updateMinMaxZoomSize];
  
  NSLog(@"Scroll View Size: %@", NSStringFromCGSize(scrollView.bounds.size));
  NSLog(@"Image View Size: %@", NSStringFromCGSize(imageView.bounds.size));
}

- (void)updateMinMaxZoomSize {
  CGFloat widthScale = scrollView.bounds.size.width / imageView.bounds.size.width;
  CGFloat heightScale = scrollView.bounds.size.height / imageView.bounds.size.height;
  CGFloat minScale = MIN(widthScale, heightScale);
  
  scrollView.minimumZoomScale = minScale;
  scrollView.zoomScale = minScale;
  
  NSLog(@"minScale = %f", minScale);
}

- (void)updateConstraintsForSize {
  NSLog(@"[updateConstraintsForSize] Scroll View Size: %@", NSStringFromCGSize(scrollView.bounds.size));
  NSLog(@"[updateConstraintsForSize] Image View Size: %@", NSStringFromCGSize(imageView.bounds.size));
  
  CGFloat yOffset = MAX(0, (scrollView.bounds.size.height - imageView.frame.size.height) / 2);
  NSLog(@"yOffset = %f", yOffset);
  
  for (NSLayoutConstraint *verticalConstraint in imageViewVerticalConstraintsArray) {
    verticalConstraint.constant = yOffset;
  }
  
  CGFloat xOffset = MAX(0, (scrollView.bounds.size.width - imageView.frame.size.width) / 2);
  NSLog(@"xOffset = %f", xOffset);
  
  for (NSLayoutConstraint *horizontalConstraint in imageViewHorizontalConstraintsArray) {
    horizontalConstraint.constant = xOffset;
  }
  
  [scrollView layoutIfNeeded];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  [self updateConstraintsForSize];
}

@end
