//
//  AHRViewController.m
//  UICollectionViewHW
//
//  Created by Anton Rivera on 3/12/14.
//  Copyright (c) 2014 Anton Hilario Rivera. All rights reserved.
//

#import "AHRViewController.h"
#import "AHRPhotoCell.h"
#import "AHRDraggingCell.h"

@interface AHRViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *theCollectionView;

///dragged view (over cells)
@property (nonatomic) UIImageView *draggingView;

///the point we first clicked
@property (nonatomic) CGPoint dragViewStartLocation;

///the indexpath for the first item
@property (nonatomic) NSIndexPath *startIndex;

@property (nonatomic, strong) NSMutableArray *photos;
//@property (nonatomic) NSMutableArray *numbers;

@end

@implementation AHRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.theCollectionView.dataSource = self;
    self.theCollectionView.delegate = self;
    
    _photos = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [_photos addObject:image];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AHRPhotoCell *cell = [self.theCollectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"
                                                                           forIndexPath:indexPath];
    
    cell.imageView.image = _photos[indexPath.row];
    
    return cell;
}

- (IBAction)longPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint loc = [sender locationInView:self.theCollectionView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startIndex = [self.theCollectionView indexPathForItemAtPoint:loc];
        
        if (self.startIndex) {
            AHRDraggingCell *cell = (AHRDraggingCell*)[self.theCollectionView cellForItemAtIndexPath:self.startIndex];
            self.draggingView = [[UIImageView alloc] initWithImage:[cell getRasterizedImageCopy]];
            
//            [cell.contentView setAlpha:0.f];
            [self.view addSubview:self.draggingView];
            self.draggingView.center = loc;
            self.dragViewStartLocation = self.draggingView.center;
            [self.view bringSubviewToFront:self.draggingView];
            
            [UIView animateWithDuration:.4f animations:^{
                CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                self.draggingView.transform = transform;
            }];
        }
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.draggingView.center = loc;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.draggingView) {
            NSIndexPath *moveToIndexPath = [self.theCollectionView indexPathForItemAtPoint:loc];
            
            [UIView animateWithDuration:.4f animations:^{
                self.draggingView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
                //update date source
                NSNumber *thisNumber = [self.photos objectAtIndex:self.startIndex.row];
                [self.photos removeObjectAtIndex:self.startIndex.row];

                // Not doing anything, replaced with one line below
//                if (moveToIndexPath.row < self.startIndex.row) {
//                    [self.photos insertObject:thisNumber atIndex:moveToIndexPath.row];
//                } else {
//                    [self.photos insertObject:thisNumber atIndex:moveToIndexPath.row];
//                }
                [self.photos insertObject:thisNumber atIndex:moveToIndexPath.row];
                
                //change items
                __weak typeof(self) weakSelf = self;
                [self.theCollectionView performBatchUpdates:^{
                    __strong typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf.theCollectionView deleteItemsAtIndexPaths:@[ self.startIndex ]];
                        [strongSelf.theCollectionView insertItemsAtIndexPaths:@[ moveToIndexPath ]];
                    }
                } completion:nil];
                
                [self.draggingView removeFromSuperview];
                self.draggingView = nil;
                self.startIndex = nil;
            }];
            
            loc = CGPointZero;
        }
    }
}

@end
