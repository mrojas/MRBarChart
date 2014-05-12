//
//  BarGraphCell.h
//
//  Created by Matias Rojas on 10/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRBarChartCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat barPadding;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat barLabelProportion;
@property (nonatomic, strong) UILabel *label;

- (void)setValue:(CGFloat)value animated:(BOOL)animated;
- (void)setLabelText:(NSString *)text;

@end
