require 'json'
require 'stringio'
require 'pry'

n = 20
ar = [4, 5, 5, 5, 6, 6, 4, 1, 4, 4, 3, 6, 6, 3, 6, 1, 4, 5, 5, 5]

# Complete the sockMerchant function below.
def sockMerchant(n, ar)
  match_count = 0
  dup_arr = ar
  i = 0
  while i < dup_arr.length
    for j in i+1..dup_arr.length do
      if dup_arr[i] == dup_arr[j]
        match_count = match_count+1
        dup_arr.slice!(j)
        dup_arr.slice!(i)
        i = 0
        break
      end
      i = i+1 if j == dup_arr.length

    end
  end
  match_count
end

# fptr = File.open(ENV['OUTPUT_PATH'], 'w')

# n = gets.to_i

# ar = gets.rstrip.split(' ').map(&:to_i)

result = sockMerchant n, ar
puts result
# fptr.write result
# fptr.write "\n"

# fptr.close()
