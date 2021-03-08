const std = @import("std");
const vk = @import("vulkan");
const c = @import("c.zig");
const Allocator = std.mem.Allocator;

const required_device_extensions = [_][]const u8{
    vk.extension_info.khr_swapchain.name
};

const BaseDispatch = struct {
    vkCreateInstance: vk.PfnCreateInstance,
    usingnamespace vk.BaseWrapper(@This());
};

const InstanceDispatch = struct {
    vkDestroyInstance: vk.PfnDestroyInstance,
    vkCreateDevice: vk.PfnCreateDevice,
    vkDestroySurfaceKHR: vk.PfnDestroySurfaceKHR,
    vkEnumeratePhysicalDevices: vk.PfnEnumeratePhysicalDevices,
    vkGetPhysicalDeviceProperties: vk.PfnGetPhysicalDeviceProperties,
    vkEnumerateDeviceExtensionProperties: vk.PfnEnumerateDeviceExtensionProperties,
    vkGetPhysicalDeviceSurfaceFormatsKHR: vk.PfnGetPhysicalDeviceSurfaceFormatsKHR,
    vkGetPhysicalDeviceSurfacePresentModesKHR: vk.PfnGetPhysicalDeviceSurfacePresentModesKHR,
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR: vk.PfnGetPhysicalDeviceSurfaceCapabilitiesKHR,
    vkGetPhysicalDeviceQueueFamilyProperties: vk.PfnGetPhysicalDeviceQueueFamilyProperties,
    vkGetPhysicalDeviceSurfaceSupportKHR: vk.PfnGetPhysicalDeviceSurfaceSupportKHR,
    vkGetPhysicalDeviceMemoryProperties: vk.PfnGetPhysicalDeviceMemoryProperties,
    vkGetDeviceProcAddr: vk.PfnGetDeviceProcAddr,
    usingnamespace vk.InstanceWrapper(@This());
};

const DeviceDispatch = struct {
    vkDestroyDevice: vk.PfnDestroyDevice,
    vkGetDeviceQueue: vk.PfnGetDeviceQueue,
    vkCreateSemaphore: vk.PfnCreateSemaphore,
    vkCreateFence: vk.PfnCreateFence,
    vkCreateImageView: vk.PfnCreateImageView,
    vkDestroyImageView: vk.PfnDestroyImageView,
    vkDestroySemaphore: vk.PfnDestroySemaphore,
    vkDestroyFence: vk.PfnDestroyFence,
    vkGetSwapchainImagesKHR: vk.PfnGetSwapchainImagesKHR,
    vkCreateSwapchainKHR: vk.PfnCreateSwapchainKHR,
    vkDestroySwapchainKHR: vk.PfnDestroySwapchainKHR,
    vkAcquireNextImageKHR: vk.PfnAcquireNextImageKHR,
    vkDeviceWaitIdle: vk.PfnDeviceWaitIdle,
    vkWaitForFences: vk.PfnWaitForFences,
    vkResetFences: vk.PfnResetFences,
    vkQueueSubmit: vk.PfnQueueSubmit,
    vkQueuePresentKHR: vk.PfnQueuePresentKHR,
    vkCreateCommandPool: vk.PfnCreateCommandPool,
    vkDestroyCommandPool: vk.PfnDestroyCommandPool,
    vkAllocateCommandBuffers: vk.PfnAllocateCommandBuffers,
    vkFreeCommandBuffers: vk.PfnFreeCommandBuffers,
    vkQueueWaitIdle: vk.PfnQueueWaitIdle,
    vkCreateShaderModule: vk.PfnCreateShaderModule,
    vkDestroyShaderModule: vk.PfnDestroyShaderModule,
    vkCreatePipelineLayout: vk.PfnCreatePipelineLayout,
    vkDestroyPipelineLayout: vk.PfnDestroyPipelineLayout,
    vkCreateRenderPass: vk.PfnCreateRenderPass,
    vkDestroyRenderPass: vk.PfnDestroyRenderPass,
    vkCreateGraphicsPipelines: vk.PfnCreateGraphicsPipelines,
    vkDestroyPipeline: vk.PfnDestroyPipeline,
    vkCreateFramebuffer: vk.PfnCreateFramebuffer,
    vkDestroyFramebuffer: vk.PfnDestroyFramebuffer,
    vkBeginCommandBuffer: vk.PfnBeginCommandBuffer,
    vkEndCommandBuffer: vk.PfnEndCommandBuffer,
    vkAllocateMemory: vk.PfnAllocateMemory,
    vkFreeMemory: vk.PfnFreeMemory,
    vkCreateBuffer: vk.PfnCreateBuffer,
    vkDestroyBuffer: vk.PfnDestroyBuffer,
    vkGetBufferMemoryRequirements: vk.PfnGetBufferMemoryRequirements,
    vkMapMemory: vk.PfnMapMemory,
    vkUnmapMemory: vk.PfnUnmapMemory,
    vkBindBufferMemory: vk.PfnBindBufferMemory,
    vkCmdBeginRenderPass: vk.PfnCmdBeginRenderPass,
    vkCmdEndRenderPass: vk.PfnCmdEndRenderPass,
    vkCmdBindPipeline: vk.PfnCmdBindPipeline,
    vkCmdDraw: vk.PfnCmdDraw,
    vkCmdSetViewport: vk.PfnCmdSetViewport,
    vkCmdSetScissor: vk.PfnCmdSetScissor,
    vkCmdBindVertexBuffers: vk.PfnCmdBindVertexBuffers,
    vkCmdCopyBuffer: vk.PfnCmdCopyBuffer,
    usingnamespace vk.DeviceWrapper(@This());
};

