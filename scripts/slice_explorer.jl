using SliceExplore
using Getopt
function parse_args()::SliceExploreArguments
    args = SliceExploreArguments()
    for (opt,arg) in getopt(ARGS, "i:d:t:m:")
        if opt == "-i"
            args.filename = arg
        elseif opt =="-d"
            push!(args.dims, parse(Int,arg))
        elseif opt =="-t"
            if arg == "float"
                args.type = Float32
            elseif arg == "double"
                args.type = Float64
            end
        elseif opt =="-m"
            args.mode = arg
        else
        end
    end
    args
end

args = parse_args()
print(args)
wait(display(slice_explorer(args)))
