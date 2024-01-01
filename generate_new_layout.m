function[newLayout] = generate_new_layout(newPos, layout, N, X, Y, minDistance)

    global turbineMoved;
    newLayout = layout;
    curTurbine = ceil(rand() * N); 
    turbineMoved(curTurbine) = 1;

    %Update layout
    layout(2 * curTurbine - 1) = newPos(1);
    layout(2 * curTurbine) = newPos(2);
   
    if(isInBounds(newPos(1), newPos(2), X, Y) && ~isTooCloseToOtherNodes(layout, curTurbine, minDistance, N))         
       newLayout = layout;
    end
end

function[bool] = isInBounds(x, y, boundX, boundY)

    bool = (x >= 40) && (y >= 40) && (x <= boundX - 40) && (y <= boundY - 40);
end

function[bool] = isTooCloseToOtherNodes(layout, curTurbine, minDistance, N) 
   
    bool = 0;
    for i = 1 : N
        if(i ~= curTurbine && determineDistance(layout, curTurbine, i) < minDistance )
            bool = 1;
            break;
        end
    end
end

function[distance] = determineDistance(layout, Turbine1, Turbine2)

    xDiff = layout(2 * Turbine1-1) - layout(2 * Turbine2-1);
    yDiff = layout(2 * Turbine1) - layout(2 * Turbine2);
    distance = sqrt(xDiff * xDiff + yDiff * yDiff);
end