pub const GraphicsContext = struct {
    vkb: BaseDispatch,
    vki: InstanceDispatch,
    vkd: DeviceDispatch,

    instance: vk.Instance,
    surface: vk.SurfaceKHR,
    pdev: vk.PhysicalDevice,
    props: vk.PhysicalDeviceProperties,
    mem_props: vk.PhysicalDeviceMemoryProperties,

    dev: vk.Device,
    graphics_queue: Queue,
    present_queue: Queue,

    pub fn init(allocator: *Allocator, app_name: [*:0]const u8, window: *c.GLFWwindow) !GraphicsContext {
        var self: GraphicsContext = undefined;
        self.vkb = try BaseDispatch.load(c.glfwGetInstanceProcAddress);

        var glfw_exts_count: u32 = 0;
        const glfw_exts = c.glfwGetRequiredInstanceExtensions(&glfw_exts_count);

        const app_info = vk.ApplicationInfo{
            .p_application_name = app_name,
            .application_version = vk.makeVersion(0, 0, 0),
            .p_engine_name = app_name,
            .engine_version = vk.makeVersion(0, 0, 0),
            .api_version = vk.API_VERSION_1_2,
        };

        self.instance = try self.vkb.createInstance(.{
            .flags = .{},
            .p_application_info = &app_info,
            .enabled_layer_count = 0,
            .pp_enabled_layer_names = undefined,
            .enabled_extension_count = glfw_exts_count,
            .pp_enabled_extension_names = @ptrCast([*]const [*:0]const u8, glfw_exts),
        }, null);

        self.vki = try InstanceDispatch.load(self.instance, c.glfwGetInstanceProcAddress);
        errdefer self.vki.destroyInstance(self.instance, null);

        self.surface = try createSurface(self.vki, self.instance, window);
        errdefer self.vki.destroySurfaceKHR(self.instance, self.surface, null);

        const candidate = try pickPhysicalDevice(self.vki, self.instance, allocator, self.surface);
        self.pdev = candidate.pdev;
        self.props = candidate.props;
        self.dev = try initializeCandidate(self.vki, candidate);
        self.vkd = try DeviceDispatch.load(self.dev, self.vki.vkGetDeviceProcAddr);
        errdefer self.vkd.destroyDevice(self.dev, null);

        self.graphics_queue = Queue.init(self.vkd, self.dev, candidate.queues.graphics_family);
        self.present_queue = Queue.init(self.vkd, self.dev, candidate.queues.graphics_family);

        self.mem_props = self.vki.getPhysicalDeviceMemoryProperties(self.pdev);

        return self;
    }

    pub fn deinit(self: GraphicsContext) void {
        self.vkd.destroyDevice(self.dev, null);
        self.vki.destroySurfaceKHR(self.instance, self.surface, null);
        self.vki.destroyInstance(self.instance, null);
    }

    pub fn deviceName(self: GraphicsContext) []const u8 {
        const len = std.mem.indexOfScalar(u8, &self.props.device_name, 0).?;
        return self.props.device_name[0 .. len];
    }

    pub fn findMemoryTypeIndex(self: GraphicsContext, memory_type_bits: u32, flags: vk.MemoryPropertyFlags) !u32 {
        for (self.mem_props.memory_types[0 .. self.mem_props.memory_type_count]) |mem_type, i| {
            if (memory_type_bits & (@as(u32, 1) << @truncate(u5, i)) != 0 and mem_type.property_flags.contains(flags)) {
                return @truncate(u32, i);
            }
        }

        return error.NoSuitableMemoryType;
    }

    pub fn allocate(self: GraphicsContext, requirements: vk.MemoryRequirements, flags: vk.MemoryPropertyFlags) !vk.DeviceMemory {
        return try self.vkd.allocateMemory(self.dev, .{
            .allocation_size = requirements.size,
            .memory_type_index = try self.findMemoryTypeIndex(requirements.memory_type_bits, flags),
        }, null);
    }
};

