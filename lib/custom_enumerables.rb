module Enumerable
  def my_each
    for elem in self
      yield(elem)
    end
    self
  end

  def my_each_with_index
    index = 0
    for elem in self
      yield elem, index
      index += 1
    end
    self
  end

  def my_select
    res = []
    my_each do |elem|
      res.push(elem) if yield(elem)
    end
    res
  end

  def my_all?
    res = true
    my_each do |elem|
      res = false unless yield(elem)
    end
    res
  end

  def my_any?
    res = false
    my_each do |elem|
      res = true if yield(elem)
    end
    res
  end

  def my_none?
    res = true
    my_each do |elem|
      res = false if yield(elem)
    end
    res
  end

  def my_count
    return length unless block_given?

    total = 0
    my_each do |elem|
      total += 1 if yield(elem)
    end
    total
  end

  def my_map(proc = nil)
    res = []
    my_each { |elem| res.push proc ? proc.call(elem) : yield(elem) }
    res
  end

  def my_inject(acc = nil)
    res = acc.nil? ? first : acc
    if acc
      my_each do |elem|
        res = yield(res, elem)
      end
    else
      self[1..-1].my_each do |elem|
        res = yield(res, elem)
      end
    end
    res
  end

  def multiply_els
    my_inject { |acc, elem| acc * elem }
  end

end

puts "\nmy_each vs. each"
numbers = [1, 2, 3, 4, 5]
numbers.each  { |item| puts item }
numbers.my_each  { |item| puts item }

puts "\nmy_each_with_index vs each_with_index"
numbers = [1, 2, 3, 4, 5]
numbers.each_with_index  { |item, index| puts "#{index}: #{item}" }
numbers.my_each_with_index  { |item, index| puts "#{index}: #{item}" }

puts "\nmy_select vs select"
numbers = [1, 2, 3, 4, 5]
p numbers.select(&:odd?)
p numbers.my_select(&:odd?)

puts "\nmy_all? vs all?"
numbers = [1, 2, 3, 4, 5]
p numbers.all?(&:positive?)
p numbers.my_all?(&:positive?)
p numbers.all?(&:odd?)
p numbers.my_all?(&:odd?)

puts "\nmy_any? vs any?"
numbers = [1, 2, 3, 4, 5]
p numbers.any?(&:odd?)
p numbers.my_any?(&:odd?)
p numbers.any?(&:negative?)
p numbers.my_any?(&:negative?)

puts "\nmy_none? vs none?"
numbers = [1, 2, 3, 4, 5]
p numbers.none?(&:odd?)
p numbers.my_none?(&:odd?)
p numbers.none?(&:negative?)
p numbers.my_none?(&:negative?)

puts "\nmy_count? vs count?"
numbers = [1, 2, 3, 4, 5]
p numbers.count(&:odd?)
p numbers.my_count(&:odd?)
p numbers.count
p numbers.my_count

puts "\nmy_map vs map"
numbers = [1, 2, 3, 4, 5]
p numbers.map(&:odd?)
p numbers.my_map(&:odd?)
p(numbers.map { |elem| elem * 2 })
p(numbers.my_map { |elem| elem * 2 })

numbers = [1, 2, 3, 4, 5]
odd_proc = Proc.new { |i| i.odd? }
double_proc = Proc.new { |i| i * 2 }
p numbers.map(&:odd?)
p numbers.my_map(&:odd?)
p(numbers.map { |elem| elem * 2 })
p(numbers.my_map { |elem| elem * 2 })
puts "with procs"
p numbers.my_map(odd_proc)
p numbers.my_map(double_proc)
p numbers.my_map(double_proc, &:odd?)

puts "\nmy_inject vs inject"
numbers = [5, 6, 7, 8, 9, 10]
p(numbers.inject { |sum, n| sum + n })            #=> 45
p(numbers.my_inject { |sum, n| sum + n })            #=> 45
p(numbers.inject(1) { |product, n| product * n }) #=> 151200
p(numbers.my_inject(1) { |product, n| product * n }) #=> 151200

p numbers.multiply_els
