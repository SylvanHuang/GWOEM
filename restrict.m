function[res] = restrict(src,bound)

    if(src > bound)
        res = bound;
    else
        res = src;
    end
end