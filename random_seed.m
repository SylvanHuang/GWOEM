%produce the random key and random number
function[temp]=random_seed()

temp=clock;
temp=sum(temp(4:6))*sum(temp(2:3));
temp=round(temp/10);

end

