module SliceExplore

using GLMakie

mutable struct SliceExploreArguments
    filename::String
    type::Type
    dims::Array{Int}
    mode::String
end
SliceExploreArguments() = SliceExploreArguments("", Float32, [], "slice")

function slice_explorer(args::SliceExploreArguments)
    if args.mode == "slice"
        return vis_explorer(args)
    elseif args.mode == "svd"
        return svd_explorer(args)
    end
end

function vis_explorer(args::SliceExploreArguments)
    data = Array{args.type}(undef, args.dims...)
    read!(args.filename, data)
    n_slices = args.dims[end]
    min,max = extrema(data)
    fig = Figure()
    s = Slider(fig[2,1:2], range=1:1:n_slices, startvalue=round(Int,args.dims[end]/2))
    slice = lift(s.value) do v
        data[:,:, v]
    end
    slice_vec = lift(s.value) do v
        vec(data[:,:, v])
    end
    hist_title = lift(s.value) do v
        "Histogram slice $v"
    end
    img_title = lift(s.value) do v
        "SliceView slice $v"
    end
    hist_ax = Axis(fig[1,1], title=hist_title, limits=((min,max), nothing))
    hist!(hist_ax, slice_vec)
    img_ax = Axis(fig[1,2], title=img_title)
    hm = heatmap!(img_ax, slice)
    Colorbar(fig[:,end+1], hm)

    on(events(fig).keyboardbutton) do event
    if event.action == Keyboard.press || event.action == Keyboard.repeat
            if event.key == Keyboard.k
                set_close_to!(s, s.value[]+1)
            elseif event.key == Keyboard.j
                set_close_to!(s, s.value[]-1)
            end
        end
    end
    fig
end


using LinearAlgebra
using ProgressMeter
function svd_explorer(args::SliceExploreArguments)
    fig = Figure()
    data = Array{args.type}(undef, args.dims...)
    read!(args.filename, data)
    n_slices = args.dims[end]

    (svd_min, svd_max) = extrema(svd(data[:,:,1]).S) 
    @showprogress for i = 2:n_slices
        (slice_svd_min, slice_svd_max) = extrema(svd(data[:,:,i]).S) 
        svd_min = min(slice_svd_min, svd_min)
        svd_max = max(slice_svd_max, svd_max)
    end
    


    s = Slider(fig[2,1:2], range=1:1:n_slices, startvalue=round(Int,args.dims[end]/2))
    slice = lift(s.value) do v
        data[:,:, v]
    end
    slice_vec = lift(s.value) do v
        svd(data[:,:, v]).S
    end
    svd_title = lift(s.value) do v
        "SVD slice $v"
    end
    img_title = lift(s.value) do v
        "SliceView slice $v"
    end
    svd_ax = Axis(fig[1,1], title=svd_title, limits=(nothing, (svd_min, svd_max)))
    scatter!(svd_ax, slice_vec)

    img_ax = Axis(fig[1,2], title=img_title)
    hm = heatmap!(img_ax, slice)
    Colorbar(fig[:,end+1], hm)

    on(events(fig).keyboardbutton) do event
    if event.action == Keyboard.press || event.action == Keyboard.repeat
            if event.key == Keyboard.k
                set_close_to!(s, s.value[]+1)
            elseif event.key == Keyboard.j
                set_close_to!(s, s.value[]-1)
            end
        end
    end
    fig
end

export slice_explorer, SliceExploreArguments

end # module
