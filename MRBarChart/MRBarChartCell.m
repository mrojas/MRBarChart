//
//  BarGraphCell.m
//
//  Created by Matias Rojas on 10/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import "MRBarChartCell.h"

@implementation MRBarChartCell {
    UIView *_barView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
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
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-(_barPadding/2), self.contentView.frame.size.height)];
    _barView.backgroundColor = _color;
    
    [self.contentView addSubview:_barView];
}

- (void)setValue:(CGFloat)value animated:(BOOL)animated {
    CGRect frame = _barView.frame;
    
    if (animated) {
        CGFloat initialY = self.contentView.frame.size.height;
        frame.origin.y = initialY;
        _barView.frame = frame;
        frame.origin.y = (1.0 - value) * self.contentView.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            _barView.frame = frame;
        } completion:nil];
    } else {
        frame.origin.y = (1.0 - value) * self.contentView.frame.size.height;
        _barView.frame = frame;
    }
}

- (void)setBarPadding:(CGFloat)barPadding {
    _barPadding = barPadding;
    CGRect frame = _barView.frame;
    frame.origin.x = _barPadding;
    frame.size.width = self.contentView.frame.size.width - (_barPadding * 2);
    _barView.frame = frame;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    _barView.backgroundColor = _color;
}

- (void)prepareForReuse {
    _barView.frame = CGRectMake(0, 0, self.contentView.frame.size.width-(_barPadding/2), self.contentView.frame.size.height);
}

@end
