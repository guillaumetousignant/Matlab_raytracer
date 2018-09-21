function newval = clamp(value, minval, maxval)
    newval = min(max(value, minval), maxval);
end