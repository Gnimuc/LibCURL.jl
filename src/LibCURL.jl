VERSION < v"0.7.0-beta2.199" && __precompile__()

module LibCURL

import Compat: Sys, Cvoid

const time_t = Int
const size_t = Csize_t
const curl_off_t = Int64

include("lC_exports_h.jl")
include("lC_common_h.jl")

const libcurl = if Sys.iswindows()
    dir = if VERSION >= v"0.7"
        import WinRPM
        joinpath(dirname(pathof(WinRPM)), "..")
    else
        Pkg.dir("WinRPM")
    end
    joinpath(dir,"deps","usr","$(Base.Sys.ARCH)-w64-mingw32","sys-root","mingw","bin","libcurl-4")
else
    "libcurl"
end

include("lC_curl_h.jl")

curl_easy_setopt(handle, opt, ptrval::Array) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{Cvoid}), handle, opt, pointer(ptrval))
curl_easy_setopt(handle, opt, ptrval::Integer) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Clong), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}), handle, opt, ptrval)

curl_multi_setopt(handle, opt, ptrval::Array) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{Cvoid}), handle, opt, pointer(ptrval))
curl_multi_setopt(handle, opt, ptrval::Integer) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Clong), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{UInt8}), handle, opt, ptrval)

curl_easy_getinfo(handle, opt, ptrval::Array) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{Cvoid}), handle, opt, pointer(ptrval))
curl_easy_getinfo(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}), handle, opt, ptrval)

include("lC_defines_h.jl")

include("Mime_ext.jl")
export Mime_ext

end
