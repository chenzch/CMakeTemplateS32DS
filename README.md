# CMakeTemplateS32DS
CMake Templates for S32DS

# Windows 安装
## Step 1 安装基础软件
- winget install cmake
- winget install Ninja-build.Ninja
## Step 2 修改路径
- 将CMakeLists.txt中的CMAKE_MODULE_PATH修改为本项目的路径
- 修改cmake/rtd/s32dsrtd.cmake中的S32DS_DIR路径修改为当前S32DS的安装路径
- 修改cmake/toolchain/nxpgcc11.cmake中的S32DS_DIR路径修改为当前S32DS的安装路径
## Step 3 复制文件
- 将CMakeLists.txt和CMakePresets.json文件复制到项目根目录中
## Step 4 修改项目根目录中的CMakeLists.txt里的项目属性
- 修改PROJECT_NAME为当前项目名
- 根据项目需要修改add_definitions中的define选项
- 根据项目需要往include_directories中添加项目里头文件搜索路径，S32DS自动生成的路径已在cmake/source/s32ds.cmake中包含
- 根据项目需要往aux_source_directory中添加项目里的源文件路径，S32DS自动生成的路径已在cmake/source/s32ds.cmake中包含
## Step 5 生成
- 在项目根目录中运行 cmake --preset ninja-debug 或者 cmake --preset ninja-release 来生成build使用的文件
- 在项目根目录中运行 cmake --build build 来编译项目