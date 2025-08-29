# 设置当前模块的本地路径
LOCAL_PATH := $(call my-dir)

# 清除之前的变量 (预编译库部分)
include $(CLEAR_VARS)
LOCAL_MODULE := dobby
LOCAL_SRC_FILES := libraries/$(TARGET_ARCH_ABI)/libdobby.a
include $(PREBUILT_STATIC_LIBRARY)

# 清除变量 (主模块部分)
include $(CLEAR_VARS)

# 设置模块名称
LOCAL_MODULE := MyLibName

# 设置C++标准
LOCAL_CPPFLAGS += -std=c++20 -fexceptions

# 添加编译标志 - 修正了-fvisibility-hidden为-fvisibility=hidden
LOCAL_CPPFLAGS += -w -s -Wno-error=format-security -fvisibility=hidden -fpermissive -Wno-error=c++11-narrowing -Wall
LOCAL_CPPFLAGS += -Werror=format -fdata-sections -ffunction-sections
LOCAL_CPPFLAGS += -O3 -fvisibility-inlines-hidden
# 这会抑制所有重定义警告，但可能隐藏其他重要错误
# LOCAL_CFLAGS += -Wno-redefinition
# 链接器标志
LOCAL_LDFLAGS += -ffixed-x18 -Wl,--hash-style=both
LOCAL_LDFLAGS += -Wl,-exclude-libs,ALL -Wl,--gc-sections -Wl,--strip-all

# 调试模式设置
ifeq ($(TARGET_BUILD_TYPE),debug)
    LOCAL_CPPFLAGS += -D__DEBUG__
else
    # 发布模式特定设置
    LOCAL_CPPFLAGS += -DDOBBY_DEBUG=OFF
endif

# 源文件列表
LOCAL_SRC_FILES := \
    Main.cpp \
    Menu/Menu.cpp \
    Menu/Setup.cpp \
    Includes/Utils.cpp \
    KittyMemory/KittyMemory.cpp \
    KittyMemory/MemoryPatch.cpp \
    KittyMemory/MemoryBackup.cpp \
    KittyMemory/KittyUtils.cpp \
    Il2cpp/Il2cpp.cpp \
    Il2cpp/il2cpp-class.cpp \
    Il2cpp/xdl/xdl.c \
    Il2cpp/xdl/xdl_iterate.c \
    Il2cpp/xdl/xdl_linker.c \
    Il2cpp/xdl/xdl_lzma.c \
    Il2cpp/xdl/xdl_util.c

# 包含目录
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH) \
    $(LOCAL_PATH)/Includes \
    $(LOCAL_PATH)/Menu \
    $(LOCAL_PATH)/KittyMemory \
    $(LOCAL_PATH)/Il2cpp \
    $(LOCAL_PATH)/Il2cpp/xdl


# 依赖库
LOCAL_STATIC_LIBRARIES := dobby

# 系统库链接
LOCAL_LDLIBS := -llog -landroid -lEGL -lGLESv2

# 构建共享库
include $(BUILD_SHARED_LIBRARY)

# 包含json库 (如果有的话)
# include $(LOCAL_PATH)/json/Android.mk