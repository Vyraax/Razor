workspace "Razor"
	architecture "x64"
	startproject "Sandbox"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Razor/vendor/GLFW/include"
IncludeDir["Glad"] = "Razor/vendor/Glad/include"
IncludeDir["ImGui"] = "Razor/vendor/imgui"
IncludeDir["glm"] = "Razor/vendor/glm"
IncludeDir["stb"] = "Razor/vendor/stb"
IncludeDir["assimp"] = "Razor/vendor/assimp/include"

include "Razor/vendor/GLFW"
include "Razor/vendor/Glad"
include "Razor/vendor/ImGui"


project "Razor"
	location "Razor"
	kind "StaticLib"
	staticruntime "on"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "rzpch.h"
	pchsource "Razor/src/rzpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl",
		"%{prj.name}/vendor/assimp/include/**"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}",
		"%{IncludeDir.stb}",
		"%{prj.name}/vendor/assimp/include",
		"%{prj.name}/vendor/assimp/build/include"
	}

	libdirs { "%{prj.name}/vendor/assimp/build/code/Release" }

	links
	{
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib",
		"assimp"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"IMGUI_API=__declspec(dllexport)",
			"RZ_PLATFORM_WINDOWS",
			"GLFW_INCLUDE_NONE",
			"_CRT_SECURE_NO_WARNINGS"
		}

		postbuildcommands
		{
			--"{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox",
			--"{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Server",
			"{COPY} ../Razor/vendor/assimp/build/code/Release/assimp.dll ../bin/Release-windows-x86_64/Sandbox",
			"{COPY} ../Razor/vendor/assimp/build/code/Release/assimp.dll ../bin/Debug-windows-x86_64/Sandbox",
			"{COPY} ../Razor/vendor/assimp/build/code/Release/assimp.dll ../bin/Release-windows-x86_64/Server",
			"{COPY} ../Razor/vendor/assimp/build/code/Release/assimp.dll ../bin/Debug-windows-x86_64/Server"
		}

	filter "configurations:Debug"
		defines "RZ_DEBUG"
		buildoptions {"/MTd"}
		symbols "On"
		
	filter "configurations:Release"
		defines "RZ_RELEASE"
		runtime "Release"
		optimize "On"
		
	filter "configurations:Dist"
		defines "RZ_DIST"
		runtime "Release"
		optimize "On"


project "Sandbox"
	location "Sandbox"

	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Razor/vendor/spdlog/include",
		"Razor/src",
		"Razor/vendor",
		"%{IncludeDir.glm}"
	}

	links
	{
		"Razor"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"RZ_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "RZ_DEBUG"
		kind "ConsoleApp"
		symbols "On"
		
	filter "configurations:Release"
		defines "RZ_RELEASE"
		optimize "On"
		kind "WindowedApp"
		entrypoint "mainCRTStartup" 
		
	filter "configurations:Dist"
		defines "RZ_DIST"
		optimize "On"
		kind "WindowedApp"
		entrypoint "mainCRTStartup" 

project "Server"
	location "Server"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Razor/vendor/spdlog/include",
		"Razor/src",
		"Razor/vendor",
		"%{IncludeDir.glm}"
	}

	links
	{
		"Razor"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"RZ_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "RZ_DEBUG"
		symbols "On"
		buildoptions {"/MTd"}
		
	filter "configurations:Release"
		defines "RZ_RELEASE"
		optimize "On"
		
	filter "configurations:Dist"
		defines "RZ_DIST"
		optimize "On"
