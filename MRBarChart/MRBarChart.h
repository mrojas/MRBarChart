//
//  MRBarGraph.h
//
//  Created by Matias Rojas on 10/04/14.
//  Copyright (c) 2014 Causania. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRBarChart;

@protocol MRBarChartDataSource <NSObject>

/**
 *  Determines the amount of bars in the chart.
 *
 *  @param chart The chart
 *
 *  @return The amount of bars
 */
- (NSInteger)numberOfBarsInChart:(MRBarChart *)chart;

/**
 *  The value of a specific bar.
 *
 *  @param chart The chart that contains the bar
 *  @param index The index of the bar which value is requested
 *
 *  @return The value to be represented graphically in the bar
 */
- (CGFloat)barChart:(MRBarChart *)chart valueForBarAtIndex:(NSInteger)index;

@optional

/**
 *  The color of a bar in a given index
 *
 *  @param chart The chart containing the bar
 *  @param index The index of the bar
 *
 *  @return The color of the bar at the given index
 */
- (UIColor *)barChart:(MRBarChart *)chart colorForBarAtIndex:(NSInteger)index;

/**
 *  The label to be displayed below the bar.
 *
 *  @param chart The chart containing the bar
 *  @param index The index of the bar
 *
 *  @return The label of the bar
 */
- (NSString *)barChart:(MRBarChart *)chart labelForBarAtIndex:(NSInteger)index;

@end

@protocol MRBarChartDelegate <NSObject>

/**
 *  Callback when a bar is selected
 *
 *  @param chart The chart where the bar was selected
 *  @param index The index of the selected bar
 */
- (void)barChart:(MRBarChart *)chart didSelectBarAtIndex:(NSInteger)index;

@end

@interface MRBarChart : UIView

/**
 *  The default color to be used to draw the bars, in case colorForBarAtIndex is not implemented. Default: blue
 */
@property (nonatomic, strong) UIColor *defaultColor;

/**
 *  The max value of the chart, used to calculate the proportional height each bar should have in the chart.
 */
@property (nonatomic, assign) CGFloat maxValue;

/**
 *  Optional value to put a single pixel line, marking something of interest like an average, maximum, etc.
 */
@property (nonatomic, assign) CGFloat markValue;

/**
 *  The width of the bars. Default: 15dp
 */
@property (nonatomic, assign) CGFloat barWidth;

/**
 *  The padding to be applied to the bars, to create separation between them. Default: 2dp
 */
@property (nonatomic, assign) CGFloat barPadding;

/**
 *  Color of the optional mark. Default: light gray
 */
@property (nonatomic, strong) UIColor *markColor;

/**
 *  The proportion of the total height that bars occupy in relation to the labels, when enabled.
 *  Valid values are 0.0 to 1.0. 1.0 will make the bar take the entire vertical space, while setting it
 *  to 0.0 will make the labels take the entire space. 0.5 will make the bars take half of the chart, and
 *  labels the other half.
 *
 *  IMPORTANT: The data source method barChar:labelForBarAtIndex: will only be called if this value is
 *  less than 1.0, since that means labels will be displayed in the chart.
 *
 */
@property (nonatomic, assign) CGFloat barLabelProportion;

/**
 *  The font of the labels, when present
 */
@property (nonatomic, strong) UIFont *labelFont;

/**
 *  The color of the labels, when present
 */
@property (nonatomic, strong) UIColor *labelColor;

/**
 *  The datasource of this chart
 */
@property (nonatomic, weak) id<MRBarChartDataSource> dataSource;

/**
 *  An optional delegate of this chart.
 */
@property (nonatomic, weak) id<MRBarChartDelegate> delegate;

/**
 *  Reloads the bars in this chart
 *
 *  @param animated Whether it should be animated or not
 */
- (void)reloadDataAnimated:(BOOL)animated;

/**
 *  Reloads the bars in this chart without animation
 */
- (void)reloadData;

/**
 *  Adds a bar at a given index
 *
 *  @param index    The index of the bar to be added
 *  @param animated Whether it should be animated or not
 */
- (void)addBarAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  Removes a bar
 *
 *  @param index    The index of the bar to be removed
 */
- (void)removeBarAtIndex:(NSInteger)index;

@end