pub const Queue = struct {
    handle: vk.Queue,
    family: u32,

    fn init(vkd: DeviceDispatch, dev: vk.Device, family: u32) Queue {
        return .{
            .handle = vkd.getDeviceQueue(dev, family, 0),
            .family = family,
        };
    }
};

fn createSurface(vki: InstanceDispatch, instance: vk.Instance, window: *c.GLFWwindow) !vk.SurfaceKHR {
    var surface: vk.SurfaceKHR = undefined;
    if (c.glfwCreateWindowSurface(instance, window, null, &surface) != .success) {
        return error.SurfaceInitFailed;
    }

    return surface;
}

fn initializeCandidate(vki: InstanceDispatch, candidate: DeviceCandidate) !vk.Device {
    const priority = [_]f32{1};
    const qci = [_]vk.DeviceQueueCreateInfo{
        .{
            .flags = .{},
            .queue_family_index = candidate.queues.graphics_family,
            .queue_count = 1,
            .p_queue_priorities = &priority,
        },
        .{
            .flags = .{},
            .queue_family_index = candidate.queues.present_family,
            .queue_count = 1,
            .p_queue_priorities = &priority,
        }
    };

    const queue_count: u32 = if (candidate.queues.graphics_family == candidate.queues.present_family)
            1
        else
            2;

    return try vki.createDevice(candidate.pdev, .{
        .flags = .{},
        .queue_create_info_count = queue_count,
        .p_queue_create_infos = &qci,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
        .enabled_extension_count = required_device_extensions.len,
        .pp_enabled_extension_names = @ptrCast([*]const [*:0]const u8, &required_device_extensions),
        .p_enabled_features = null,
    }, null);
}

const DeviceCandidate = struct {
    pdev: vk.PhysicalDevice,
    props: vk.PhysicalDeviceProperties,
    queues: QueueAllocation,
};

const QueueAllocation = struct {
    graphics_family: u32,
    present_family: u32,
};

