const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("mibu", .{ .root_source_file = .{ .path = "src/main.zig" }, .target = target, .optimize = optimize });

    const main_tests = b.addTest(.{ .root_source_file = .{ .path = "src/main.zig" }, .target = target, .optimize = optimize });

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    // examples
    const color = b.addExecutable(.{ .name = "color", .root_source_file = .{ .path = "examples/color.zig" }, .target = target, .optimize = optimize });
    color.root_module.addImport("mibu", module);

    const color_run_cmd = b.addRunArtifact(color);
    color_run_cmd.step.dependOn(b.getInstallStep());

    const color_step = b.step("color", "Run color example");
    color_step.dependOn(&color_run_cmd.step);

    const event = b.addExecutable(.{ .name = "event", .root_source_file = .{ .path = "examples/event.zig" }, .target = target, .optimize = optimize });
    event.root_module.addImport("mibu", module);

    const event_run_cmd = b.addRunArtifact(event);
    event_run_cmd.step.dependOn(b.getInstallStep());

    const event_step = b.step("event", "Run event example");
    event_step.dependOn(&event_run_cmd.step);
}
