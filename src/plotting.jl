
@recipe function plot(p::AbstractParticles)
    seriestype --> :histogram
    @series p.particles
end

@recipe f(::Type{<:AbstractParticles}, p::AbstractParticles) = p.particles

function handle_args(p)
    length(p.args) < 2 && throw(ArgumentError("This function is called with at least two arguments (x, y, ..."))
    x,y = p.args[1:2]
    y isa AbstractArray{<:AbstractParticles} || throw(ArgumentError("The second argument must be a vector of some kind of Particles"))
    x,y
end
@userplot Errorbarplot
@recipe function plt(p::Errorbarplot)
    x,y = handle_args(p)
    q = length(p.args) >= 3 ? p.args[3] : 0.05
    m = mean.(y)
    lower = -(quantile.(y,q)-m)
    upper = quantile.(y,1-q)-m
    yerror := (lower,upper)
    x,m
end

@userplot MCplot
@recipe function plt(p::MCplot)
    x,y = handle_args(p)
    m = Matrix(y)'
    x,m
end

@userplot Ribbonplot
@recipe function plt(p::Ribbonplot)
    x,y = handle_args(p)
    q = length(p.args) >= 3 ? p.args[3] : 2.
    m = mean.(y)
    ribbon := q*std.(y)
    x,m
end

"""
    errorbarplot(x,y,[q=0.05])

Plots a vector of particles with error bars at quantile `q`
"""
errorbarplot

"""
    mcplot(x,y,[q=0.05])

Plots all trajectories represented by a vector of particles
"""
mcplot

"""
    ribbonplot(x,y,[q=2])

Plots a vector of particles with a ribbon representing `q*std(y)`. Default width is 2σ
"""
ribbonplot