fn pickPhysicalDevice(
    vki: InstanceDispatch,
    instance: vk.Instance,
    allocator: *Allocator,
    surface: vk.SurfaceKHR,
) !DeviceCandidate {
    var device_count: u32 = undefined;
    _ = try vki.enumeratePhysicalDevices(instance, &device_count, null);

    const pdevs = try allocator.alloc(vk.PhysicalDevice, device_count);
    defer allocator.free(pdevs);

    _ = try vki.enumeratePhysicalDevices(instance, &device_count, pdevs.ptr);

    for (pdevs) |pdev| {
        if (try checkSuitable(vki, pdev, allocator, surface)) |candidate| {
            return candidate;
        }
    }

    return error.NoSuitableDevice;
}

fn checkSuitable(
    vki: InstanceDispatch,
    pdev: vk.PhysicalDevice,
    allocator: *Allocator,
    surface: vk.SurfaceKHR,
) !?DeviceCandidate {
    const props = vki.getPhysicalDeviceProperties(pdev);

    if (!try checkExtensionSupport(vki, pdev, allocator)) {
        return null;
    }

    if (!try checkSurfaceSupport(vki, pdev, surface)) {
        return null;
    }

    if (try allocateQueues(vki, pdev, allocator, surface)) |allocation| {
        return DeviceCandidate{
            .pdev = pdev,
            .props = props,
            .queues = allocation
        };
    }

    return null;
}

fn allocateQueues(
    vki: InstanceDispatch,
    pdev: vk.PhysicalDevice,
    allocator: *Allocator,
    surface: vk.SurfaceKHR
) !?QueueAllocation {
    var family_count: u32 = undefined;
    vki.getPhysicalDeviceQueueFamilyProperties(pdev, &family_count, null);

    const families = try allocator.alloc(vk.QueueFamilyProperties, family_count);
    defer allocator.free(families);
    vki.getPhysicalDeviceQueueFamilyProperties(pdev, &family_count, families.ptr);

    var graphics_family: ?u32 = null;
    var present_family: ?u32 = null;

    for (families) |properties, i| {
        const family = @intCast(u32, i);

        if (graphics_family == null and properties.queue_flags.contains(.{.graphics_bit = true})) {
            graphics_family = family;
        }

        if (present_family == null and (try vki.getPhysicalDeviceSurfaceSupportKHR(pdev, family, surface)) == vk.TRUE) {
            present_family = family;
        }
    }

    if (graphics_family != null and present_family != null) {
        return QueueAllocation{
            .graphics_family = graphics_family.?,
            .present_family = present_family.?
        };
    }

    return null;
}

fn checkSurfaceSupport(vki: InstanceDispatch, pdev: vk.PhysicalDevice, surface: vk.SurfaceKHR) !bool {
    var format_count: u32 = undefined;
    _ = try vki.getPhysicalDeviceSurfaceFormatsKHR(pdev, surface, &format_count, null);

    var present_mode_count: u32 = undefined;
    _ = try vki.getPhysicalDeviceSurfacePresentModesKHR(pdev, surface, &present_mode_count, null);

    return format_count > 0 and present_mode_count > 0;
}

fn checkExtensionSupport(
    vki: InstanceDispatch,
    pdev: vk.PhysicalDevice,
    allocator: *Allocator,
) !bool {
    var count: u32 = undefined;
    _ = try vki.enumerateDeviceExtensionProperties(pdev, null, &count, null);

    const propsv = try allocator.alloc(vk.ExtensionProperties, count);
    defer allocator.free(propsv);

    _ = try vki.enumerateDeviceExtensionProperties(pdev, null, &count, propsv.ptr);

    for (required_device_extensions) |ext| {
        for (propsv) |props| {
            const len = std.mem.indexOfScalar(u8, &props.extension_name, 0).?;
            const prop_ext_name = props.extension_name[0 .. len];
            if (std.mem.eql(u8, ext, prop_ext_name)) {
                break;
            }
        } else {
            return false;
        }
    }

    return true;
}
