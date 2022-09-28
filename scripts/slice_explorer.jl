using SliceExplore
using Getopt
function parse_args()::SliceExploreArguments
    args = SliceExploreArguments()
    for (opt,arg) in getopt(ARGS, "i:d:t:")
        if opt == "-i"
            args.filename = arg
        elseif opt =="-d"
            push!(args.dims, parse(Int,arg))
        elseif opt =="-t"
            if args == "float"
                args.type = Float32
            elseif args == "double"
                args.type = Float64
            end
        else
        end
    end
    args
end

args = parse_args()
wait(display(slice_explorer(args)))
