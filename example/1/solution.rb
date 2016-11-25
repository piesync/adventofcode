print $stdin.each_char.reduce(0) { |f,m| f.send({ '(' => :succ, ')' => :pred }[m] || :itself) }
