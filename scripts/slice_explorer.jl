using SliceExplore
using Getopt
function parse_args()::SliceExploreArguments
    mode = "slice"
    dims = Vector{Int}()
    datatype = Float32
    filename = ""
    for (opt,arg) in getopt(ARGS, "i:d:t:m:")
        if opt == "-i"
            filename = arg
        elseif opt =="-d"
            push!(dims, parse(UInt64,arg))
        elseif opt =="-t"
            if arg == "float"
                datatype = Float32
            elseif arg == "double"
                datatype = Float64
            end
        elseif opt =="-m"
            mode = arg
        else
        end
    end
    @show mode, dims, datatype, filename
    args = SliceExploreArguments{datatype, length(dims)}()
    args.data = Array{datatype}(undef, dims...)
    args.mode = mode
    read!(filename, args.data)
    args
end

args = parse_args()
wait(display(slice_explorer(args)))
