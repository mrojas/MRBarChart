//
//  MRBarGraph.m
//
//  Created by Matias Rojas on 10/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import "MRBarChart.h"
#import "MRBarChartCell.h"

#define kBarChartCellId @"barChartCell"
#define kDefaultBarPadding 2.0
#define kDefaultBarWidth 15.0

@interface MRBarChart () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MRBarChart {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
    UIView *_markView;
    BOOL _animate;
    NSInteger _lastIndexSeen;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    _lastIndexSeen = 0;
    _animate = YES;
    _markColor = [UIColor lightGrayColor];
    _defaultColor = [UIColor blueColor];
    _barPadding = kDefaultBarPadding;
    _barWidth = kDefaultBarWidth;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_flowLayout setMinimumInteritemSpacing:0.0f];
    [_flowLayout setMinimumLineSpacing:0.0f];
    [_flowLayout setItemSize:CGSizeMake(kDefaultBarWidth + kDefaultBarPadding * 2.0, self.frame.size.height)];

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MRBarChartCell class] forCellWithReuseIdentifier:kBarChartCellId];
    [_collectionView setPagingEnabled:NO];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_collectionView];
}

- (void)needsReload {
    _flowLayout.itemSize = CGSizeMake(_barWidth + (_barPadding * 2.0), self.frame.size.height);
    [_collectionView reloadData];
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
    [_collectionView reloadData];
}

- (void)setBarWidth:(CGFloat)barWidth {
    _barWidth = barWidth;
    [self needsReload];
}

- (void)setBarPadding:(CGFloat)barPadding {
    _barPadding = barPadding;
    [self needsReload];
}

- (void)setMarkValue:(CGFloat)markValue {
    _markValue = markValue;
    if (!_markView) {
        _markView = [[UIView alloc] initWithFrame:CGRectZero];
        _markView.backgroundColor = _markColor;
        _markView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_markView];
    }
    CGFloat y = _collectionView.frame.size.height -  ((_markValue / _maxValue) * _collectionView.frame.size.height);
    CGRect frame = CGRectMake(0, y, _collectionView.frame.size.width, 1.0/[UIScreen mainScreen].scale);
    _markView.frame = frame;
}

- (void)setMarkColor:(UIColor *)markColor {
    _markColor = markColor;
    _markView.backgroundColor = _markColor;
}

- (void)reloadData {
    [self reloadDataAnimated:NO];
}

- (void)reloadDataAnimated:(BOOL)animated {
    _animate = animated;
    [_collectionView reloadData];
}

- (void)addBarAtIndex:(NSInteger)index animated:(BOOL)animated {
    _animate = animated;
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

- (void)removeBarAtIndex:(NSInteger)index {
        [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        _lastIndexSeen = index-1;
}

#pragma mark UICollectionViewDataSource implementation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataSource) {
        return [_dataSource numberOfBarsInChart:self];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MRBarChartCell *cell = (MRBarChartCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kBarChartCellId forIndexPath:indexPath];
    
    if (_dataSource) {
        cell.barPadding = _barPadding;
        CGFloat val = [_dataSource barChart:self valueForBarAtIndex:indexPath.row];
        CGFloat proportion = val / _maxValue;
        [cell setValue:proportion animated:_animate && _lastIndexSeen < indexPath.row];
        
        if ([_dataSource respondsToSelector:@selector(barChart:colorForBarAtIndex:)]) {
            UIColor *color = [_dataSource barChart:self colorForBarAtIndex:indexPath.row];
            if (color) {
                [cell setColor:color];
            } else {
                [cell setColor:_defaultColor];
            }
        } else {
            [cell setColor:_defaultColor];
        }
        
        _lastIndexSeen = indexPath.row > _lastIndexSeen ? indexPath.row : _lastIndexSeen;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(barChart:didSelectBarAtIndex:)]) {
        [_delegate barChart:self didSelectBarAtIndex:indexPath.row];
    }
}


@end
