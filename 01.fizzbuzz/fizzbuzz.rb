(1..20).each do |x|
  if x % 15 == 0  # 15で割り切れるとき
    puts "FizzzBuzz"
  elsif x % 5 == 0  # 5で割り切れるとき
    puts "Buzz"
  elsif x % 3 == 0  # 3で割り切れるとき
    puts "Fizz"
  else
    puts x  # それ以外
  end
end