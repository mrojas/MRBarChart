//
//  BarGraphCell.m
//
//  Created by Matias Rojas on 10/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import "MRBarChartCell.h"

@implementation MRBarChartCell {
    CGFloat _value;
    UIView *_barView;
    CGFloat _barHeight;
    CGFloat _labelHeight;
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
    _barHeight = self.contentView.frame.size.height;
    _labelHeight = 0.0;
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width-(_barPadding/2), _barHeight)];
    _barView.backgroundColor = _color;
    [self.contentView addSubview:_barView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _labelHeight, _barView.frame.size.width)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    [self.contentView addSubview:_label];
}

- (void)setBarLabelProportion:(CGFloat)barLabelProportion {
    _barLabelProportion = barLabelProportion;
    _barHeight = self.contentView.frame.size.height * _barLabelProportion;
    _labelHeight = self.contentView.frame.size.height - _barHeight;
    [self calculateLabelHeight];
}

- (void)calculateLabelHeight {
    CGRect labelFrame = CGRectMake(0.0, self.contentView.frame.size.height - _labelHeight, self.contentView.frame.size.width, _labelHeight);
    _label.frame = labelFrame;
}

- (void)setValue:(CGFloat)value animated:(BOOL)animated {
    _value = value;
    [self displayBar:animated];
}

- (void)displayBar:(BOOL)animated {
    CGRect frame = _barView.frame;
    
    if (animated) {
        CGFloat initialY = _barHeight;
        frame.origin.y = initialY;
        frame.size.height = 0.0;
        _barView.frame = frame;
        
        frame.origin.y = _barHeight - (1.0 - _value) * _barHeight;
        frame.size.height = (1.0 - _value) * _barHeight;
        [UIView animateWithDuration:0.3 animations:^{
            _barView.frame = frame;
        } completion:^(BOOL finished) {
            _label.hidden = _label.text.length == 0;
        }];
    } else {
        frame.origin.y = _barHeight - (1.0 - _value) * _barHeight;
        frame.size.height = (1.0 - _value) * _barHeight;
        _barView.frame = frame;
        _label.hidden = _label.text.length == 0;
    }
}

- (void)setLabelText:(NSString *)text {
    _label.text = text;
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
    _barView.frame = CGRectMake(0, 0, self.contentView.frame.size.width-(_barPadding/2), _barHeight);
}

@end
