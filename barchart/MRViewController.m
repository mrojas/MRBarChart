//
//  MRViewController.m
//  bargraph
//
//  Created by Matias Rojas on 10/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import "MRViewController.h"
#import "MRBarChart.h"

#define kMaxBars 10
#define kMaxValue 100.0

@interface MRViewController () <MRBarChartDataSource, MRBarChartDelegate>
@property (strong, nonatomic) IBOutlet MRBarChart *barChart;
@property (strong, nonatomic) IBOutlet UILabel *markLabel;
@property (strong, nonatomic) IBOutlet UILabel *barWidthLabel;
@property (strong, nonatomic) IBOutlet UILabel *barPaddingLabel;
@end

@implementation MRViewController {
    NSMutableArray *_values;
    NSInteger _markValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _values = [NSMutableArray arrayWithCapacity:kMaxBars];
    
    for (NSInteger i = 0; i < kMaxBars; i++) {
        NSInteger val = arc4random_uniform(kMaxValue);
        [_values addObject:[NSNumber numberWithInteger:val]];
    }

    _barChart.maxValue = kMaxValue;
    _barChart.markValue = 60.0;
    _barChart.defaultColor = [UIColor colorWithRed:75.0/255.0 green:88.0/255.0 blue:173.0/255.0 alpha:1.0];
    _barChart.barLabelProportion = 0.60;
    _barChart.dataSource = self;
    _barChart.delegate = self;
    
    [self refreshBarPadding];
    [self refreshBarWidth];
    [self refreshMark];
}

- (void)refreshMark {
    _markLabel.text = [NSString stringWithFormat:@"Mark: %.2f", _barChart.markValue];
}

- (void)refreshBarWidth {
    _barWidthLabel.text = [NSString stringWithFormat:@"Bar width: %.2f", _barChart.barWidth];
}

- (void)refreshBarPadding {
    _barPaddingLabel.text = [NSString stringWithFormat:@"Bar padding: %.2f", _barChart.barPadding];
}

- (IBAction)addBarButtonPressed:(id)sender {
    NSInteger val = arc4random_uniform(kMaxValue);
    [_values addObject:[NSNumber numberWithInteger:val]];
    [_barChart addBarAtIndex:_values.count-1 animated:YES];
}

- (IBAction)removeBarButtonPressed:(id)sender {
    if (_values.count > 0) {
        [_values removeObjectAtIndex:_values.count - 1];
        [_barChart removeBarAtIndex:_values.count];
    }
}

- (IBAction)markUpButtonPressed:(id)sender {
    _barChart.markValue = _barChart.markValue + 1;
    [self refreshMark];
}

- (IBAction)markDownButtonPressed:(id)sender {
    _barChart.markValue = _barChart.markValue - 1;
    [self refreshMark];
}

- (IBAction)barWidthMoreButtonPressed:(id)sender {
    _barChart.barWidth = _barChart.barWidth + 1;
    [self refreshBarWidth];
}

- (IBAction)barWidthLessButtonPressed:(id)sender {
    _barChart.barWidth = _barChart.barWidth - 1;
    [self refreshBarWidth];
}

- (IBAction)barPaddingMoreButtonPressed:(id)sender {
    _barChart.barPadding = _barChart.barPadding + 1;
    [self refreshBarPadding];
}

- (IBAction)barPaddingLessButtonPressed:(id)sender {
    _barChart.barPadding = _barChart.barPadding - 1;
    [self refreshBarPadding];
}

- (IBAction)labelsSwitchAction:(UISwitch *)sender {
    CGFloat proportion = sender.on ? 0.60 : 1.0;
    _barChart.barLabelProportion = proportion;
}

#pragma mark MRBarGraphDataSource implementation
- (NSInteger)numberOfBarsInChart:(MRBarChart *)chart {
    return _values.count;
}

- (CGFloat)barChart:(MRBarChart *)chart valueForBarAtIndex:(NSInteger)index {
    return [[_values objectAtIndex:index] floatValue];
}

- (UIColor *)barChart:(MRBarChart *)chart colorForBarAtIndex:(NSInteger)index {
    if (index % 5 == 0) {
        return [UIColor colorWithRed:75.0/255.0 green:173/255.0 blue:88.0/255.0 alpha:1.0];
    }
    
    return nil;
}

- (NSString *)barChart:(MRBarChart *)chart labelForBarAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"Bar %d", index];
}

#pragma mark MRBarGraphDelegate implementation

- (void)barChart:(MRBarChart *)chart didSelectBarAtIndex:(NSInteger)index {
    [_values removeObjectAtIndex:index];
    [chart removeBarAtIndex:index];
}

@end
