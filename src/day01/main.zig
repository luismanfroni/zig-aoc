const std = @import("std");

const data = @embedFile("./input.txt");

const MeasurementType = struct {
    count: u32,
    measurement: u32,
    measurementWindow: u32
};

pub fn get_measurements(lines: *std.mem.TokenIterator(u8)) MeasurementType {
    var count: u32 = 0;
    var measurement: u32 = 0;
    var window: [3]u32 = .{ 0, 0, 0 };
    var measurementWindow: u32 = 0;

    while (lines.next()) |line| {
        const currentNum = std.fmt.parseInt(u32, line, 10) catch unreachable;
        const lastNum = window[0];
        const firstTime = count == 0;

        //Part1 - How many measurements are larger than the previous measurement
        if (!firstTime and currentNum > lastNum) {
            measurement += 1;
        }

        const lastSum = window[2] + window[1] + lastNum;
        const currentSum = window[1] + lastNum + currentNum;
        const hasAllWindowValues = count >= 3;

        //Part2 - Same but with a three-measurement sliding window sum
        if (hasAllWindowValues and currentSum > lastSum) {
            measurementWindow += 1;
        }

        window[2] = window[1];
        window[1] = lastNum;
        window[0] = currentNum;
        count += 1;
    }

    return .{
        .count = count,
        .measurement = measurement,
        .measurementWindow = measurementWindow
    };
}
pub fn main() anyerror!void {
    var lines = std.mem.tokenize(u8, data, "\n");
    const measurements = get_measurements(&lines);
    std.log.info("count: {}. measurement: {}. measurementWindow: {}.", .{ measurements.count, measurements.measurement, measurements.measurementWindow });
}

const test_data = @embedFile("./testdata.txt");

test "part1 and part2" {
    var lines = std.mem.tokenize(u8, test_data, "\n");
    const measurements = get_measurements(&lines);

    try std.testing.expectEqual(measurements.measurement, 7);

    try std.testing.expectEqual(measurements.measurementWindow, 5);
}
