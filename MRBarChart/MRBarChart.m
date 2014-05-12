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
    CGFloat _barHeight;
    CGFloat _labelHeight;
    NSMutableArray *_guideLabels;
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
    _barHeight = self.frame.size.height;
    _barLabelProportion = 1.0;
    _labelColor = [UIColor blackColor];
    _labelFont = [UIFont systemFontOfSize:13.0];
    _yLabelColor = [UIColor darkGrayColor];
    _yLabelFont = [UIFont systemFontOfSize:11.0];
    _yLabelsWidth = 60.0;
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
    [self reloadData];
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
    CGFloat y = _barHeight -  ((_markValue / _maxValue) * _barHeight);
    CGRect frame = CGRectMake(0, y, _collectionView.frame.size.width, 1.0/[UIScreen mainScreen].scale);
    _markView.frame = frame;
}

- (void)setMarkColor:(UIColor *)markColor {
    _markColor = markColor;
    _markView.backgroundColor = _markColor;
}

- (void)setBarLabelProportion:(CGFloat)barLabelProportion {
    _barLabelProportion = barLabelProportion;
    _barHeight = self.frame.size.height * _barLabelProportion;
    [self setMarkValue:_markValue];
    [self needsReload];
}

- (void)reloadData {
    [self reloadDataAnimated:NO];
}

- (void)reloadDataAnimated:(BOOL)animated {
    _animate = animated;
    [_collectionView reloadData];
    
    [_guideLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_guideLabels removeAllObjects];
    CGRect cFrame = _collectionView.frame;
    if ([_dataSource respondsToSelector:@selector(numberOfYAxisLabelsInChart:)] && [_dataSource respondsToSelector:@selector(barChart:labelForYIndex:)]) {
        cFrame.origin.x = _yLabelsWidth;
        NSInteger yLabelsCount = [_dataSource numberOfYAxisLabelsInChart:self];
        _guideLabels = [NSMutableArray arrayWithCapacity:yLabelsCount];
        for (int i = 0; i < yLabelsCount; i++) {
            CGFloat y = (_barHeight - [_yLabelFont lineHeight]) - (i * (_barHeight / yLabelsCount));
            if ([_dataSource respondsToSelector:@selector(barChart:positionForYLabelAtIndex:)]) {
                y = _barHeight - [_yLabelFont lineHeight] - ([_dataSource barChart:self positionForYLabelAtIndex:i] / _maxValue) * _barHeight;
            }
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, y, _yLabelsWidth, [_yLabelFont lineHeight])];
            l.backgroundColor = [UIColor clearColor];
            l.textColor = _yLabelColor;
            l.font = _yLabelFont;
            l.text = [_dataSource barChart:self labelForYIndex:i];
            [self addSubview:l];
            [_guideLabels addObject:l];
        }
    }
    
    if (_guideLabels.count == 0) {
        cFrame.origin.x = 0.0;
    }
    
    _collectionView.frame = cFrame;
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
        
        [cell setBarLabelProportion:_barLabelProportion];
        if (_barLabelProportion < 1.0 && [_dataSource respondsToSelector:@selector(barChart:labelForBarAtIndex:)]) {
            NSString *text = [_dataSource barChart:self labelForBarAtIndex:indexPath.row];
            [cell setLabelText:text];
            cell.label.textColor = _labelColor;
            cell.label.font = _labelFont;
        } else {
            [cell setLabelText:nil];
        }
        
        [cell setValue:proportion animated:_animate && _lastIndexSeen < indexPath.row];
        
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
