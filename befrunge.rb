#!/usr/bin/env ruby

W, H, d, s, x, y, e, f, t = 80, 25, [], [], -1, 0, 1, 0, false
H.times { d << [' '] * W }
open($*[0]) do |f|
  while c = f.read(1)
    if c == "\n"
      x, y = -1, y + 1
    else
      d[y][x += 1] = c
    end
  end
end

x = y = 0
while c = d[y][x]
  c = s.push(c.ord) if t && c != '"'
  case c
  when '0'..'9' then s.push(c.to_i)
  when '+' then s.push(s.pop + s.pop)
  when '-' then s.push(s.pop(2).reduce(:-))
  when '*' then s.push(s.pop * s.pop)
  when '/' then s.push(s.pop(2).reduce(:/))
  when '%' then s.push(s.pop(2).reduce(:%))
  when '!' then s.push(s.pop ? 1 : 0)
  when '`' then s.push(s.pop(2).reduce(:>) ? 1 : 0)
  when '>' then e, f = 1, 0
  when '<' then e, f = -1, 0
  when '^' then e, f = 0, -1
  when 'v' then e, f = 0, 1
  when '?' then e, f = [[1, 0], [-1, 0], [0, -1], [0, 1]].sample
  when '_' then e, f = s.pop == 0 ? [1, 0] : [-1, 0]
  when '|' then e, f = s.pop == 0 ? [0, 1] : [0, -1]
  when '"' then t ^= true
  when ':' then s.push(*s.pop(1) * 2)
  when '\\' then s.push(s.pop, s.pop)
  when '$' then s.pop
  when '.' then print s.pop, ' '
  when ',' then print s.pop.chr
  when '#' then x, y = x + e, y + f
  when 'p' then d[s.pop][s.pop] = s.pop.chr
  when 'g' then s.push(d[s.pop][s.pop].ord)
  when '&' then s.push(gets.to_i)
  when '~' then s.push(STDIN.read(1).ord)
  when '@' then break
  end
  x, y = (x + e) % W, (y + f) % H
end
