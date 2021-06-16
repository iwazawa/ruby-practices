x = 1
while x <= 20
  # 変数xを3で割った時の余りを変数yに代入
  y = x % 3
  # 変数xを5で割った時の余りを変数zに代入
  z = x % 5
    
  if y == 0 && z != 0 #3の倍数だが、5の倍数ではないとき
    puts "Fizz"
  elsif y != 0 && z == 0  #5の倍数だが、3の倍数ではとき
    puts "Buzz"
  elsif y == 0 && z == 0  #3と5両方の倍数のとき
    puts "FizzBuzz"
  else  #それ以外
    puts x
  end
  x += 1  #変数xに1を加算
end
