def a(i)
  i.each_char.reduce(0) do |f,m|
    f.send({ '(' => :succ, ')' => :pred }[m] || :itself)
  end
end
