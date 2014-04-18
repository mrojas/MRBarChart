MRBarChart
==========

A simple scrollable bar chart based on UICollectionView

![MRBarChart](https://raw.github.com/mrojas/MRBarChart/master/barchart.png)

- DataSource/Delegate patterns
- Option to animate bars
- Optionally add a marker to the chart

###Installation

- Clone this github repo
- Add the MRBarChart directory to your project

###Usage

MRBarChart follows the usual data source pattern. You view controller should implement the protocol **MRBarChartDataSource**.
The following methods are mandatory:

- **numberOfBarsInChart**: Determines how many bars are in the bar chart. Example:
```Objective-C
- (NSInteger)numberOfBarsInChart:(MRBarChart *)chart {
    return 20;
}
```

- **valueForBarAtIndex**: Returns the value for a given bar. Example:
```Objective-C
- (CGFloat)barChart:(MRBarChart *)chart valueForBarAtIndex:(NSInteger)index {
    return 4.13;
}
```

Optionally, you can return a different color for each bar.

- **colorForBarAtIndex**: Returns the label for a given segment. Example:
```Objective-C
- (UIColor *)barChart:(MRBarChart *)chart colorForBarAtIndex:(NSInteger)index {
    return @"Segment 1";
}
```

In order to calculate the proportianal height of each bar, you must set the maximum value for the chart:

```Objective-C
_barChart.maxValue = 100.0;
```


###Storyboards

In addition to using the bar chart by doing [[MRChartView alloc] initWithFrame:...], if you are using storyboards you can simply drag a UIView into a view controller and set its class to MRBarChart.


### Customization

The following properties are customizable:

- **defaultColor**: The default color for the bars. Default: blue.
- **markValue**: The value at which the mark should be put. Optional, if not set, no mark is shown.
- **barWidth**: The width of the bars. Default: 15.
- **barPadding**: The spacing between the bars. Default: 2.
- **markColor**: The color of the mark. Default: light gray.

### Reloading

To reload the bar view call **reloadData:(BOOL)animated**.

Adding and removing bars can be done by using:

- (void)addBarAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeBarAtIndex:(NSInteger)index;

Check the sample project for documentation and usage options

###Delegate

Setting a delegate is optional and can be used to be notified when a bar is selected. Conform to the protocol **MRBarChartDelegate** and implement:

```Objective-C
- (void)barChart:(MRBarChart *)chart didSelectBarAtIndex:(NSInteger)index;
```
